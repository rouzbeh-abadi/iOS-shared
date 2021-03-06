//
//  Screenshot.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 27.12.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

public class Screenshot {

   /// Value in range 0...100 %
   public typealias Percentage = Float

   enum Error: Swift.Error {
      case unableToGetUIImageFromData
      case unableToGetCGImageFromData
      case unableToGetColorSpaceFromCGImage
      case imagesHasDifferentSizes
      case unableToInitializeContext
   }

   private let fixturesBundlePath: String
   private let localFixturesBundlePath: String
   private let pathComponent: String
   private let isLocalRun: Bool

   private let format: UIGraphicsImageRendererFormat
   private lazy var screenshot = getScreenshot() // Used just for Debug purpose.
   private lazy var data = getData()

   private let isLocalFileExists: Bool
   private let candidateFilePath: String
   private let diffFilePath: String

   let view: UIView
   let fixtureFilePath: String
   public let localFixtureFilePath: String

   init(view: UIView, pathComponent: String, fixturesBundlePath: String, localFixturesBundlePath: String) {
      self.view = view
      self.pathComponent = pathComponent
      self.fixturesBundlePath = fixturesBundlePath
      self.localFixturesBundlePath = localFixturesBundlePath

      fixtureFilePath = fixturesBundlePath.appendingPathComponent(pathComponent)
      localFixtureFilePath = localFixturesBundlePath.appendingPathComponent(pathComponent)
      isLocalRun = FileManager.default.fileExists(atPath: localFixturesBundlePath)

      if isLocalRun {
         isLocalFileExists = FileManager.default.fileExists(atPath: localFixtureFilePath)
      } else {
         isLocalFileExists = FileManager.default.fileExists(atPath: fixtureFilePath)
      }

      format = UIGraphicsImageRendererFormat()
      if #available(iOS 12.0, *) {
         format.preferredRange = .standard
      } else {
         format.prefersExtendedRange = false
      }
      format.opaque = true

      // We can't override existing fixture. So, we need to alter file name.
      let ext = localFixtureFilePath.pathExtension
      do {
         let path = localFixtureFilePath.deletingPathExtension + "-candidate"
         candidateFilePath = path.appendingPathExtension(ext) ?? path
      }
      do {
         let path = localFixtureFilePath.deletingPathExtension + "-diff"
         diffFilePath = path.appendingPathExtension(ext) ?? path
      }
   }
}

extension Screenshot {

   public func saveReference() throws {
      if isLocalRun {
         let fileManager = FileManager.default
         let dirPath = localFixtureFilePath.deletingLastPathComponent
         if !fileManager.directoryExists(atPath: dirPath) {
            try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
         }
         let status = fileManager.createFile(atPath: localFixtureFilePath, contents: data, attributes: [.extensionHidden: false])
         assert(status)
      }
   }

   public var isFixtureExists: Bool {
      if isLocalRun, !isLocalFileExists {
         do {
            try saveFixtureCandidate()
         } catch {
            TestSettings.shared.assert.shouldNeverHappen(error, file: #file, line: #line)
         }
      }
      return isLocalFileExists
   }

   public func compare(tolerance: Float) throws -> Bool {
      do {
         try deleteFixtureCandidate()
         try deleteFixtureDiff()
         let url = URL(fileURLWithPath: fixtureFilePath)
         let expected = try Data(contentsOf: url)
         let result = try compare(tolerance: tolerance, expected: expected, observed: data)
         if !result {
            try saveFixtureCandidate()
            // Disabled. Please use Image magic compare.
            // try saveFixtureDiff()
         }
         return result
      } catch {
         try saveFixtureCandidate()
         throw error
      }
   }
}

extension Screenshot {

   // See:
   // - https://github.com/facebookarchive/ios-snapshot-test-case/blob/master/FBSnapshotTestCase/Categories/UIImage%2BCompare.m
   private func compare(tolerance: Percentage, expected: Data, observed: Data) throws -> Bool {
      guard let expectedUIImage = UIImage(data: expected), let observedUIImage = UIImage(data: observed) else {
         throw Error.unableToGetUIImageFromData
      }
      guard let expectedCGImage = expectedUIImage.cgImage, let observedCGImage = observedUIImage.cgImage else {
         throw Error.unableToGetCGImageFromData
      }
      guard let expectedColorSpace = expectedCGImage.colorSpace, let observedColorSpace = observedCGImage.colorSpace else {
         throw Error.unableToGetColorSpaceFromCGImage
      }
      if expectedCGImage.width != observedCGImage.width || expectedCGImage.height != observedCGImage.height {
         throw Error.imagesHasDifferentSizes
      }
      let imageSize = CGSize(width: expectedCGImage.width, height: expectedCGImage.height)
      let numberOfPixels = Int(imageSize.width * imageSize.height)

      // Checking that our `UInt32` buffer has same number of bytes as image has.
      let bytesPerRow = min(expectedCGImage.bytesPerRow, observedCGImage.bytesPerRow)
      assert(MemoryLayout<UInt32>.stride == bytesPerRow / Int(imageSize.width))

      let expectedPixels = UnsafeMutablePointer<UInt32>.allocate(capacity: numberOfPixels)
      let observedPixels = UnsafeMutablePointer<UInt32>.allocate(capacity: numberOfPixels)

      let expectedPixelsRaw = UnsafeMutableRawPointer(expectedPixels)
      let observedPixelsRaw = UnsafeMutableRawPointer(observedPixels)

      let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
      guard let expectedContext = CGContext(data: expectedPixelsRaw, width: Int(imageSize.width), height: Int(imageSize.height),
                                            bitsPerComponent: expectedCGImage.bitsPerComponent, bytesPerRow: bytesPerRow,
                                            space: expectedColorSpace, bitmapInfo: bitmapInfo.rawValue) else {
         expectedPixels.deallocate()
         observedPixels.deallocate()
         throw Error.unableToInitializeContext
      }
      guard let observedContext = CGContext(data: observedPixelsRaw, width: Int(imageSize.width), height: Int(imageSize.height),
                                            bitsPerComponent: observedCGImage.bitsPerComponent, bytesPerRow: bytesPerRow,
                                            space: observedColorSpace, bitmapInfo: bitmapInfo.rawValue) else {
         expectedPixels.deallocate()
         observedPixels.deallocate()
         throw Error.unableToInitializeContext
      }

      expectedContext.draw(expectedCGImage, in: CGRect(origin: .zero, size: imageSize))
      observedContext.draw(observedCGImage, in: CGRect(origin: .zero, size: imageSize))

      let expectedBuffer = UnsafeBufferPointer(start: expectedPixels, count: numberOfPixels)
      let observedBuffer = UnsafeBufferPointer(start: observedPixels, count: numberOfPixels)

      var isEqual = true
      if tolerance == 0 {
         isEqual = expectedBuffer.elementsEqual(observedBuffer)
      } else {
         // Go through each pixel in turn and see if it is different
         let maxAllowedNumberOfDifferentPixels = Int(Float(numberOfPixels) * 0.01 * tolerance)
         var numDiffPixels = 0
         for pixel in 0 ..< numberOfPixels where expectedBuffer[pixel] != observedBuffer[pixel] {
            // If this pixel is different, increment the pixel diff count and see if we have hit our limit.
            numDiffPixels += 1
            if numDiffPixels > maxAllowedNumberOfDifferentPixels {
               isEqual = false
               break
            }
         }
      }

      expectedPixels.deallocate()
      observedPixels.deallocate()

      return isEqual
   }

   private func saveFixtureCandidate() throws {
      let fileManager = FileManager.default
      let dirPath = candidateFilePath.deletingLastPathComponent
      if !fileManager.directoryExists(atPath: dirPath) {
         try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
      }
      let status = fileManager.createFile(atPath: candidateFilePath, contents: data, attributes: [.extensionHidden: false])
      assert(status)
   }

   private func saveFixtureDiff() throws {
      let fileManager = FileManager.default
      let dirPath = diffFilePath.deletingLastPathComponent
      if !fileManager.directoryExists(atPath: dirPath) {
         try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
      }
      let url = URL(fileURLWithPath: fixtureFilePath)
      let expected = try Data(contentsOf: url)
      let diffData = try difference(expected: expected, observed: data)
      let status = fileManager.createFile(atPath: diffFilePath, contents: diffData, attributes: [.extensionHidden: false])
      assert(status)
   }

   private func difference(expected: Data, observed: Data) throws -> Data {
      guard let expected = UIImage(data: expected, scale: UIScreen.main.scale) else {
         throw Error.unableToGetUIImageFromData
      }
      guard let observed = UIImage(data: observed, scale: UIScreen.main.scale) else {
         throw Error.unableToGetUIImageFromData
      }

      let size = max(expected.size, observed.size)
      let rect = CGRect(origin: CGPoint(), size: size)
      let renderer = UIGraphicsImageRenderer(size: size)
      let result = renderer.pngData { ctx in
         UIColor.black.set()
         ctx.fill(rect)
         // See also: iPhone & iPad Layer Blending Modes Explained – Appotography: http://bit.ly/2vqfTWu
         expected.draw(in: rect, blendMode: .normal, alpha: 1)
         observed.draw(in: rect, blendMode: .difference, alpha: 1)
      }
      return result
   }

   private func deleteFixtureCandidate() throws {
      let fileManager = FileManager.default
      if fileManager.regularFileExists(atPath: candidateFilePath) {
         try fileManager.removeItem(atPath: candidateFilePath)
      }
   }

   private func deleteFixtureDiff() throws {
      let fileManager = FileManager.default
      if fileManager.regularFileExists(atPath: diffFilePath) {
         try fileManager.removeItem(atPath: diffFilePath)
      }
   }

   private func getData() -> Data {
      let rect = view.bounds
      let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
      let data = renderer.pngData { context in
         view.drawHierarchy(in: rect, afterScreenUpdates: true)
         view.layer.draw(in: context.cgContext)
      }
      return data
   }

   private func getScreenshot() -> UIImage {
      let renderer = UIGraphicsImageRenderer(size: view.bounds.size, format: format)
      let image = renderer.image { context in
         view.layer.draw(in: context.cgContext)
      }
      return image
   }
}
#endif
