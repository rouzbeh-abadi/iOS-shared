//
//  CircleVertex.swift
//  
//
//  Created by Rouzbeh on 03.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
import simd

// See also:
//
// Making Your First Circle Using Metal Shaders
// - https://medium.com/@barbulescualex/making-your-first-circle-using-metal-shaders-1e5049ec8505
public class CircleVertex {

   public let x: Float
   public let y: Float
   public let radius: Float

   public init(x: Float = 0, y: Float = 0, radius: Float = 10) {
      self.x = x
      self.y = y
      self.radius = radius
   }

   /// Needs to be drawn using `triangleStrip` mode.
   public func toVertices(perimeterPoints: Int = 32) -> [vector_float2] {

      assert(perimeterPoints >= 4)
      assert(perimeterPoints % 2 == 0)

      let angle = 360 / Float(perimeterPoints)
      let angleInRadians = (Float.pi * angle) / 180

      var vertices: [vector_float2] = []
      vertices.reserveCapacity(perimeterPoints * 2) // Approximately. Should be 1.5
      let origin = simd_float2(x, y)

      var first = vector_float2()
      for i in 0 ..< perimeterPoints {
         let radians = angleInRadians * Float(i)
         let x = cos(radians) * radius
         let y = sin(radians) * radius
         let point = vector_float2(x + origin.x, y + origin.y)
         if i == 0 {
            first = point
         }
         vertices.append(point)
         if (i + 1) % 2 == 0 {
            vertices.append(origin)
         }
      }
      // See why this additional point is needed: Triangle strip - https://en.wikipedia.org/wiki/Triangle_strip
      vertices.append(first)
      return vertices
   }

   private func rads(forDegree d: Float) -> Float {
      return (Float.pi * d) / 180
   }
}
