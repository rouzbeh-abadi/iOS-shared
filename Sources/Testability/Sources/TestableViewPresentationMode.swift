//
//  TestableViewPresentationMode.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 20.02.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

public enum TestableViewPresentationMode {
   case fullScreen, fullScreenInsideSafeAreas
   case margins(UIEdgeInsets)
   case fullWidth, fullWidthInsideSafeAreas
   case fullHeight, fullHeightInsideSafeAreas
   case atCenter
   case atCenterWithHeight(CGFloat)
   case atCenterWithWidth(CGFloat)
   case fullWidthWithHeight(CGFloat)
   case fullHeightWithWidth(CGFloat)
}
#endif
