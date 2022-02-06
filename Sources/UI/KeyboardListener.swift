//
//  KeyboardListener.swift
//  PIAShared
//
//  Created by Rouzbeh Abadi on 05.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

@available(tvOS, unavailable)
public final class KeyboardListener: NSObject {

   public struct Info {
      let info: [AnyHashable: Any]
      public init(info: [AnyHashable: Any]) {
         self.info = info
      }
   }

   public enum Event {
      case willShow(Info)
      case didShow(Info)
      case willHide(Info)
      case didHide(Info)
      case willChangeFrame(Info)
      case didChangeFrame(Info)
   }

   public var eventHandler: ((Event) -> Void)?
   public var isActive: Bool = true

   private var observers: [NotificationObserver] = []

   public override init() {
      super.init()
      subscribeForNotifications()
   }

   deinit {}
}

extension KeyboardListener {

   private func subscribeForNotifications() {
      observers.append(NotificationObserver(name: UIResponder.keyboardWillShowNotification) { [weak self] notification in
         if let userInfo = notification.userInfo, self?.isActive == true {
            self?.eventHandler?(.willShow(Info(info: userInfo)))
         }
      })
      observers.append(NotificationObserver(name: UIResponder.keyboardDidShowNotification) { [weak self] notification in
         if let userInfo = notification.userInfo, self?.isActive == true {
            self?.eventHandler?(.didShow(Info(info: userInfo)))
         }
      })
      observers.append(NotificationObserver(name: UIResponder.keyboardWillHideNotification) { [weak self] notification in
         if let userInfo = notification.userInfo, self?.isActive == true {
            self?.eventHandler?(.willHide(Info(info: userInfo)))
         }
      })
      observers.append(NotificationObserver(name: UIResponder.keyboardDidHideNotification) { [weak self] notification in
         if let userInfo = notification.userInfo, self?.isActive == true {
            self?.eventHandler?(.didHide(Info(info: userInfo)))
         }
      })
      observers.append(NotificationObserver(name: UIResponder.keyboardWillChangeFrameNotification) { [weak self] notification in
         if let userInfo = notification.userInfo, self?.isActive == true {
            self?.eventHandler?(.willChangeFrame(Info(info: userInfo)))
         }
      })
      observers.append(NotificationObserver(name: UIResponder.keyboardDidChangeFrameNotification) { [weak self] notification in
         if let userInfo = notification.userInfo, self?.isActive == true {
            self?.eventHandler?(.didChangeFrame(Info(info: userInfo)))
         }
      })
   }
}

@available(tvOS, unavailable)
extension KeyboardListener.Info {

   public var frameBegin: CGRect? {
      return (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
   }

   public var frameEnd: CGRect? {
      return (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
   }

   public var animationDuration: Double? {
      return (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
   }

   public var animationCurve: UIView.AnimationCurve? {
      if let value = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue {
         return UIView.AnimationCurve(rawValue: value)
      }
      return nil
   }

   public var isLocal: Bool? {
      return (info[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue
   }
}
#endif
