//
//  Data.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 30.10.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension Data {

   public class Ext {
      fileprivate let instance: Data
      fileprivate init(instance: Data) {
         self.instance = instance
      }
   }

   public var ext: Ext {
      return Ext(instance: self)
   }
}

extension Data.Ext {

   public enum Error: Swift.Error {
      case unableToEncodeToStringUsingEncoding(String.Encoding)
   }

   public func string(using encoding: String.Encoding) -> String? {
      return String(data: self.instance, encoding: encoding)
   }

   public func throwingString(using encoding: String.Encoding) throws -> String {
      if let value = string(using: encoding) {
         return value
      } else {
         throw Error.unableToEncodeToStringUsingEncoding(encoding)
      }
   }
}

extension Data {

   public var hexString: String {
      return map { String(format: "%02.2hhx", $0) }.reduce("", { $0 + $1 })
   }

   public mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
      }
   }
}
