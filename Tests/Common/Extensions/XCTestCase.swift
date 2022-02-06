//
//  XCTestCase.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 03.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
import PIASPMShared
import XCTest

extension XCTestCase: TestCaseType {

   public func defaultExpectation(function: StaticString, file: StaticString, line: UInt) -> XCTestExpectation {
      return TestExpectation(function: function, file: file, line: line)
   }
}
