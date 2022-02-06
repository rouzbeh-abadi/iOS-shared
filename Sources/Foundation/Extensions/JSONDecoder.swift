//
//  JSONDecoder.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 08.10.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension JSONDecoder {

   public convenience init(dateDecodingStrategy: DateDecodingStrategy) {
      self.init()
      self.dateDecodingStrategy = dateDecodingStrategy
   }

   public static func makeDefault() -> JSONDecoder {
      return JSONDecoder() // Later we can increase complexity of default setup.
   }

   public func decode<T>(_ type: T.Type, from json: [String: Any]) throws -> T where T: Decodable {
      let data = try JSONSerialization.data(withJSONObject: json, options: [])
      return try decode(type, from: data)
   }

   public func decode<T>(_ type: T.Type, from json: [AnyHashable: Any]) throws -> T where T: Decodable {
      let data = try JSONSerialization.data(withJSONObject: json, options: [])
      return try decode(type, from: data)
   }

   public func decode<T>(_ type: T.Type, from string: String, using: String.Encoding = .utf8) throws -> T where T: Decodable {
      let data = try string.throwing.data(using: using)
      return try decode(type, from: data)
   }
}

extension JSONDecoder {

   public struct DecodingError<T>: Swift.Error {

      let type: T.Type
      let payload: Swift.Error

      public init(type: T.Type, payload: Swift.Error) {
         self.type = type
         self.payload = payload
      }
   }
}
