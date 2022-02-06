//
//  FixtureType.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 03.07.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public protocol FixtureType {

   var bundle: Bundle { get }

   func bundleName(for: FixtureKind) -> String
   func bundlePath(for: FixtureKind) -> String
   func localPath(for: FixtureKind) -> String

   func data(of: FixtureKind, pathComponent: String) throws -> Data
}
