//
//  ClosedRange.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 06.02.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension ClosedRange where Bound: FixedWidthInteger {

   public func shifted(by value: Bound) -> ClosedRange {
      let newValue = lowerBound + value ... upperBound + value
      return newValue
   }

   public func movingStart(by value: Bound) -> ClosedRange {
      var newLowerBound = lowerBound + value
      if newLowerBound > upperBound {
         newLowerBound = upperBound
      }
      let newValue = newLowerBound ... upperBound
      return newValue
   }

   public func movingEnd(by value: Bound) -> ClosedRange {
      var newUpperBound = upperBound + value
      if newUpperBound < lowerBound {
         newUpperBound = lowerBound
      }
      let newValue = lowerBound ... newUpperBound
      return newValue
   }
}
