//
//  UnfairLock.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 15.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

@available(iOS 10.0, OSX 10.12, *)
public final class UnfairLock {

   private var lock = os_unfair_lock()

   public init() {}

   public func synchronized<T>(_ closure: () -> T) -> T {
      os_unfair_lock_lock(&lock)
      let result = closure()
      os_unfair_lock_unlock(&lock)
      return result
   }
}
