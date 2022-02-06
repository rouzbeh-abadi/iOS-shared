//
//  HTTPRequest.swift
//  PIANetworking
//
//  Created by Rouzbeh Abadi on 19.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import Foundation

public protocol HTTPRequest: class {
   func cancel()
   func resume()
}
