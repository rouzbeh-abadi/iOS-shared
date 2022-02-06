//
//  AsynchronousOperation.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 23.04.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

open class AsynchronousOperation: Operation {

   private var lockOfProperties = UnfairLock()

   private var mFinished = false
   private var mExecuting = false

   public override init() {
      super.init()
   }

   deinit {
      assert(true)
   }

   /// Subclasses must launch job here.
   ///
   /// **Note** called between willChangeValueForKey and didChangeValueForKey calls, but after property mExecuting is set.
   open func onStart() {
      main()
   }

   /// Subclasses must cancel job here.
   ///
   /// **Note** called immediately after calling super.cancel().
   open func onCancel() {}

   /// Subclasses must release job here.
   ///
   /// **Note** called between willChangeValueForKey and didChangeValueForKey calls,
   /// but after properties mExecuting and mFinished are set.
   open func onFinish() {}
}

extension AsynchronousOperation {

   public final override var isAsynchronous: Bool {
      return true
   }

   public final override var isExecuting: Bool {
      return lockOfProperties.synchronized { mExecuting }
   }

   public final override var isFinished: Bool {
      return lockOfProperties.synchronized { mFinished }
   }
}

extension AsynchronousOperation {

   public final override func start() {
      if isCancelled || isFinished || isExecuting {
         return
      }
      willChangeValue(forKey: #keyPath(Operation.isExecuting))
      lockOfProperties.synchronized { mExecuting = true }
      onStart()
      didChangeValue(forKey: #keyPath(Operation.isExecuting))
   }

   public final override func cancel() {
      super.cancel()
      if isExecuting {
         onCancel()
         finish()
      } else {
         onCancel()
         lockOfProperties.synchronized {
            mExecuting = false
            mFinished = true
         }
      }
   }

   public final func finish() {
      willChangeValue(forKey: #keyPath(Operation.isExecuting))
      willChangeValue(forKey: #keyPath(Operation.isFinished))
      lockOfProperties.synchronized {
         mExecuting = false
         mFinished = true
      }
      onFinish()
      didChangeValue(forKey: #keyPath(Operation.isExecuting))
      didChangeValue(forKey: #keyPath(Operation.isFinished))
   }
}
