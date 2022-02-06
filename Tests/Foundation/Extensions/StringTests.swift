//
//  StringTests.swift
//  PIAFoundationTests
//
//  Created by Rouzbeh Abadi on 03.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
@testable import PIASPMShared
@testable import PIATestsShared

class StringTests: AppTestCase {

   func test_replacing_characters_array() {

      let expectedResult = "special’quote’sign’test"

      let value = "special`quote'sign’test"

      let result = value.replacingCharacters(["`", "\'"], with: "’")

      Assert.equals(expectedResult, result)
   }

   func test_rangeBetweenCharacters() {
      let string1 = "The [Name] of City"
      let range1 = string1.rangeBetweenCharacters(lower: Character("["), upper: Character("]"))
      Assert.equals(string1[range1!], "Name")

      let string2 = "[The [Name] of City]"
      let range2 = string2.rangeBetweenCharacters(lower: Character("["), upper: Character("]"))
      Assert.equals(string2[range2!], "The [Name] of City")

      let string3 = "The [Name] of City]"
      let range3 = string3.rangeBetweenCharacters(lower: Character("["), upper: Character("]"), isBackwardSearch: false)
      Assert.equals(string3[range3!], "Name")
   }

   func test_removingPrefix() {
      Assert.equals("abcd".removingPrefix("ab"), "cd")
      Assert.equals("abcd".removingPrefix("1234"), "abcd")
      Assert.equals("abcd".removingPrefix("abcd"), "")
   }

   func test_removingSuffix() {
      Assert.equals("abcd".removingSuffix("cd"), "ab")
      Assert.equals("abcd".removingSuffix("1234"), "abcd")
      Assert.equals("abcd".removingSuffix("abcd"), "")
   }

   func test_replacingFirstOccurrence() {
      Assert.equals("a123bcd123".replacingFirstOccurrence(of: "123", with: "-"), "a-bcd123")
   }

   func test_replacingLastOccurrence() {
      Assert.equals("123a123bcd".replacingLastOccurrence(of: "123", with: "-"), "123a-bcd")
   }
}
