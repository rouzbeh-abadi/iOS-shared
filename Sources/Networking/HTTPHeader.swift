//
//  HTTPHeader.swift
//  
//
//  Created by Rouzbeh Abadi on 11.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.

import Foundation

public struct HTTPHeader {
   public let key: String
   public let value: String

   public init(key: String, value: String) {
      self.key = key
      self.value = value
   }
}
