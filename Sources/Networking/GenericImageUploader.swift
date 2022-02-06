//
//  GenericImageUploader.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 20.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import Foundation

open class GenericImageUploader {

   let uploadService: Request

   public init(uploadService: Request) {
      self.uploadService = uploadService
   }
}

extension GenericImageUploader {

   public func uploadTask(imageData: Data, filePathKey: String,
                   completion: @escaping Result<(Data, HTTPURLResponse)>.Completion) -> HTTPServiceTask? {
      var request: URLRequest
      do {
         request = try uploadService.toURLRequest()
      } catch {
         completion(.error(error))
         return nil
      }

      let info = FileInfo(data: imageData)
      logger.debug(.request, "Performing request: [\(uploadService.method)] \(request.url?.absoluteString ?? "Unknown")")

      let boundary = "Boundary-\(UUID().uuidString)"
      let body = createBody(parameters: nil, filePathKey: filePathKey, filesInfo: [info], boundary: boundary)
      request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

      let task = HTTPService.shared.upload(request: request, data: body)
      task.completionHandler = {
         switch $0 {
         case .error(let error):
            completion(.error(error))
         case .success(let response):
            completion(.success(response))
         }
      }
      return task
   }
}

extension GenericImageUploader {

   private struct FileInfo {

      let data: Data
      let name: String
      let mimeType: String

      init(data: Data) {
         self.data = data
         let ext = FileInfo.fileType(from: data)
         name = "ios-image." + ext
         mimeType = "image/" + ext
      }

      // See also: https://stackoverflow.com/questions/4147311/finding-image-type-from-nsdata-or-uiimage
      private static func fileType(from data: Data) -> String {
         var result = "jpeg"
         guard !data.isEmpty else {
            return result
         }
         switch data[0] {
         case 0xFF:
            result = "jpeg"
         case 0x89:
            result = "png"
         case 0x47:
            result = "gif"
         case 0x49, 0x4D:
            result = "tiff"
         default:
            break
         }
         return result
      }
   }

   /// See also: https://stackoverflow.com/q/44799133/1418981
   private func createBody(parameters: [String: String]?, filePathKey: String,
                           filesInfo: [FileInfo], boundary: String) -> Data {
      var body = Data()

      for (key, value) in parameters ?? [:] {
         body.append("--\(boundary)\r\n")
         body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
         body.append("\(value)\r\n")
      }

      for item in filesInfo {
         body.append("--\(boundary)\r\n")
         body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(item.name)\"\r\n")
         body.append("Content-Type: \(item.mimeType)\r\n\r\n")
         body.append(item.data)
         body.append("\r\n")
      }

      body.append("--\(boundary)--\r\n")
      return body
   }
}
