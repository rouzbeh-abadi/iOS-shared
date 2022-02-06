//
//  ClosedRangeTests.swift
//  PIAFoundationTests
//
//  Created by Rouzbeh Abadi on 07.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
@testable import PIATestsShared
@testable import PIASPMShared

class ClosedRangeTests: AppTestCase {

   func test_shifted() {
      let range = 0 ... 1
      Assert.equals(range.shifted(by: 1), 1 ... 2)
      Assert.equals(range.shifted(by: 0), 0 ... 1)
      Assert.equals(range.shifted(by: -1), -1 ... 0)
   }

   func test_moveStart() {
      let range = 0 ... 1
      Assert.equals(range.movingStart(by: 10), 1 ... 1)
      Assert.equals(range.movingStart(by: 1), 1 ... 1)
      Assert.equals(range.movingStart(by: -10), -10 ... 1)
   }

   func test_moveEnd() {
      let range = 0 ... 1
      Assert.equals(range.movingEnd(by: 10), 0 ... 11)
      Assert.equals(range.movingEnd(by: -1), 0 ... 0)
      Assert.equals(range.movingEnd(by: -10), 0 ... 0)
   }
}
