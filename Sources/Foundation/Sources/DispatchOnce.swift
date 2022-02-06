//
//  DispatchOnce.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 10.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public final class DispatchOnce {

   private var isInitialized = false

   public init() {}

   public func perform(block: () -> Void) {
      if !isInitialized {
         block()
         isInitialized = true
      }
   }
}
