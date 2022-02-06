//
//  ImageView.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 02.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

open class ImageView: UIImageView {

   private var userDefinedIntrinsicContentSize: CGSize?

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
   }

   public convenience init() {
      self.init(frame: CGRect())
   }

   public override init(image: UIImage?) {
      super.init(image: image)
   }

   public init(image: UIImage? = nil,
               contentMode: ImageView.ContentMode = .scaleToFill) {
      super.init(image: image)
      self.contentMode = contentMode
   }

   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   open override var intrinsicContentSize: CGSize {
      return userDefinedIntrinsicContentSize ?? super.intrinsicContentSize
   }

   @objc open dynamic func setupUI() {
      // Do something
   }

   // MARK: -

   /// When passed **nil**, then system value is used.
   public func setIntrinsicContentSize(_ size: CGSize?) {
      userDefinedIntrinsicContentSize = size
   }
}
#endif
