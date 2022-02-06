//
//  ScrollableStackView.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 03.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

public class ScrollableStackView<T: UIView>: View {

   private lazy var stackView = StackView().autolayoutView()
   public private (set) lazy var scrollView = UIScrollView(frame: .zero).autolayoutView()

   public var orientation: NSLayoutConstraint.Axis {
      return stackView.axis
   }

   public var spacing: CGFloat {
      get {
         return stackView.spacing
      } set {
         stackView.spacing = newValue
      }
   }

   public var views: [T] {
      get {
         stackView.arrangedSubviews.compactMap { $0 as? T }
      } set {
         stackView.removeArrangedSubviews()
         stackView.addArrangedSubviews(newValue)
      }
   }

   public init(orientation: NSLayoutConstraint.Axis) {
      super.init(frame: .zero)
      stackView.axis = orientation
      initialize()
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   // MARK: - Public

   public func addArrangedSubviews(_ subviews: [T]) {
      stackView.addArrangedSubviews(subviews)
   }

   public func addArrangedSubviews(_ subviews: T...) {
      stackView.addArrangedSubviews(subviews)
   }

   public func setCustomSpacing(_ spacing: CGFloat, after: T) {
      stackView.setCustomSpacing(spacing, after: after)
   }

   public func removeArrangedSubviews() {
      stackView.removeArrangedSubviews()
   }

   // MARK: - Private

   private func initialize() {
      addSubview(scrollView)
      scrollView.addSubview(stackView)
      LayoutConstraint.pin(to: .bounds, scrollView).activate()
      switch orientation {
      case .horizontal:
         LayoutConstraint.pin(to: .vertically, stackView).activate()
         stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).activate()
         stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).activate(priority: .required - 1)
         LayoutConstraint.equalHeight(viewA: stackView, viewB: self).activate()
      case .vertical:
         LayoutConstraint.pin(to: .horizontally, stackView).activate()
         stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).activate()
         stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).activate(priority: .required - 1)
         LayoutConstraint.equalWidth(viewA: stackView, viewB: self).activate()
      @unknown default:
         assertionFailure("Unknown value: \"\(orientation)\". Please update \(#file)")
      }
   }
}
#endif
