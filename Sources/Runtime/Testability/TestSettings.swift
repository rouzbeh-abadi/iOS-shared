//
//  TestSettings.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 03.07.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public class TestSettings {

   public static let shared = TestSettings()

   public var assert: AssertType = DefaultAssert()
   public var fixture: FixtureType = DefaultFixture()
   public var testEnvironment: TestEnvironment = DefaultTestEnvironment()
   public var stubbedEnvironment: TestStubbedEnvironment = DefaultStubbedEnvironment()
}
