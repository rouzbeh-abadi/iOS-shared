//
//  DictionaryTests.swift
//  PIAFoundationTests
//
//  Created by Rouzbeh Abadi on 07.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
@testable import PIASPMShared
@testable import PIATestsShared

class DictionaryTests: AppTestCase {

   func test_dump() throws {
      Assert.equals("{\n  \"Key1\" : \"Value1\"\n}", try ["Key1": "Value1"].dump())
   }
}
