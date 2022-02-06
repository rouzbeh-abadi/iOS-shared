//
//  Keychain.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 07.12.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public struct Keychain {}

extension Keychain {

   public static func dump() {
      var query: [String: AnyObject] = [:]
      query[kSecMatchLimit as String] = kSecMatchLimitAll
      query[kSecReturnAttributes as String] = kCFBooleanTrue
      query[kSecReturnData as String] = kCFBooleanFalse

      let classes = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
      for secClass in classes {
         logger.debug(.core, "Querying items for class '\(secClass)'...")
         query[kSecClass as String] = secClass

         var queryResult: AnyObject?
         let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
         }
         let items = queryResult as? [[String: AnyObject]] ?? []
         if status == errSecItemNotFound {
            logger.default(.core, "Not found SecItems for class '\(secClass)'")
         } else if status == errSecSuccess {
            for item in items {
               var message = "{\n"
               for pair in item {
                  if let attribute = SecAttribute.Accessible(pair: pair) {
                     message += "   \(SecAttribute.Accessible.humanReadableKey) => \(attribute.humanReadableValue)\n"
                  } else {
                     message += "   \(pair.key) => \(pair.value)\n"
                  }
               }
               message += "\n}"
               logger.default(.core, message)
            }
         } else {
            logger.default(.core, "Unable to read SecItem attributes for class '\(secClass)'. Status: \(status)")
         }
      }
   }
}
