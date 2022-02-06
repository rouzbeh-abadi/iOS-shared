//
//  AlertAction.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 04.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

public class AlertAction: UIAlertAction {

   public var tag: Int?

   public convenience init(defaultActionWithTitle title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      self.init(title: title, style: .default, handler: handler)
      self.tag = tag
   }

   public convenience init(cancelActionWithTitle title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      self.init(title: title, style: .cancel, handler: handler)
      self.tag = tag
   }

   public convenience init(destructiveActionWithTitle title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      self.init(title: title, style: .destructive, handler: handler)
      self.tag = tag
   }
}
#endif
