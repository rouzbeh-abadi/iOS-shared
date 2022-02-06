//
//  LayoutPriority.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 09.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
public typealias LayoutPriority = UILayoutPriority
#elseif os(OSX)
import AppKit
public typealias LayoutPriority = NSLayoutConstraint.Priority
#endif

extension LayoutPriority {

   public static func + (left: LayoutPriority, right: Float) -> LayoutPriority {
      return LayoutPriority(rawValue: left.rawValue + right)
   }

   public static func - (left: LayoutPriority, right: Float) -> LayoutPriority {
      return LayoutPriority(rawValue: left.rawValue - right)
   }
}
