//
//  SecAttribute.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 07.12.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public struct SecAttribute {

   public enum Accessible: Int {

      public static let key = kSecAttrAccessible as String
      public static let humanReadableKey = "SecAttribute.Accessible"

      case always, whenUnlocked, afterFirstUnlock
      case alwaysThisDeviceOnly, whenUnlockedThisDeviceOnly, afterFirstUnlockThisDeviceOnly
      case whenPasscodeSetThisDeviceOnly

      static let allValues: [Accessible] = [always, whenUnlocked, afterFirstUnlock,
                                            alwaysThisDeviceOnly, whenUnlockedThisDeviceOnly, afterFirstUnlockThisDeviceOnly,
                                            whenPasscodeSetThisDeviceOnly]

      public var value: CFString {
         switch self {
         case .always:
            return kSecAttrAccessibleAlways
         case .whenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
         case .afterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
         case .alwaysThisDeviceOnly:
            return kSecAttrAccessibleAlwaysThisDeviceOnly
         case .whenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
         case .afterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
         case .whenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
         }
      }

      public var humanReadableValue: String {
         switch self {
         case .always:
            return "always"
         case .whenUnlocked:
            return "whenUnlocked"
         case .afterFirstUnlock:
            return "afterFirstUnlock"
         case .alwaysThisDeviceOnly:
            return "alwaysThisDeviceOnly"
         case .whenUnlockedThisDeviceOnly:
            return "whenUnlockedThisDeviceOnly"
         case .afterFirstUnlockThisDeviceOnly:
            return "afterFirstUnlockThisDeviceOnly"
         case .whenPasscodeSetThisDeviceOnly:
            return "whenPasscodeSetThisDeviceOnly"
         }
      }

      public init?(object: AnyObject) {
         if let value = object as? String, let match = Accessible.allValues.first(where: { $0.value as String == value }) {
            self = match
         } else {
            return nil
         }
      }

      public init?(pair: (String, AnyObject)) {
         guard pair.0 == Accessible.key else {
            return nil
         }
         self.init(object: pair.1)
      }

      public var pair: (String, AnyObject) {
         return (Accessible.key, value)
      }
   }
}
