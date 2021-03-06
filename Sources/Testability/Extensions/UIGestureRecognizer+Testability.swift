//
//  UIGestureRecognizer.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 23.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

// See:
// - https://stackoverflow.com/a/46164887/1418981
// - https://github.com/manGoweb/SpecTools

// Return type alias
typealias TargetActionInfo = [(target: AnyObject, action: Selector)]

// UIGestureRecognizer extension
extension UIGestureRecognizer {

   // MARK: Retrieving targets from gesture recognizers

   /// Returns all actions and selectors for a gesture recognizer
   /// This method uses private API's and will most likely cause your app to be rejected if used outside of your test target
   /// - Returns: [(target: AnyObject, action: Selector)] Array of action/selector tuples
   func getTargetInfo() -> TargetActionInfo {
      guard let targets = value(forKeyPath: "_targets") as? [NSObject] else {
         return []
      }
      var targetsInfo: TargetActionInfo = []
      for target in targets {
         // Getting selector by parsing the description string of a UIGestureRecognizerTarget
         let description = String(describing: target).trimmingCharacters(in: CharacterSet(charactersIn: "()"))
         var selectorString = description.components(separatedBy: ", ").first ?? ""
         selectorString = selectorString.components(separatedBy: "=").last ?? ""
         let selector = NSSelectorFromString(selectorString)

         // Getting target from iVars
         if let targetActionPairClass = NSClassFromString("UIGestureRecognizerTarget"),
            let targetIvar = class_getInstanceVariable(targetActionPairClass, "_target"),
            let targetObject = object_getIvar(target, targetIvar) {
            targetsInfo.append((target: targetObject as AnyObject, action: selector))
         }
      }

      return targetsInfo
   }

   /// Executes all targets on a gesture recognizer
   func emulateSendActions() {
      let targetsInfo = getTargetInfo()
      for info in targetsInfo {
         info.target.performSelector(onMainThread: info.action, with: self, waitUntilDone: true)
      }
   }
}
#endif
