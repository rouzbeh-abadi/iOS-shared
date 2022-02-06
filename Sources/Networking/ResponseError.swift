//
//  ResponseError.swift
//  PIANetworking
//
//  Created by Rouzbeh Abadi on 21.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import Foundation

public enum ResponseError: Swift.Error {
   case notHTTPResponse
   case notDataResponse
   case serverFailure(statusCode: Int)
   case unexpectedResponseDataType(Any.Type, expected: Any.Type)
   case unexpectedStatusCode(Int)
}
