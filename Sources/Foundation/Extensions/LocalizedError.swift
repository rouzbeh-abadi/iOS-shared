//
//  LocalizedError.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 26.10.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension LocalizedError where Self: CustomStringConvertible {

   public var errorDescription: String? {
      return description
   }
}
