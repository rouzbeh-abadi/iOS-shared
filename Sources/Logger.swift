//
//  Logger.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 09.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import Foundation

enum AppLogCategory: String, LogCategory {
   case core, decode, encode, request, response, view, setup
}

let logger = Log<AppLogCategory>(subsystem: "shared")
