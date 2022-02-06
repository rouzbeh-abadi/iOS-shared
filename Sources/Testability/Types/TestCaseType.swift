//
//  TestCaseType.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 25.06.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public protocol TestCaseType: class {

   associatedtype Expectation: ExpectationType

   func expectation(description: String) -> Expectation
   func expectation(forNotification notificationName: NSNotification.Name, object objectToObserve: Any?,
                    handler: ((Notification) -> Bool)?) -> Expectation
   func wait(for: [Expectation], timeout: TimeInterval, enforceOrder: Bool)

   func defaultExpectation(function: StaticString, file: StaticString, line: UInt) -> Expectation
}
