//
//  TestStubbedEnvironment.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public protocol TestStubbedEnvironment {

   var numberOfStubs: Int { get }
   func removeAllSubs()

   func addStub(isURL: @escaping (URL) -> Bool, statusCode: Int, response: @escaping ((URLRequest) throws -> Data))
   func addStub(statusCode: Int, data: Data)
   func addStub(isURL: @escaping (URL) -> Bool, failure: Swift.Error)
   func addStub(isQuery: @escaping (String) -> Bool, statusCode: Int, fileAtPath: String)
   func addInfiniteResponseStub(isQuery: @escaping (String) -> Bool, cancelHandler: (() -> Void)?)
   func addInfiniteResponseStub(isURL: @escaping (URL) -> Bool, cancelHandler: (() -> Void)?)
}
