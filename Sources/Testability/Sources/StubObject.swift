//
//  StubObject.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import CoreLocation
import Foundation

struct StubObject {

   static var uniquieString: String {
      return UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
   }

   static var uniqueInt: Int {
      return Int(Date.timeIntervalSinceReferenceDate)
   }

   static var timestamp: String {
      let timestamp = Int(Date().timeIntervalSinceReferenceDate)
      return "\(timestamp)"
   }

   /// - Parameters:
   ///   - fromString: In format "YYYY-MM-dd HH:mm"
   public static func date(fromString value: String) -> Date {
      let formatter = DateFormatter()
      formatter.timeZone = TimeZone(identifier: "UTC")
      formatter.dateFormat = "YYYY-MM-dd HH:mm"
      if let date = formatter.date(from: value) {
         return date
      } else {
         assertionFailure()
         return Date()
      }
   }
}
