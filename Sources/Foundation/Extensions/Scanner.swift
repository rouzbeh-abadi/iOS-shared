//
//  Scanner.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 10.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import CoreGraphics
import Foundation

extension Scanner {

   public func scanUpToCharacters(from set: CharacterSet) -> String? {
      var result: NSString?
      if scanUpToCharacters(from: set, into: &result), let value = result {
         return value as String
      } else {
         return nil
      }
   }

   public func scanCharacters(from set: CharacterSet) -> String? {
      var result: NSString?
      if scanCharacters(from: set, into: &result), let value = result {
         return value as String
      } else {
         return nil
      }
   }

   public func scanUpTo(string: String) -> String? {
      var result: NSString?
      if scanUpTo(string, into: &result), let value = result {
         return value as String
      } else {
         return nil
      }
   }

   public func scanString(_ string: String) -> String? {
      var result: NSString?
      if scanString(string, into: &result), let value = result {
         return value as String
      } else {
         return nil
      }
   }

   public func scanDouble() -> Double? {
      var value: Double = 0
      return scanDouble(&value) ? value : nil
   }

   public func scanFloat() -> Float? {
      var value: Float = 0
      return scanFloat(&value) ? value : nil
   }

   public func scanCGFloat() -> CGFloat? {
      var value: Float = 0
      return scanFloat(&value) ? CGFloat(value) : nil
   }

   public func scanInt() -> Int? {
      var value: Int = 0
      return scanInt(&value) ? value : nil
   }

   public static func scanCGFloat(_ string: String) -> CGFloat? {
      return Scanner(string: string).scanCGFloat()
   }

   public static func scanCGFloat(_ substring: Substring) -> CGFloat? {
      return Scanner(string: String(substring)).scanCGFloat()
   }
}
