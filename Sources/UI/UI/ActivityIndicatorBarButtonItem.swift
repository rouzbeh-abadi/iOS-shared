//
//  ActivityIndicatorBarButtonItem.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 03.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

public class ActivityIndicatorBarButtonItem: UIBarButtonItem {

   private let spinner = UIActivityIndicatorView(style: .gray)

   public var isAnimating: Bool {
      get {
         return spinner.isAnimating
      } set {
         spinner.setAnimating(newValue)
      }
   }

   public init(style: UIActivityIndicatorView.Style = .gray) {
      spinner.style = style
      spinner.hidesWhenStopped = true
      super.init()
      customView = spinner
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }
}
#endif
