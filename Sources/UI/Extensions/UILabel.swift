//
//  UILabel.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 13.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UILabel {

   public func setAdjustsFontSizeToFitWidth(scaleFactor: CGFloat) {
      adjustsFontSizeToFitWidth = true
      minimumScaleFactor = scaleFactor
   }

   public convenience init(text: String) {
      self.init(frame: .zero)
      self.text = text
   }

   public func setText(_ text: String, animationDuration: TimeInterval) {
      let animation = CATransition()
      animation.timingFunction = .easeInEaseOut
      animation.type = .fade
      animation.duration = animationDuration
      layer.add(animation, forKey: "kCATransitionFade")

      // This will fade
      self.text = text
   }
}
#endif
