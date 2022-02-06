//
//  Operation.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 12.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension Operation {

   @discardableResult
   public func then(_ op: Operation) -> Operation {
      op.addDependency(self)
      return op
   }
}
