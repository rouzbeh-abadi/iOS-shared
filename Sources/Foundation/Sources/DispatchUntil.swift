//
//  DispatchUntil.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 10.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public final class DispatchUntil {

   private var mIsFulfilled = false

   public var isFulfilled: Bool {
      return mIsFulfilled
   }

   public init() {}
}

extension DispatchUntil {

   public func performIfNeeded(block: () -> Void) {
      if !mIsFulfilled {
         block()
      }
   }

   public func fulfill() {
      if !mIsFulfilled {
         mIsFulfilled = true
      }
   }
}
