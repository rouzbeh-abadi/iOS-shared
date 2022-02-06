//
//  URL.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 30/05/2020.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension URL {
   public var queryItems: [String: String] {
      var params = [String: String]()
      return URLComponents(url: self, resolvingAgainstBaseURL: false)?
         .queryItems?
         .reduce([:], { (_, item) -> [String: String] in
            params[item.name] = item.value
            return params
         }) ?? [:]
   }
}
