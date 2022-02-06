//
//  NSLayoutConstraint.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 04.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension NSLayoutConstraint {

   public func activate(priority: LayoutPriority? = nil) {
      if let priority = priority {
         self.priority = priority
      }
      isActive = true
   }

   public func activate(priority: Float) {
      activate(priority: LayoutPriority(rawValue: priority))
   }
}
#endif
