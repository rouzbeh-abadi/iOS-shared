//
//  UIViewControllerPreview.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 29.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

#if PREVIEW
import SwiftUI

public struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {

   public let viewController: ViewController

   public init(_ builder: @escaping () -> ViewController) {
      viewController = builder()
   }

   // MARK: - UIViewControllerRepresentable

   public func makeUIViewController(context: Context) -> ViewController {
      viewController
   }

   public func updateUIViewController(_ uiViewController: ViewController,
                                      context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
      return
   }
}
#endif
#endif
