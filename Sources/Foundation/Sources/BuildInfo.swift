//
//  BuildInfo.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 10.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public enum BuildInfo {

   public static var isDebug: Bool {
      #if DEBUG // Do not forget to add DEBUG to Compiler Flags
      return true
      #else
      return false
      #endif
   }

   public static var isProduction = false // This value can be overriden in `main.swift` file.

   public static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

   public static var isAppStore: Bool {
      if isDebug {
         return false
      }
      if isTestFlight {
         return false
      }
      return isProduction
   }
}
