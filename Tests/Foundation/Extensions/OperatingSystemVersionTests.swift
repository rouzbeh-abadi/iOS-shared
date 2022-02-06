//
//  OperatingSystemVersionTests.swift
//  PIAFoundationTests
//
//  Created by Rouzbeh Abadi on 03.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
@testable import PIASPMShared
@testable import PIATestsShared

class OperatingSystemVersionTests: AppTestCase {

   func test_init() {
      var version = OperatingSystemVersion(string: "1")
      Assert.equals(version?.majorVersion, 1)
      Assert.equals(version?.minorVersion, 0)
      Assert.equals(version?.patchVersion, 0)

      version = OperatingSystemVersion(string: "1.1")
      Assert.equals(version?.majorVersion, 1)
      Assert.equals(version?.minorVersion, 1)
      Assert.equals(version?.patchVersion, 0)

      version = OperatingSystemVersion(string: "1.1.1")
      Assert.equals(version?.majorVersion, 1)
      Assert.equals(version?.minorVersion, 1)
      Assert.equals(version?.patchVersion, 1)

      version = OperatingSystemVersion(string: "1.1.1.1")
      Assert.isNil(version)

      version = OperatingSystemVersion(string: "")
      Assert.isNil(version)
   }

   func test_compare() {
      Assert.true(OperatingSystemVersion(majorVersion: 1)
         < OperatingSystemVersion(majorVersion: 2))
      Assert.true(OperatingSystemVersion(majorVersion: 1, minorVersion: 1)
         < OperatingSystemVersion(majorVersion: 1, minorVersion: 2))
      Assert.true(OperatingSystemVersion(majorVersion: 1, minorVersion: 1, patchVersion: 1)
         < OperatingSystemVersion(majorVersion: 1, minorVersion: 1, patchVersion: 2))

      Assert.equals(OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3),
                    OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3))
   }

   func test_stringValue() {
      Assert.equals(OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3).string(separator: "."), "1.2.3")
   }
}
