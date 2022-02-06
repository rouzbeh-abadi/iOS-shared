//
//  AppTestCase.swift
//  PiavitaTests
//
//  Created by Rouzbeh Abadi on 06.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
@testable import PIASPMShared
import XCTest

class AppTestCase: XCTestCase {

   private var timer: GenericTimer?

   private(set) var test: AbstractLogicTestCase<XCTestExpectation, XCTestCase>!

   override func setUp() {
      super.setUp()
      test = AbstractLogicTestCase<XCTestExpectation, XCTestCase>(testCase: self)
      test.setUp()
   }

   override func tearDown() {
      test.tearDown()
      stopTimer()
      super.tearDown()
   }

   func socketMessage(pathComponent: String, file: StaticString = #file, line: UInt = #line) -> [String: Any] {
      do {
         let data = try test.contentsOfTestFile(pathComponent: pathComponent)
         guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            fatalError()
         }
         let message = json["message"] as? [String: Any]
         return message ?? [:]
      } catch {
         Assert.fail(String(describing: error), file: file, line: line)
         return [:]
      }
   }

   func performTask<T>(file: StaticString = #file, line: UInt = #line,
                       workItem: (AbstractLogicTestCase<XCTestExpectation, XCTestCase>) throws -> T) throws -> T {
      do {
         return try workItem(test)
      } catch {
         Assert.shouldNeverHappen(error, file: file, line: line)
         throw error
      }
   }
}

extension AppTestCase {

   func startTimer(withTimeInterval: TimeInterval, completion: @escaping () -> Void) {
      timer = GenericTimer(repeatedTimerWithTimeInterval: withTimeInterval)
      timer?.completion = completion
      timer?.start()
   }

   func stopTimer() {
      timer?.stop()
      timer = nil
   }
}
