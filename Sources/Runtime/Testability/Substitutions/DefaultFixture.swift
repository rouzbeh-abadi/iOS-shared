//
//  DefaultFixture.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 03.07.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

struct DefaultFixture: FixtureType {

   let bundle = Bundle.main

   func bundleName(for: FixtureKind) -> String {
      return "Data.bundle"
   }

   func bundlePath(for kind: FixtureKind) -> String {
      return bundle.resourcePath!.appendingPathComponent(bundleName(for: kind))
   }

   func localPath(for kind: FixtureKind) -> String {
      return #file.deletingLastPathComponent.appendingPathComponent(bundleName(for: kind))
   }

   func data(of kind: FixtureKind, pathComponent: String) throws -> Data {
      return Data()
   }
}
