//
//  CALayer.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 06/01/2020.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension CALayer {

   public func removeSublayer(by name: String) {
      guard let sublayers = sublayers else { return }

      for sublayer in sublayers where sublayer.name == name {
         sublayer.removeFromSuperlayer()
      }
   }

   public func addRoundLayer(path: CGPath,
                             name: String? = nil,
                             strokeColor: CGColor = UIColor.clear.cgColor,
                             fillColor: CGColor = UIColor.clear.cgColor) {
      let mask = CAShapeLayer()
      mask.path = path
      mask.name = name
      self.mask = mask

      let shape = CAShapeLayer()
      shape.path = mask.path
      shape.name = name
      shape.lineWidth = borderWidth
      shape.strokeColor = strokeColor
      shape.fillColor = fillColor

      addSublayer(shape)
   }

   public func setShadow(radius: CGFloat, opacity: Float = 0.3, color: UIColor? = nil, offset: CGSize? = nil) {
      shadowColor = (color ?? UIColor.black).cgColor
      if let offset = offset {
         shadowOffset = offset
      }
      shadowRadius = radius
      shadowOpacity = opacity
   }
}
#endif
