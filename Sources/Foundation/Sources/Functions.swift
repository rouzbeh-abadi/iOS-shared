//
//  Functions.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 27.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

/// - parameter object: Object instance.
/// - returns: Object address pointer as Int.
/// - SeeAlso: [ Printing a variable memory address in swift - Stack Overflow ]
///            (http://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift)
public func pointerAddress(of object: AnyObject) -> Int {
   return unsafeBitCast(object, to: Int.self)
}

/// See: https://stackoverflow.com/a/33310021/1418981

public func bridge<T: AnyObject>(obj: T) -> UnsafeRawPointer {
   return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

public func bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
   return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

public func bridgeRetained<T: AnyObject>(obj: T) -> UnsafeRawPointer {
   return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
}

public func bridgeTransfer<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
   return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
}
