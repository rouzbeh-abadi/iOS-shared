//
//  URLRequest.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 10.10.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension URLRequest {

   public func jsonBody() throws -> [AnyHashable: Any]? {
      if let body = httpBody {
         return try JSONSerialization.jsonObject(with: body, options: []) as? [AnyHashable: Any]
      } else {
         return nil
      }
   }
}
