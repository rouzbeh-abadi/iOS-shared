//
//  DefaultTestEnvironment.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

struct DefaultTestEnvironment: TestEnvironment {

   var isUnderPlaygroundTesting: Bool {
      return false
   }
}
