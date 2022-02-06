//
//  FixedWidthInteger.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 25.08.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension FixedWidthInteger {

   public func subtractingIgnoringOverflow(_ rhs: Self) -> Self {
      let (partialValue, overflow) = subtractingReportingOverflow(rhs)
      if overflow {
         logger.info(.core, "Substract operation caused overflow \(partialValue)")
         return 0
      } else {
         return partialValue
      }
   }
}
