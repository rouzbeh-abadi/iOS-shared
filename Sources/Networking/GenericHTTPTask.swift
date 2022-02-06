//
//  GenericHTTPTask.swift
//  PIANetworking
//
//  Created by Rouzbeh Abadi on 20.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import Foundation

class GenericHTTPTask {

   var completionHandler: Result<(Data, HTTPURLResponse)>.Completion?
   var progressHandler: ((Double) -> Void)?

   private var mTask: URLSessionDataTask
   var task: URLSessionDataTask {
      return mTask
   }

   var expectedContentLength: Int64 = 0
   var buffer = Data()
   var response: HTTPURLResponse?

   init(task: URLSessionDataTask) {
      mTask = task
   }

   deinit {
      logger.deinitialize()
   }
}

extension GenericHTTPTask: HTTPServiceTask {

   func resume() {
      task.resume()
   }

   func suspend() {
      task.suspend()
   }

   func cancel() {
      task.cancel()
   }
}
