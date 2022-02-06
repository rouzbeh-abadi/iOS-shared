//
//  Disposable.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 08.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public protocol Disposable {
   var isDisposed: Bool { get }
   func dispose()
}
