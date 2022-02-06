//
//  UIStackView.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 11.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UIStackView {

   public convenience init(axis: NSLayoutConstraint.Axis) {
      self.init()
      self.axis = axis
   }

   public func addArrangedSubviews(_ subviews: UIView...) {
      addArrangedSubviews(subviews)
   }

   public func addArrangedSubviews(_ subviews: [UIView]) {
      subviews.forEach {
         addArrangedSubview($0)
      }
   }

   public func removeArrangedSubviews() {
      let views = arrangedSubviews
      views.forEach {
         removeArrangedSubview($0)
         // See why this is needed: https://medium.com/inloopx/uistackview-lessons-learned-e5841205f650
         $0.removeFromSuperview()
      }
   }
}
#endif
