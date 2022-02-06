//
//  UIPanGestureRecognizer.swift
//  
//
//  Created by Rouzbeh Abadi on 05.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UIPanGestureRecognizer {

   public func relativeTranslation(in view: UIView) -> CGPoint {
      let absoluteValue = translation(in: view)
      let relativeValue = CGPoint(x: absoluteValue.x / view.bounds.width, y: absoluteValue.y / view.bounds.height)
      return relativeValue
   }

}

#endif
