//
//  UIViewController.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 09.10.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UIViewController {

   static func makePresenterController(supportedInterfaceOrientations: UIInterfaceOrientationMask? = nil) -> UIViewController {
      let vc = TestabilityViewController(supportedInterfaceOrientations: supportedInterfaceOrientations)
      vc.view.backgroundColor = .yellow
      return vc
   }

   func tapLeftNavigationButton(file: StaticString = #file, line: UInt = #line) {
      let button = navigationItem.leftBarButtonItem
      TestSettings.shared.assert.notNil(button, nil, file: file, line: line)
      if let button = button {
         Automator.tap(barButtonItem: button)
      }
   }

   func tapRightNavigationButton(file: StaticString = #file, line: UInt = #line) {
      let button = navigationItem.rightBarButtonItem
      TestSettings.shared.assert.notNil(button, nil, file: file, line: line)
      if let button = button {
         Automator.tap(barButtonItem: button)
      }
   }
}
#endif
