//
//  VertexFactory.swift
//  PIADrawing
//
//  Created by Rouzbeh Abadi on 11.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

import CoreGraphics
import Foundation
import simd

public struct VertexFactory {

   public static func makeRectangle(rect: CGRect) -> [vector_float2] {
      return makeRectangle(xMin: rect.minX, xMax: rect.maxX, yMin: rect.minY, yMax: rect.maxY)
   }

   public static func makeRectangle(xMin: CGFloat, xMax: CGFloat, yMin: CGFloat, yMax: CGFloat) -> [vector_float2] {
      return makeRectangle(xMin: Float(xMin), xMax: Float(xMax), yMin: Float(yMin), yMax: Float(yMax))
   }

   public static func makeRectangle(xMin: Float, xMax: Float, yMin: Float, yMax: Float) -> [vector_float2] {
      // Adding 2 triangles to represent recrtangle.
      return [vector_float2(xMin, yMin), vector_float2(xMin, yMax), vector_float2(xMax, yMax),
              vector_float2(xMin, yMin), vector_float2(xMax, yMax), vector_float2(xMax, yMin)]
   }
}
