//
//  UIAccessibilityIdentification.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 02.10.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UIAccessibilityIdentification {

   public var accessibilityKey: AccessibilityKey {
      get {
         if let value = accessibilityIdentifier {
            return value
         } else {
            assertionFailure()
            return ""
         }
      } set {
         accessibilityIdentifier = newValue.accessibilityKey
      }
   }
}

#endif
