//
//  TestExpectation.swift
//  PiavitaTests
//
//  Created by Rouzbeh Abadi on 02.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
import XCTest

class TestExpectation: XCTestExpectation {

   private var fulfillmentCount = 0

   private let file: StaticString
   private let line: UInt
   private let function: StaticString

   init(function: StaticString, file: StaticString, line: UInt) {
      self.file = file
      self.line = line
      self.function = function
      super.init(description: "\(function) @ \(file):\(line)")
   }

   override func fulfill() {
      fulfillmentCount += 1
      if fulfillmentCount > expectedFulfillmentCount {
         XCTFail("Expectation fulfilled \(fulfillmentCount) times while \(expectedFulfillmentCount) is expected.",
                 file: file, line: line)
      }
      super.fulfill()
   }
}
