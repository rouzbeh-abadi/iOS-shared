//
//  NotificationCenter.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 06.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension NotificationCenter {

   public func post(name: NSNotification.Name) {
      post(name: name, object: nil)
   }

   public func post(name: NSNotification.Name, userInfo: [AnyHashable: Any]) {
      post(name: name, object: nil, userInfo: userInfo)
   }
}
