//
//  UIImageView.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 13.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

extension UIImageView {

   public func startLoopAnimation(animationDuration: TimeInterval) {
      self.animationDuration = animationDuration
      animationRepeatCount = 0
      startAnimating()
   }
}
#endif
