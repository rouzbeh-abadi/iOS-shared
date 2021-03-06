//
//  TestabilityScreenSize.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import CoreGraphics
import Foundation

enum TestabilityScreenSize: String, CaseIterable {

   case x4x0in = "Mimic iPhone 5, 5s, 5c, SE (320 × 568 pt)"
   case x4x7in = "Mimic iPhone 6, 6s, 7, 8 (375 × 667 pt)"
   case x5x5in = "Mimic iPhone 6+, 6s+, 7+, 8+ (414 × 736 pt)"
   case x5x8in = "Mimic iPhone X, Xs (375 × 812 pt)"
   case x6x5and6x1in = "Mimic iPhone Xs Max, Xr (414 × 896 pt)"

   init?(size: CGSize) {
      let matches = TestabilityScreenSize.allCases.filter { $0.size.width == size.width && $0.size.height == size.height }
      if let value = matches.first {
         self = value
      } else {
         return nil
      }
   }

   var size: CGSize {
      switch self {
      case .x4x0in:
         return CGSize(width: 320, height: 568)
      case .x4x7in:
         return CGSize(width: 375, height: 667)
      case .x5x5in:
         return CGSize(width: 414, height: 736)
      case .x5x8in:
         return CGSize(width: 375, height: 812)
      case .x6x5and6x1in:
         return CGSize(width: 414, height: 896)
      }
   }

   var keyboardHeight: CGFloat {
      switch self {
      case .x4x0in, .x4x7in:
         return 216
      case .x5x5in:
         return 226
      case .x5x8in:
         return 291
      case .x6x5and6x1in:
         return 301
      }
   }
}
