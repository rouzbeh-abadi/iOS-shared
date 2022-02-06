//
//  XCTestExpectation.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 03.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import PIASPMShared
import XCTest

extension XCTestExpectation {

   func fulfill(if condition: @autoclosure () -> Bool) {
      let isReady = condition()
      if isReady {
         fulfill()
      }
   }
}

extension XCTestExpectation: ExpectationType {}
