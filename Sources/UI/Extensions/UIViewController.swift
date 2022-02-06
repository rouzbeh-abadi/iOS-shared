//
//  UIViewController.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 05.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UIViewController {

   public static func initFromNib<T: UIViewController>(_: T.Type) -> T {
      let nibName = NSStringFromClass(T.self).components(separatedBy: ".").last ?? ""
      return T(nibName: nibName, bundle: Bundle(for: T.self))
   }

   public static func initFromStoryboard<T: UIViewController>(_ type: T.Type) -> T {
      let name = NSStringFromClass(T.self).components(separatedBy: ".").last ?? ""
      let storyboard = UIStoryboard(name: name, bundle: Bundle(for: T.self))
      if let vc = storyboard.instantiateInitialViewController() as? T {
         return vc
      } else if let vc = storyboard.instantiateViewController(withIdentifier: name) as? T {
         return vc
      } else {
         fatalError("Unable to initialize view controller of type \(type) in storyboard \(storyboard)")
      }
   }
}

extension UIViewController {

   public func recursiveChildren<T: UIViewController>(ofType: T.Type) -> [T] {
      var result = children(ofType: ofType)
      result += result.map { $0.recursiveChildren(ofType: ofType) }.reduce(into: []) { $0 += $1 }
      return result
   }

   public func child<T: UIViewController>(ofType: T.Type) -> T? {
      let vc = children(ofType: ofType).first
      return vc
   }

   public func children<T: UIViewController>(ofType: T.Type) -> [T] {
      let matches = children.compactMap { $0 as? T }
      return matches
   }

   public func embedChild<T: UIViewController>(_ vc: T, container: UIView) {
      removeChildren(from: container) // it's posible when we have multiple `containers` with controllers `T`
      addChild(vc, container: container)
      vc.didMove(toParent: self)
   }

   public func addChild(_ vc: UIViewController, container: UIView) {
      addChild(vc)
      vc.view.translatesAutoresizingMaskIntoConstraints = false
      container.addSubview(vc.view)
      LayoutConstraint.pin(to: .bounds, vc.view).activate()
   }

   public func removeChild<T: UIViewController>(type: T.Type) {
      let controllers = children.filter { $0 is T }
      controllers.forEach {
         $0.willMove(toParent: nil)
         $0.view.removeFromSuperview()
         $0.removeFromParent()
      }
   }

   public func removeChildren(from container: UIView) {
      let controllers = children.filter { $0.view.superview == container }
      controllers.forEach {
         $0.willMove(toParent: nil)
         $0.view.removeFromSuperview()
         $0.removeFromParent()
      }
   }

   public func unembedFromParent() {
      willMove(toParent: nil)
      view.removeFromSuperview()
      removeFromParent()
   }

   public func presentAnimated(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
      present(viewController, animated: true, completion: completion)
   }

   public func dismissAnimated(completion: (() -> Void)? = nil) {
      dismiss(animated: true, completion: completion)
   }

   public func removeChild(_ childViewController: UIViewController) {
      childViewController.unembedFromParent()
   }

   func removeChildren() {
      children.forEach { viewController in
         removeChild(viewController)
      }
   }

   public func loadChildViewController(viewController: UIViewController, forView containerView: UIView, remove: Bool = true) {
      if remove {
         removeChildren()
      }
      addChild(viewController)
      viewController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width,
                                         height: containerView.frame.size.height)
      containerView.addSubview(viewController.view)
      viewController.didMove(toParent: self)
   }
}
#endif
