//
//  Automator.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

// FIXME: Implement fake touch gesture generation.
// Synthesizing a touch event on the iPhone: http://www.cocoawithlove.com/2008/10/synthesizing-touch-event-on-iphone.html
// SO: https://stackoverflow.com/questions/39220214/how-to-trigger-tap-gesture-recognizer-of-uiview-programmatically

public struct Automator {

   public static func tap(barButtonItem: UIBarButtonItem, file: StaticString = #file, line: UInt = #line) {
      if let button = barButtonItem.customView as? UIButton {
         button.sendActions(for: .touchUpInside)
      } else if let target = barButtonItem.target, let action = barButtonItem.action {
         UIApplication.shared.sendAction(action, to: target, from: barButtonItem, for: nil)
      } else if let view = barButtonItem.customView, let button = view.subview(for: UIButton.self) {
         button.sendActions(for: .touchUpInside)
      } else {
         TestSettings.shared.assert.fail("Seems UIBarButtonItem is not fully configured.", file: file, line: line)
      }
   }

   public static func tap(barButtonItem: UIBarButtonItem, after: TimeInterval) {
      DispatchQueue.main.asyncAfter(deadline: .now() + after) {
         tap(barButtonItem: barButtonItem)
      }
   }

   public static func tapAsync(barButtonItem: UIBarButtonItem) {
      DispatchQueue.main.async {
         tap(barButtonItem: barButtonItem)
      }
   }

   public static func tap(button: UIButton) {
      button.sendActions(for: .touchUpInside)
   }

   public static func tap(view: UIView?, file: StaticString = #file, line: UInt = #line) {
      TestSettings.shared.assert.notNil(view, nil, file: file, line: line)
      guard let view = view else {
         return
      }
      let grs = view.gestureRecognizers?.compactMap { $0 as? UITapGestureRecognizer } ?? []
      TestSettings.shared.assert.notEmpty(grs, nil, file: file, line: line)
      grs.forEach { $0.emulateSendActions() }
   }

   public static func tapAsync(button: UIButton) {
      DispatchQueue.main.async {
         tap(button: button)
      }
   }

   public static func changeText(text: String?, textField: UITextField) {
      textField.text = text
      textField.sendActions(for: .editingChanged)
   }

   public static func notifyKeyboardDidShow() {
      NotificationCenter.default.post(name: UIResponder.keyboardDidShowNotification, object: nil)
   }

   public static func notifyKeyboardWillHide() {
      NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
   }
}
#endif
