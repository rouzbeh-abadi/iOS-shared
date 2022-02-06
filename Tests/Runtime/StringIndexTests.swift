//
//  StringIndexTests.swift
//  PIAFoundationTests
//
//  Created by Rouzbeh Abadi on 02.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
@testable import PIASPMShared
@testable import PIATestsShared

class StringIndexTests: AppTestCase {

   func test_offset() {
      let string = "Hello!"
      Assert.equals(string[string.startIndex.shifting(by: 4, in: string)], "o")
   }
}
