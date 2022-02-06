//
//  MultiStackView.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 03.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

public class MultiStackView: View {

   public enum Container: Int {
      case inner, outer
   }

   public let axis: NSLayoutConstraint.Axis

   private lazy var outer = UIStackView().autolayoutView()
   private lazy var inner = UIStackView().autolayoutView()

   public init(axis: NSLayoutConstraint.Axis) {
      self.axis = axis
      super.init(frame: .zero)
      outer.axis = axis
      switch axis {
      case .horizontal:
         inner.axis = .vertical
      case .vertical:
         inner.axis = .horizontal
      @unknown default:
         assertionFailure("Unknown value: \"\(axis)\". Please update \(#file)")
      }
      outer.addArrangedSubview(inner)
      addSubview(outer)
      LayoutConstraint.pin(to: .margins, outer).activate()
      layoutMargins = UIEdgeInsets()
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }
}

extension MultiStackView {

   public var distribution: UIStackView.Distribution {
      get {
         return inner.distribution
      } set {
         inner.distribution = newValue
      }
   }

   public func setAlignment(_ value: UIStackView.Alignment, to: Container) {
      switch to {
      case .inner:
         inner.alignment = value
      case .outer:
         outer.alignment = value
      }
   }

   public func addArrangedSubviews(_ subviews: UIView...) {
      addArrangedSubviews(subviews)
   }

   public func addArrangedSubviews(_ subviews: [UIView]) {
      subviews.forEach {
         inner.addArrangedSubview($0)
      }
   }
}
#endif
