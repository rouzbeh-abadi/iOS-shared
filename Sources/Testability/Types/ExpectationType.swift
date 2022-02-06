//
//  ExpectationType.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 25.06.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public protocol ExpectationType: class {
   func fulfill()
}

extension ExpectationType {

   public func fulfill(if condition: @autoclosure () -> Bool) {
      let isReady = condition()
      if isReady {
         fulfill()
      }
   }
}
