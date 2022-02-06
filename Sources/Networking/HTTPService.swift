//
//  HTTPService.swift
//  PIANetworking
//
//  Created by Rouzbeh Abadi on 19.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import Foundation

public class HTTPService: NSObject {

   private lazy var session: URLSession = setupSession()

   private var tasks = [GenericHTTPTask]()

   public static let shared = HTTPService()

   private override init() {
      super.init()
   }

   public func upload(request: URLRequest, data: Data) -> HTTPServiceTask {
      let task = session.uploadTask(with: request, from: data)
      let genericTask = GenericHTTPTask(task: task)
      tasks.append(genericTask)
      return genericTask
   }
}

extension HTTPService {

   private func setupSession() -> URLSession {
      let configuration = URLSessionConfiguration.default
      let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
      return session
   }
}

extension HTTPService: URLSessionTaskDelegate {

   public func urlSession(_ session: URLSession,
                          task: URLSessionTask,
                          didSendBodyData bytesSent: Int64,
                          totalBytesSent: Int64,
                          totalBytesExpectedToSend: Int64) {
      guard let task = tasks.first(where: { $0.task == task }) else {
         return
      }

      let percentageDownloaded = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
      DispatchQueue.main.async {
         task.progressHandler?(percentageDownloaded)
      }
   }
}

extension HTTPService: URLSessionDataDelegate {

   public func urlSession(_ session: URLSession,
                          dataTask: URLSessionDataTask,
                          didReceive response: URLResponse,
                          completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

      guard let task = tasks.first(where: { $0.task == dataTask }) else {
         completionHandler(.cancel)
         return
      }
      task.response = response as? HTTPURLResponse
      task.expectedContentLength = response.expectedContentLength
      completionHandler(.allow)
   }

   public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
      guard let task = tasks.first(where: { $0.task == dataTask }) else {
         return
      }
      task.buffer.append(data)
      guard task.expectedContentLength >= 0 else {
         return
      }
      let percentageDownloaded = Double(task.buffer.count) / Double(task.expectedContentLength)
      DispatchQueue.main.async {
         task.progressHandler?(percentageDownloaded)
      }
   }

   public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
      guard let index = tasks.firstIndex(where: { $0.task == task }) else {
         return
      }
      let task = tasks.remove(at: index)
      DispatchQueue.main.async {
         if let error = error {
            task.completionHandler?(.error(error))
         } else {
            if let response = task.response {
               task.completionHandler?(.success((task.buffer, response)))
            } else {
               task.completionHandler?(.error(ResponseError.notHTTPResponse))
            }
         }
      }
   }
}
