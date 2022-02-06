//
//  ArrayTests.swift
//  PIAFoundationTests
//
//  Created by Rouzbeh Abadi on 07.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
@testable import PIASPMShared
@testable import PIATestsShared

class ArrayTests: AppTestCase {

   func test_orderedBy() {
      let values = ["A", "B", "C", "D", "E", "F"]
      let result = values.ordered(by: ["1", "E", "B", "10"])
      Assert.equals(result, ["E", "B", "A", "C", "D", "F"])
   }

   func test_ranges_combined_noOverlap_noJoin() {
      let result = [0 ..< 10, 20 ..< 30].combined()
      Assert.equals(result, [0 ..< 10, 20 ..< 30])
   }

   func test_ranges_combined_noOverlap_withJoin() {
      let result = [0 ..< 20, 20 ..< 30].combined()
      Assert.equals(result, [0 ..< 30])
   }

   func test_ranges_combined_withOverlap() {
      let result = [0 ..< 25, 15 ..< 30].combined()
      Assert.equals(result, [0 ..< 30])
   }

   func test_ranges_combined_withOverlap_lowerBound() {
      let result = [0 ..< 20, 0 ..< 5].combined()
      Assert.equals(result, [0 ..< 20])
   }

   func test_ranges_combined_withOverlap_upperBound() {
      let result = [0 ..< 20, 15 ..< 20].combined()
      Assert.equals(result, [0 ..< 20])
   }

   func test_ranges_combined_fullOverlap() {
      let result = [0 ..< 30, 0 ..< 30].combined()
      Assert.equals(result, [0 ..< 30])
   }
}
