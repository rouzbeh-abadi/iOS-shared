//
//  UITapGestureRecognizer.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 03.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

extension UITapGestureRecognizer {

   public convenience init(numberOfTapsRequired: Int, handler: UIGestureRecognizer.Handler?) {
      self.init(handler: handler)
      self.numberOfTapsRequired = numberOfTapsRequired
   }
}
#endif
