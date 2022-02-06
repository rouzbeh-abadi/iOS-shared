//
//  HTTPServiceTask.swift
//  PIANetworking
//
//  Created by Rouzbeh Abadi on 19.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import Foundation

public protocol HTTPServiceTask: HTTPRequest {

   var completionHandler: Result<(Data, HTTPURLResponse)>.Completion? { get set }
   var progressHandler: ((Double) -> Void)? { get set }

   func suspend()
}
