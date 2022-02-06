//
//  TestabilityOverlayWindow.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

class TestabilityOverlayWindow: UIWindow {

   lazy var viewController = ViewController()

   init() {
      super.init(frame: CGRect(x: 20, y: 20, width: 30, height: 30))
      #if os(iOS)
      windowLevel = UIWindow.Level.statusBar + 2
      #else
      windowLevel = UIWindow.Level.alert + 2
      #endif
      rootViewController = viewController
   }

   required init?(coder aDecoder: NSCoder) {
      fatalError()
   }
}

extension TestabilityOverlayWindow {

   class ViewController: UIViewController {

      enum Event {
         case showMenu
         case close
      }

      var eventHandler: ((Event) -> Void)?

      init() {
         super.init(nibName: nil, bundle: nil)
         view.backgroundColor = UIColor.magenta.withAlphaComponent(0.2)
         let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSingleTap))
         let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap))
         doubleTapGestureRecognizer.numberOfTapsRequired = 2
         singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
         view.addGestureRecognizer(singleTapGestureRecognizer)
         view.addGestureRecognizer(doubleTapGestureRecognizer)
      }

      required init?(coder: NSCoder) {
         fatalError()
      }

      @objc func onSingleTap() {
         eventHandler?(.showMenu)
      }

      @objc func onDoubleTap() {
         eventHandler?(.close)
      }
   }
}
#endif
