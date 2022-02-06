//
//  KeyedDecodingContainer.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 06.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {

   public func decode<T>(key: K) throws -> T where T: Decodable {
      return try decode(T.self, forKey: key)
   }

   public func decodeIfPresent<T>(key: K) throws -> T? where T: Decodable {
      return try decodeIfPresent(T.self, forKey: key)
   }

   public func decodeIfPresent<T>(key: K, substitution: T) throws -> T where T: Decodable {
      return try decodeIfPresent(T.self, forKey: key) ?? substitution
   }
}
