//
//  AbstractLogicTestCase.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

open class AbstractLogicTestCase<Expectation, TestCase: TestCaseType> where TestCase.Expectation == Expectation {

   public var stubbedEnvironment: TestStubbedEnvironment {
      return TestSettings.shared.stubbedEnvironment
   }

   public var testBundleName: String {
      return "Data.bundle"
   }

   lazy var testCaseBundle = Bundle(for: type(of: testCase))
   lazy var testDataBundlePath = testCaseBundle.resourcePath! + "/" + testBundleName
   lazy var testCaseBundleID = testCaseBundle.bundleIdentifier!
   lazy var testCaseClassName = NSStringFromClass(type(of: testCase)).components(separatedBy: ".").last!
   lazy var testCaseDirectoryPath = testDataBundlePath + "/" + testCaseClassName
   lazy var testTemporaryDirectoryPath = NSTemporaryDirectory() + "/" + testCaseBundleID + "/" + testCaseClassName

   let testCase: TestCase
   var assert: AssertType {
      return TestSettings.shared.assert
   }

   public init(testCase: TestCase) {
      self.testCase = testCase
   }

   public var defaultExpectationTimeout: TimeInterval {
      var value: TimeInterval = stubbedEnvironment.numberOfStubs > 0 ? 30 : 60
      if TestSettings.shared.testEnvironment.isUnderPlaygroundTesting {
         value = 600
      }
      return value
   }

   lazy var operationQueue: OperationQueue = {
      let queue = OperationQueue()
      queue.qualityOfService = .userInitiated
      queue.name = "com.testability.TestQueue"
      return queue
   }()

   open func setUp() {
      stubbedEnvironment.removeAllSubs()
      cleanupEnvironment()
   }

   open func tearDown() {
      stubbedEnvironment.removeAllSubs()
      cleanupEnvironment()
   }

   open func cleanupEnvironment() {
      // Base class does nothing.
   }
}

extension AbstractLogicTestCase {

   func wait(expectation: Expectation) {
      testCase.wait(for: [expectation], timeout: defaultExpectationTimeout, enforceOrder: false)
   }

   func wait(expectations: [Expectation]) {
      testCase.wait(for: expectations, timeout: defaultExpectationTimeout, enforceOrder: false)
   }
}

extension AbstractLogicTestCase {

   public func testTask(function: StaticString = #function,
                        file: StaticString = #file, line: UInt = #line, closure: (Expectation?) throws -> Void) {
      let exp = testCase.defaultExpectation(function: function, file: file, line: line)
      weak var weakExp = exp
      do {
         try closure(weakExp)
         wait(expectation: exp)
         weakExp = nil
      } catch {
         assert.fail(error.localizedDescription, file: file, line: line)
      }
   }

   public func testDisposable(function: StaticString = #function,
                              file: StaticString = #file, line: UInt = #line, closure: (Expectation?) throws -> Disposable) {
      let exp = testCase.defaultExpectation(function: function, file: file, line: line)
      weak var weakExp = exp
      do {
         let token = try closure(weakExp)
         wait(expectation: exp)
         weakExp = nil
         token.dispose()
      } catch {
         assert.fail(error.localizedDescription, file: file, line: line)
      }
   }

   public func wait(observable: ObservableProperty<Bool>, configure: () -> Void, file: StaticString = #file, line: UInt = #line) {
      testDisposable { exp in
         let token = observable.addObserver(on: .main) {
            exp?.fulfill(if: !$0)
         }
         configure()
         return token
      }
   }

   public func testTask(notification: NSNotification.Name, file: StaticString = #file, line: UInt = #line,
                        closure: @escaping () throws -> Void) {
      let exp = testCase.expectation(forNotification: notification, object: nil, handler: nil)
      do {
         try closure()
         wait(expectation: exp)
      } catch {
         assert.fail(error.localizedDescription, file: file, line: line)
      }
   }

   public func testRequest(file: StaticString = #file, line: UInt = #line, closure: (Expectation?) throws -> TestWorkItem) {
      let exp = testCase.expectation(description: #function)
      weak var weakExp = exp
      do {
         let task = try closure(weakExp)
         task.resume()
         wait(expectation: exp)
         weakExp = nil
      } catch {
         assert.fail(error.localizedDescription, file: file, line: line)
         exp.fulfill()
      }
   }

   public func testOperation(file: StaticString = #file, line: UInt = #line, closure: () throws -> Operation) {
      let exp = testCase.expectation(description: #function)
      weak var weakExp = exp
      do {
         let operation = try closure()
         operation.completionBlock = {
            weakExp?.fulfill()
         }
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // Small timeout to support cancellation.
            self.operationQueue.addOperation(operation)
         }
         wait(expectation: exp)
         weakExp = nil
      } catch {
         assert.fail(error.localizedDescription, file: file, line: line)
         exp.fulfill()
      }
   }

   public func testOperation(file: StaticString = #file, line: UInt = #line, closure: (Expectation?) throws -> Operation) {
      let exp = testCase.expectation(description: #function)
      weak var weakExp = exp
      do {
         let operation = try closure(weakExp)
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // Small timeout to support cancellation.
            self.operationQueue.addOperation(operation)
         }
         wait(expectation: exp)
         weakExp = nil
      } catch {
         assert.fail(error.localizedDescription, file: file, line: line)
         exp.fulfill()
      }
   }
}

extension AbstractLogicTestCase {

   func createTemporaryTestDirectory() {
      let fm = FileManager.default
      do {
         try fm.createDirectory(atPath: testTemporaryDirectoryPath, withIntermediateDirectories: true, attributes: nil)
      } catch {
         fatalError()
      }
   }

   func removeTemporaryTestDirectory() {
      let fm = FileManager.default
      var isDir = ObjCBool(false)
      let isExists = fm.fileExists(atPath: testTemporaryDirectoryPath, isDirectory: &isDir)
      if isExists, isDir.boolValue {
         _ = try? fm.removeItem(atPath: testTemporaryDirectoryPath)
      }
   }

   public func decodeTestFile<T>(pathComponent: String, decoder: JSONDecoder = JSONDecoder.makeDefault(),
                                 file: StaticString = #file, line: UInt = #line) throws -> T where T: Decodable {
      do {
         let data = try contentsOfTestFile(pathComponent: pathComponent)
         let result = try decoder.decode(T.self, from: data)
         return result
      } catch {
         assert.shouldNeverHappen(error, file: file, line: line)
         throw error
      }
   }

   public func contentsOfTestFile(pathComponent: String) throws -> Data {
      return try TestSettings.shared.fixture.data(of: .api, pathComponent: pathComponent)
   }

   public func dataContents(pathComponent: String, file: StaticString = #file, line: UInt = #line) -> Data {
      do {
         return try TestSettings.shared.fixture.data(of: .api, pathComponent: pathComponent)
      } catch {
         assert.fail(String(describing: error), file: file, line: line)
         return Data()
      }
   }

   public func stringContentsOfTestFile(pathComponent: String) throws -> String {
      let data = try contentsOfTestFile(pathComponent: pathComponent)
      if let string = String(data: data, encoding: .utf8) {
         return string
      } else {
         fatalError()
      }
   }

   public func dictionaryContentsOfTestFile(pathComponent: String, file: StaticString = #file,
                                            line: UInt = #line) -> [AnyHashable: Any] {
      do {
         let data = try contentsOfTestFile(pathComponent: pathComponent)
         guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any] else {
            fatalError()
         }
         return json
      } catch {
         assert.fail(String(describing: error), file: file, line: line)
         return [:]
      }
   }

   public func jsonValue(pathComponent: String, file: StaticString = #file, line: UInt = #line) -> [String: Any] {
      do {
         let data = try contentsOfTestFile(pathComponent: pathComponent)
         guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            fatalError()
         }
         return json
      } catch {
         assert.fail(String(describing: error), file: file, line: line)
         return [:]
      }
   }

   public func jsonArrayOfTestFile(pathComponent: String, file: StaticString = #file,
                                   line: UInt = #line) -> [[AnyHashable: Any]] {
      do {
         let data = try contentsOfTestFile(pathComponent: pathComponent)
         guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[AnyHashable: Any]] else {
            fatalError()
         }
         return json
      } catch {
         assert.fail(String(describing: error), file: file, line: line)
         return []
      }
   }
}

// Just exposing methods for less typing.
extension AbstractLogicTestCase {

   func addStub(statusCode: Int, fileAtPath: String) throws {
      let url = URL(fileURLWithPath: fileAtPath)
      let data = try Data(contentsOf: url)
      stubbedEnvironment.addStub(statusCode: statusCode, data: data)
   }

   public func addStub(failure: Error) {
      stubbedEnvironment.addStub(isURL: { _ in true }, failure: failure)
   }

   public func addStub(isURL: @escaping (URL) -> Bool, failure: Error) {
      stubbedEnvironment.addStub(isURL: isURL, failure: failure)
   }

   func addStub(isURL: @escaping (URL) -> Bool, statusCode: Int, fileAtPath: String) throws {
      let url = URL(fileURLWithPath: fileAtPath)
      let data = try Data(contentsOf: url)
      stubbedEnvironment.addStub(isURL: isURL, statusCode: statusCode, response: { _ in return data })
   }

   func addStub(isQuery: @escaping (String) -> Bool, statusCode: Int, fileAtPath: String) throws {
      stubbedEnvironment.addStub(isQuery: isQuery, statusCode: statusCode, fileAtPath: fileAtPath)
   }

   func addInfiniteResponseStub(isQuery: @escaping (String) -> Bool, cancelHandler: (() -> Void)?) {
      stubbedEnvironment.addInfiniteResponseStub(isQuery: isQuery, cancelHandler: cancelHandler)
   }

   func addInfiniteResponseStub(isURL: @escaping (URL) -> Bool, cancelHandler: (() -> Void)?) {
      stubbedEnvironment.addInfiniteResponseStub(isURL: isURL, cancelHandler: cancelHandler)
   }
}

extension AbstractLogicTestCase {

   public func addStub(isURL: @escaping (URL) -> Bool = { _ in true }, statusCode: Int = 200, json: Any,
                       file: StaticString = #file, line: UInt = #line) {
      do {
         let data = try JSONSerialization.data(withJSONObject: json, options: [])
         stubbedEnvironment.addStub(isURL: isURL, statusCode: statusCode, response: { _ in return data })
      } catch {
         assert.fail(String(describing: error), file: file, line: line)
      }
   }

   public func addStub(isURL: @escaping (URL) -> Bool = { _ in true },
                       statusCode: Int = 200, data: Data, file: StaticString = #file, line: UInt = #line) {
      stubbedEnvironment.addStub(isURL: isURL, statusCode: statusCode, response: { _ in return data })
   }

   public func addStub(file: StaticString = #file, line: UInt = #line,
                       isURL: @escaping (URL) -> Bool = { _ in true },
                       statusCode: Int = 200, response: @escaping ((URLRequest) throws -> Data)) {
      stubbedEnvironment.addStub(isURL: isURL, statusCode: statusCode, response: response)
   }

   public func addStub(statusCode: Int = 200, pathComponent: String, file: StaticString = #file, line: UInt = #line) {
      do {
         let data = try TestSettings.shared.fixture.data(of: .api, pathComponent: pathComponent)
         addStub(statusCode: statusCode, data: data)
      } catch {
         assert.fail(String(describing: error), file: file, line: line)
      }
   }

   public func addStub(isURL: @escaping (URL) -> Bool, statusCode: Int = 200, pathComponent: String, file: StaticString = #file,
                       line: UInt = #line) {
      do {
         let data = try TestSettings.shared.fixture.data(of: .api, pathComponent: pathComponent)
         stubbedEnvironment.addStub(isURL: isURL, statusCode: statusCode, response: { _ in return data })
      } catch {
         assert.fail(String(describing: error), file: file, line: line)
      }
   }

   public func removeAllSubs() {
      stubbedEnvironment.removeAllSubs()
   }
}
