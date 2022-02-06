//
//  UIActivityIndicatorView.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 08.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UIActivityIndicatorView {

   public func setAnimating(_ isAnimating: Bool) {
      if isAnimating {
         startAnimating()
      } else {
         stopAnimating()
      }
   }
}
#endif
