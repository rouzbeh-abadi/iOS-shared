//
//  AssertType.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 25.06.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public protocol AssertType {
   func fail(_ message: String, file: StaticString, line: UInt)
   func shouldNeverHappen(_ error: Swift.Error, file: StaticString, line: UInt)
   func notNil<T>(_ value: T?, _ message: Any?, file: StaticString, line: UInt)
   func notEmpty(_ value: String?, file: StaticString, line: UInt)
   func notEmpty<T>(_ value: [T], _ message: Any?, file: StaticString, line: UInt)
   func equals<T: Equatable>(_ lhs: T, _ rhs: T, file: StaticString, line: UInt)
}
