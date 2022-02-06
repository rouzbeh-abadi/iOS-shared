//
//  FileManagerTests.swift
//  PIAFoundationTests
//
//  Created by Rouzbeh Abadi on 06.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
@testable import PIATestsShared
@testable import PIASPMShared

class FileManagerTests: AppTestCase {

   private lazy var fixturesBundlePath = NSTemporaryDirectory()

   func test_directoryContents_accept() {
      let files = FileManager.default.recursiveContentsOfDirectory(atPath: fixturesBundlePath) { _ in
         return .accept
      }
      Assert.notEmpty(files)
   }

   func test_directoryContents_reject() {
      let files = FileManager.default.recursiveContentsOfDirectory(atPath: fixturesBundlePath) { _ in
         return .reject
      }
      Assert.isEmpty(files)
   }

   func test_directoryContents_skipDescendants() {
      let files = FileManager.default.recursiveContentsOfDirectory(atPath: fixturesBundlePath) { file in
         if file.contains("/") {
            return .skipDescendants
         } else {
            return .accept
         }
      }
      Assert.notEmpty(files)
   }

   func test_invalidPath() {
      let files = FileManager.default.recursiveContentsOfDirectory(atPath: "") { _ in
         return .init(true)
      }
      Assert.isEmpty(files)
   }
}
