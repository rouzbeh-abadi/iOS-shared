//
//  RequestParams.swift
//  PIANetworking
//
//  Created by Rouzbeh Abadi on 03.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import Foundation

public enum RequestParams {
   case bodyData(Data)
   case bodyParameters([AnyHashable: Any])
   case query([AnyHashable: Any])
   case none
}
