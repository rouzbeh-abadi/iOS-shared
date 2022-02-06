//
//  AlternativeValue.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 27.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public struct AlternativeValue<T> {

   public var value: T
   public var altValue: T

   public var currentValue: T {
      return isUsedAltValue ? altValue : value
   }

   public var isUsedAltValue: Bool = false

   public init(_ aValue: T, altValue anAltValue: T) {
      value = aValue
      altValue = anAltValue
   }
}
