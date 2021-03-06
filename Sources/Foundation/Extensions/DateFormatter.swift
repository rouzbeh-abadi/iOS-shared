//
//  DateFormatter.swift
//  Piavita
//
//  Created by Dzianis Machuha on 4/16/19.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension DateFormatter {

   public static var iso8601: DateFormatter {
      let formatter = DateFormatter()
      // See: Working with Dates and Times Using the ISO 8601 Basic and Extended Notations
      //      http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a003169814.htm
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      return formatter
   }
}
