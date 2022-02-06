//
//  AccessibilityKey.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 02.10.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public protocol AccessibilityKey {
   var accessibilityKey: String { get }
}

extension RawRepresentable where Self: AccessibilityKey, Self.RawValue == String {
   public var accessibilityKey: String {
      return rawValue
   }
}

extension String: AccessibilityKey {
   public var accessibilityKey: String { return self }
}
