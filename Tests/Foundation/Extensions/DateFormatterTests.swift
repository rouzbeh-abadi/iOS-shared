//
//  DateFormatterTests.swift
//  PIAFoundationTests
//
//  Created by Rouzbeh Abadi on 06.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
@testable import PIASPMShared
@testable import PIATestsShared

class DateFormatterTests: AppTestCase {

   func test_iso8601_formatter() throws {
      let date = StubObject.date(fromString: "2020-01-07 13:25")
      let formatter = DateFormatter.iso8601
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      let string = formatter.string(from: date)
      Assert.equals(string, "2019-01-07T13:25:00.000+0000")
   }
}
