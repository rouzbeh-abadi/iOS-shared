//
//  AnimatableContainerView.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 23.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

public class AnimatableContainerView: View {

   public enum Edge: Int {
      case top, bottom, leading, trailing
   }

   private lazy var constraintTop = payload.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
   private lazy var constraintBottom = layoutMarginsGuide.bottomAnchor.constraint(equalTo: payload.bottomAnchor)
   private lazy var constraintLeading = payload.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
   private lazy var constraintTrailing = layoutMarginsGuide.trailingAnchor.constraint(equalTo: payload.trailingAnchor)

   private lazy var constraintWidth = widthAnchor.constraint(equalToConstant: 0)
   private lazy var constraintHeight = heightAnchor.constraint(equalToConstant: 0)

   public var animationContainer: UIView?
   public let payload: UIView
   private var collapsedEdge: Edge?

   public init(payload: UIView) {
      self.payload = payload
      super.init(frame: .zero)
      animationContainer = superview // Typically it is `superview` or it's parent.
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }
}

extension AnimatableContainerView {

   public var isCollapsed: Bool {
      return collapsedEdge != nil
   }

   public func setCollapsed(_ isCollapsed: Bool, toEdge: Edge, animated: Bool) {
      if isCollapsed {
         collapse(toEdge: toEdge, animated: animated)
      } else {
         reset(animated: animated)
      }
   }

   public func togglle(toEdge edge: Edge, animated: Bool) {
      if let collapsedEdge = collapsedEdge {
         if collapsedEdge == edge {
            reset(animated: animated)
         } else {
            logger.default(.view, "Unexpected edge \"\(edge)\". Expected is \"\(collapsedEdge)\".")
         }
      } else {
         collapse(toEdge: edge, animated: animated)
      }
   }

   public func collapse(toEdge edge: Edge, animated: Bool) {
      if collapsedEdge != nil {
         return
      }
      if let animationContainer = animationContainer, animated {
         // We changing our size, so layout needs to be called on one of `super` views.
         animationContainer.layoutIfNeeded()
         setUp(forEdge: edge)
         UIView.animate(withDuration: 0.3) {
            self.collapse(toEdge: edge)
            animationContainer.layoutIfNeeded()
         }
      } else {
         setUp(forEdge: edge)
         collapse(toEdge: edge)
      }
      collapsedEdge = edge
   }

   public func reset(animated: Bool) {
      guard let edge = collapsedEdge else {
         return
      }
      if let animationContainer = animationContainer, animated {
         // We changing our size, so layout needs to be called on one of `super` views.
         animationContainer.layoutIfNeeded()
         let size = payloadSize(forEdge: edge)
         UIView.animate(withDuration: 0.3, animations: {
            self.uncollapse(edge: edge, payloadSize: size)
            animationContainer.layoutIfNeeded()
         }, completion: { _ in
            self.finalize(forEdge: edge)
         })
      } else {
         let size = payloadSize(forEdge: edge)
         uncollapse(edge: edge, payloadSize: size)
         finalize(forEdge: edge)
      }
      collapsedEdge = nil
   }
}

extension AnimatableContainerView {

   public override func setupUI() {

      clipsToBounds = true
      layoutMargins = UIEdgeInsets()
      payload.translatesAutoresizingMaskIntoConstraints = false
      addSubview(payload)
   }

   public override func setupLayout() {
      [constraintTop, constraintBottom, constraintLeading, constraintTrailing].activate()

      _ = constraintWidth
      _ = constraintHeight

      // `999` layout fix for iOS.
      constraintBottom.priority = .required - 1
      constraintTrailing.priority = .required - 1
   }
}

extension AnimatableContainerView {

   private func payloadSize(forEdge edge: Edge) -> CGSize {
      let payloadSize: CGSize
      switch edge {
      case .top, .bottom:
         payloadSize = payload.systemLayoutSizeFitting(width: bounds.width, verticalFitting: .fittingSizeLevel)
      case .leading, .trailing:
         payloadSize = payload.systemLayoutSizeFitting(height: bounds.height, horizontalFitting: .fittingSizeLevel)
      }
      return payloadSize
   }

   private func finalize(forEdge edge: Edge) {
      switch edge {
      case .top, .bottom:
         constraintHeight.isActive = false
         constraintHeight.constant = 0
      case .leading, .trailing:
         constraintWidth.isActive = false
         constraintWidth.constant = 0
      }
   }

   private func setUp(forEdge edge: Edge) {
      switch edge {
      case .top, .bottom:
         constraintHeight.constant = bounds.height
         constraintHeight.isActive = true
      case .leading, .trailing:
         constraintWidth.constant = bounds.width
         constraintWidth.isActive = true
      }
   }

   private func uncollapse(edge: Edge, payloadSize: CGSize) {
      switch edge {
      case .top, .bottom:
         constraintHeight.constant = payloadSize.height
      case .leading, .trailing:
         constraintWidth.constant = payloadSize.width
      }
      switch edge {
      case .top:
         constraintTop.constant = 0
      case .bottom:
         constraintBottom.constant = 0
      case .leading:
         constraintLeading.constant = 0
      case .trailing:
         constraintTrailing.constant = 0
      }
   }

   private func collapse(toEdge edge: Edge) {
      switch edge {
      case .top, .bottom:
         constraintHeight.constant = 0
      case .leading, .trailing:
         constraintWidth.constant = 0
      }
      switch edge {
      case .top:
         constraintTop.constant = -bounds.height
      case .bottom:
         constraintBottom.constant = bounds.height
      case .leading:
         constraintLeading.constant = -bounds.width
      case .trailing:
         constraintTrailing.constant = bounds.width
      }
   }
}
#endif
