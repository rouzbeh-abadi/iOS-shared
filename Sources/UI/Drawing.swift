//
//  Drawing.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 06.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

public struct Drawing {}

extension Drawing {

   public static func drawInnerShadow(context: CGContext, path: CGPath, shadowColor: UIColor,
                                      offset: CGSize, blurRadius: CGFloat) {
      drawInnerShadow(context: context, path: path, shadowColor: shadowColor.cgColor, offset: offset, blurRadius: blurRadius)
   }

   public static func drawInnerShadow(context: CGContext, path: CGPath, shadowColor: CGColor,
                                      offset: CGSize, blurRadius: CGFloat) {

      guard let opaqueShadowColor = shadowColor.copy(alpha: 1.0) else {
         return
      }
      GraphicsContext.withGState(in: context) {
         context.addPath(path)
         context.clip()
         context.setAlpha(shadowColor.alpha)
         GraphicsContext.withTransparencyLayer(in: context) {
            context.setShadow(offset: offset, blur: blurRadius, color: opaqueShadowColor)
            context.setBlendMode(.sourceOut)
            context.setFillColor(opaqueShadowColor)
            context.addPath(path)
            context.fillPath()
         }
      }
   }
}
#endif
