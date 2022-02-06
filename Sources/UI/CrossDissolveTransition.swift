//
//  CrossDissolveTransition.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 03/01/2020.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

public class CrossDissolveTransition: NSObject, UIViewControllerAnimatedTransitioning {

   let animationDuration = 0.25

   public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return animationDuration
   }

   public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
      toVC?.view.alpha = 0.0
      let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
      transitionContext.containerView.addSubview(fromVC!.view)
      transitionContext.containerView.addSubview(toVC!.view)

      UIView.animate(withDuration: animationDuration, animations: {
         toVC?.view.alpha = 1.0
      }, completion: { _ in
         fromVC?.view.removeFromSuperview()
         transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
   }
}
#endif
