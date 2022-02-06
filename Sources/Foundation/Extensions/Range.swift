//
//  Range.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 20.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension Range where Bound: FixedWidthInteger {

   public func expanding(by value: Bound) -> Range {
      let newValue = lowerBound - value ..< upperBound + value
      return newValue
   }

   public func shifted(by value: Bound) -> Range {
      let newValue = lowerBound + value ..< upperBound + value
      return newValue
   }
}
