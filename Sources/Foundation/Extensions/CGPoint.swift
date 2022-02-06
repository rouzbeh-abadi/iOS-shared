//
//  CGPoint.swift
//  Piavita
//
//  Created by Rouzbeh on 4/28/20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import CoreGraphics

extension CGPoint {

   public func subtract(point: CGPoint) -> CGPoint {
      return CGPoint(x: x - point.x, y: y - point.y)
   }

   public func add(point: CGPoint) -> CGPoint {
      return CGPoint(x: x + point.x, y: y + point.y)
   }

   public func offsettingX(by: CGFloat) -> CGPoint {
      return CGPoint(x: x + by, y: y)
   }

   public func offsettingY(by: CGFloat) -> CGPoint {
      return CGPoint(x: x, y: y + by)
   }
}
