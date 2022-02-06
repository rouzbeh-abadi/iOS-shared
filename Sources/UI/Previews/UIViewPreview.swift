//
//  UIViewPreview.swift
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

public struct UIViewPreview<View: UIView>: UIViewRepresentable {

   public let view: View

   public init(_ builder: @escaping () -> View) {
      view = builder()
   }

   // MARK: - UIViewRepresentable

   public func makeUIView(context: Context) -> UIView {
      return view
   }

   public func updateUIView(_ view: UIView, context: Context) {
      view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      view.setContentHuggingPriority(.defaultHigh, for: .vertical)
   }
}
#endif
#endif
