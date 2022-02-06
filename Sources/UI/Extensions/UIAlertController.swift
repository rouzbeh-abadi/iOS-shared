//
//  UIAlertController.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 04.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

extension UIAlertController {

   public convenience init(alertWithTitle title: String, message: String) {
      self.init(title: title, message: message, preferredStyle: .alert)
   }

   public convenience init(alertWithTitle title: String) {
      self.init(title: title, message: nil, preferredStyle: .alert)
   }

   public convenience init(alertWithMessage message: String) {
      self.init(title: "", message: message, preferredStyle: .alert)
   }
}

extension UIAlertController {

   public convenience init(actionSheetWithTitle title: String) {
      self.init(title: title, message: nil, preferredStyle: .actionSheet)
   }
}

extension UIAlertController {

   public func addDefaultAction(_ title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      let action = AlertAction(defaultActionWithTitle: title, tag: tag, handler: handler)
      addAction(action)
   }

   public func addDestructiveAction(_ title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      let action = AlertAction(destructiveActionWithTitle: title, tag: tag, handler: handler)
      addAction(action)
   }

   public func addCancelAction(_ title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      let action = AlertAction(cancelActionWithTitle: title, tag: tag, handler: handler)
      addAction(action)
   }
}

extension UIAlertController {

   private typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

   public func tapAlertButton(atIndex index: Int, animated: Bool = true) {
      guard let action = actions.element(at: index) else {
         return
      }
      if let block = action.value(forKey: "handler") {
         let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
         let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
         presentingViewController?.dismiss(animated: animated) {
            handler(action)
         }
      } else {
         logger.error(.view, "Unable to retrieve handler for alert action at index \(index)")
      }
   }
}
#endif
