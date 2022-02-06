//
//  GenericTransitioningAnimator.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 16.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

open class GenericTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {

   public var transitionDuration = 0.3
   public var isPresenting = true

   public init(isPresenting: Bool, transitionDuration: TimeInterval = 0.3) {
      self.transitionDuration = transitionDuration
      self.isPresenting = isPresenting
   }

   public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return transitionDuration
   }

   open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

      // UIKit appears to set fromView setNeedLayout to be true.
      // We don't want fromView to layout after our animation starts.
      // Therefore we kick off the layout beforehand
      transitionContext.viewController(forKey: .from)?.view.layoutIfNeeded()

      let alimationBlock = animation(transitionContext: transitionContext)
      let completionBlock = completion(transitionContext: transitionContext)

      commitAnimations(animation: alimationBlock, completion: completionBlock)
   }

   // MARK: -

   open func animation(transitionContext: UIViewControllerContextTransitioning) -> (() -> Void) {

      let containerView = transitionContext.containerView

      let alimationBlock: () -> Void
      if isPresenting {
         guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            assertionFailure()
            return {}
         }
         containerView.addSubview(toView)
         if !configureOnPresenting(transitionContext: transitionContext) {
            toView.removeFromSuperview()
            transitionContext.completeTransition(false)
            assertionFailure()
            return {}
         }
         alimationBlock = animationOnPresenting(toView: toView, transitionContext: transitionContext)
      } else {
         guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            assertionFailure()
            return {}
         }
         if !configureOnDismissing(transitionContext: transitionContext) {
            transitionContext.completeTransition(false)
            assertionFailure()
            return {}
         }
         alimationBlock = animationOnDismissing(fromView: fromView, transitionContext: transitionContext)
      }
      return alimationBlock
   }

   open func finalFrameOnPresenting(transitionContext: UIViewControllerContextTransitioning) -> CGRect? {
      guard let toVC = transitionContext.viewController(forKey: .to) else {
         return nil
      }
      let finalFrame = transitionContext.finalFrame(for: toVC)
      return finalFrame
   }

   open func configureOnPresenting(transitionContext: UIViewControllerContextTransitioning) -> Bool {
      guard let toView = transitionContext.view(forKey: .to) else {
         return false
      }
      guard let finalFrame = finalFrameOnPresenting(transitionContext: transitionContext) else {
         return false
      }
      toView.frame = finalFrame
      toView.alpha = 0
      return true
   }

   open func configureOnDismissing(transitionContext: UIViewControllerContextTransitioning) -> Bool {
      return true
   }

   open func animationOnPresenting(toView: UIView, transitionContext: UIViewControllerContextTransitioning) -> (() -> Void) {
      return {
         toView.alpha = 1
      }
   }

   open func animationOnDismissing(fromView: UIView, transitionContext: UIViewControllerContextTransitioning) -> (() -> Void) {
      return {
         fromView.alpha = 0
      }
   }

   open func completionOnPresenting(toView: UIView, transitionContext: UIViewControllerContextTransitioning) -> ((Bool) -> Void) {
      return { _ in
         let success = !transitionContext.transitionWasCancelled
         if !success {
            toView.removeFromSuperview()
         }
         transitionContext.completeTransition(success)
      }
   }

   open func completionOnDismissing(fromView: UIView,
                                    transitionContext: UIViewControllerContextTransitioning) -> ((Bool) -> Void) {
      return { _ in
         let success = !transitionContext.transitionWasCancelled
         if success {
            fromView.removeFromSuperview()
         }
         transitionContext.completeTransition(success)
      }
   }

   open func completion(transitionContext: UIViewControllerContextTransitioning) -> ((Bool) -> Void) {
      let completionBlock: (Bool) -> Void
      if isPresenting {
         guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            assertionFailure()
            return { _ in }
         }
         completionBlock = completionOnPresenting(toView: toView, transitionContext: transitionContext)
      } else {
         guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            assertionFailure()
            return { _ in }
         }
         completionBlock = completionOnDismissing(fromView: fromView, transitionContext: transitionContext)
      }

      return completionBlock
   }

   open func commitAnimations(animation: @escaping (() -> Void), completion: @escaping ((Bool) -> Void)) {
      if isPresenting {
         UIView.animate(withDuration: transitionDuration, delay: 0, options: .curveEaseIn,
                        animations: animation, completion: completion)
      } else {
         UIView.animate(withDuration: transitionDuration, delay: 0, options: .curveEaseOut,
                        animations: animation, completion: completion)
      }
   }
}
#endif
