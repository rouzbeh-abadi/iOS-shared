//
//  TaskOperation.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 02/12/2019.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import Foundation

public class TaskOperation: Operation {

   private let task: URLSessionDataTask

   public init(task: URLSessionDataTask) {
      self.task = task
   }

   public override func start() {
      super.start()
      task.resume()
   }

   public override func main() {
      super.main()
      if isCancelled {
         task.cancel()
      }
   }

   public override func cancel() {
      super.cancel()
      task.cancel()
   }
}
