//
//  CGSize.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 03.07.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import CoreGraphics

extension CGSize: Comparable {

   public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
      return lhs.width < rhs.width || lhs.height < rhs.height
   }
}
