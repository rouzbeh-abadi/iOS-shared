//
//  TestEnvironment.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public protocol TestEnvironment {

   var isUnderPlaygroundTesting: Bool { get }
}
