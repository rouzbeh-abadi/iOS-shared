//
//  FileManager.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 16.12.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension FileManager {

   public enum Error: Swift.Error {
      case unexpectedOperationStatus
   }

   public static var documentsDirectory: URL {
      let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return urls[urls.count - 1]
   }

   public static var applicationSupportDirectory: URL {
      let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
      return urls[urls.count - 1]
   }

   public static var cachesDirectory: URL {
      let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
      return urls[urls.count - 1]
   }

   public static var libraryDirectory: URL {
      let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
      return urls[urls.count - 1]
   }

   public static var homeDirectory: String {
      return NSHomeDirectory()
   }
}

extension FileManager {

   public func directoryExists(atPath path: String) -> Bool {
      var isDir = ObjCBool(false)
      let isExists = fileExists(atPath: path, isDirectory: &isDir)
      return isExists && isDir.boolValue
   }

   public func directoryExists(at url: URL) -> Bool {
      return directoryExists(atPath: url.path)
   }

   public func regularFileExists(atPath path: String) -> Bool {
      var isDir = ObjCBool(false)
      let isExists = fileExists(atPath: path, isDirectory: &isDir)
      return isExists && !isDir.boolValue
   }

   public func regularFileExists(at url: URL) -> Bool {
      return regularFileExists(atPath: url.path)
   }

}

extension FileManager {

   public func createFile(atPath path: String, contents: Data?, withIntermediateDirectories: Bool) throws {
      let dirPath = (path as NSString).deletingLastPathComponent
      if !directoryExists(atPath: dirPath) {
         try createDirectory(atPath: dirPath, withIntermediateDirectories: withIntermediateDirectories)
      }
      if regularFileExists(atPath: path) {
         try removeItem(atPath: path)
      }
      let status = createFile(atPath: path, contents: contents, attributes: nil)
      if status != true {
         throw Error.unexpectedOperationStatus
      }
   }

   public func copyFile(atPath: String, toPath: String) throws {
      let dirPath = toPath.deletingLastPathComponent
      if !directoryExists(atPath: dirPath) {
         try createDirectory(atPath: dirPath, withIntermediateDirectories: true)
      } else if fileExists(atPath: toPath) {
         try removeItem(atPath: toPath)
      }
      try copyItem(atPath: atPath, toPath: toPath)
   }
}
