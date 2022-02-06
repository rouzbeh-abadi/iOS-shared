//
//  Label.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 03.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

open class Label: UILabel {

   public var isRounded: Bool? {
      didSet {
         layoutSubviews()
      }
   }

   public var textInsets = UIEdgeInsets() {
      didSet {
         setNeedsDisplay()
      }
   }

   public override init(frame: CGRect) {
      var adjustedFrame = frame
      if frame.size.width == 0 {
         adjustedFrame.size.width = CGFloat.leastNormalMagnitude
      }
      if frame.size.height == 0 {
         adjustedFrame.size.height = CGFloat.leastNormalMagnitude
      }
      super.init(frame: adjustedFrame)
      setupUI()
      setupHandlers()
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   open override var intrinsicContentSize: CGSize {
      let size = super.intrinsicContentSize
      return CGSize(width: size.width + textInsets.horizontal, height: size.height + textInsets.vertical)
   }

   open override func drawText(in rect: CGRect) {
      super.drawText(in: rect.insetBy(insets: textInsets))
   }

   open override func layoutSubviews() {
      super.layoutSubviews()
      if let value = isRounded {
         if value {
            let radius = 0.5 * min(bounds.height, bounds.width)
            layer.cornerRadius = radius
            layer.masksToBounds = radius > 0
         }
      }
   }

   @objc open dynamic func setupUI() {
      // Base class does nothing.
   }

   @objc open dynamic func setupHandlers() {
      // Base class does nothing.
   }
}
#endif
