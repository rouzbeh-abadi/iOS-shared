//
//  Locale.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 02.12.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension Locale {

   public struct CountryInfo: Equatable {
      public let isoCode: String
      public let displayName: String
   }

   public var counrtyInfos: [CountryInfo] {
      return Locale.counrtyInfos(for: self)
   }

   public static func counrtyInfos(for locale: Locale) -> [CountryInfo] {
      let nsLocale = locale as NSLocale
      let result: [CountryInfo] = NSLocale.isoCountryCodes.compactMap {
         if let displayName = nsLocale.displayName(forKey: .countryCode, value: $0) {
            return CountryInfo(isoCode: $0, displayName: displayName)
         } else {
            return nil
         }
      }
      // Seems `isoCountryCodes` already sorted. So, we skip sorting.
      return result
   }

   public var counrtyNames: [String] {
      return Locale.counrtyNames(for: self)
   }

   public static func counrtyNames(for locale: Locale) -> [String] {
      let nsLocale = locale as NSLocale
      let result: [String] = NSLocale.isoCountryCodes.compactMap {
         return nsLocale.displayName(forKey: .countryCode, value: $0)
      }
      // Seems `isoCountryCodes` already sorted. So, we skip sorting.
      return result
   }
}
