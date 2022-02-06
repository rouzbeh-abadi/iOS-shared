//
//  GraphicsContext.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 05.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved..
//

#if !os(macOS)
import Foundation
import UIKit

public struct GraphicsContext {

   public static var current: CGContext? {
      return UIGraphicsGetCurrentContext()
   }

   // See difference between `CGContextSaveGState` and `UIGraphicsPushContext` here: https://stackoverflow.com/a/15506006/1418981
   public static func withPushContext(in context: CGContext,
                                      if condition: @autoclosure () -> Bool = true,
                                      drawingCalls: () -> Void) {
      let isReady = condition()
      if isReady {
         UIGraphicsPushContext(context)
         drawingCalls()
         UIGraphicsPopContext()
      }
   }

   public static func withGState(in context: CGContext,
                                 if condition: @autoclosure () -> Bool = true,
                                 drawingCalls: () -> Void) {
      let isReady = condition()
      if isReady {
         context.saveGState()
         drawingCalls()
         context.restoreGState()
      }
   }

   public static func withTransparencyLayer(in context: CGContext, auxiliaryInfo: CFDictionary? = nil,
                                            drawingCalls: () -> Void) {
      context.beginTransparencyLayer(auxiliaryInfo: auxiliaryInfo)
      drawingCalls()
      context.endTransparencyLayer()
   }
}
#endif
