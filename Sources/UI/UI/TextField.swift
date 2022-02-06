//
//  TextField.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 02.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

open class TextField: UITextField {

   var onDeleteBackward: ((UITextField) -> Void)?

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
      super.init(coder: aDecoder)
   }

   open override func awakeFromNib() {
      super.awakeFromNib()
      setupUI()
      setupHandlers()
   }

   open override func deleteBackward() {
      super.deleteBackward()
      onDeleteBackward?(self)
   }

   open func setupUI() {}

   open func setupHandlers() {}
}
#endif
