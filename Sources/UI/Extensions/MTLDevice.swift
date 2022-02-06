//
//  MTLDevice.swift
//  PIADrawing
//
//  Created by Rouzbeh Abadi on 12.02.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
import MetalKit

extension MTLDevice {

   public func makeBuffer(length: Int, options: MTLResourceOptions = []) throws -> MTLBuffer {
      guard let buffer = makeBuffer(length: length, options: options) else {
         throw NSError.MTLDevice.unableToInitialize(MTLBuffer.self)
      }
      return buffer
   }

   /// Allocates a new buffer of a given length and initializes its contents by copying existing data into it.
   public func makeBuffer(withBytes bytes: UnsafeRawPointer, length: Int, options: MTLResourceOptions = []) throws -> MTLBuffer {
      guard let buffer = makeBuffer(bytes: bytes, length: length, options: options) else {
         throw NSError.MTLDevice.unableToInitialize(MTLBuffer.self)
      }
      return buffer
   }
}

extension NSError {

   public enum MTLDevice: Swift.Error {
      case unableToInitialize(AnyClass)
   }
}
