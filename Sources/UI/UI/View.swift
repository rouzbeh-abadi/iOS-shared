//
//  View.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 02.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

open class View: UIView {

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
      fetchData()
      setupStackViews()
      setupUI()
      setupLayout()
      setupDataSource()
      setupHandlers()
      setupDefaults()
   }

   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   open override func awakeFromNib() {
      super.awakeFromNib()
      fetchData()
      setupStackViews()
      setupUI()
      setupLayout()
      setupDataSource()
      setupHandlers()
      setupDefaults()
   }

   open override var intrinsicContentSize: CGSize {
      return userDefinedIntrinsicContentSize ?? super.intrinsicContentSize
   }
    
    
  @objc open dynamic func fetchData() {
    // Base class does nothing.
   }
    
  @objc open dynamic func setupStackViews() {
    // Base class does nothing.
   }

   @objc open dynamic func setupUI() {
      // Base class does nothing.
   }

   @objc open dynamic func setupLayout() {
      // Base class does nothing.
   }

   @objc open dynamic func setupHandlers() {
      // Base class does nothing.
   }

   @objc open dynamic func setupDefaults() {
      // Base class does nothing.
   }

   @objc open dynamic func setupDataSource() {
      // Base class does nothing.
   }
}

extension View {

   /// When passed **nil**, then system value is used.
   public func setIntrinsicContentSize(_ size: CGSize?) {
      userDefinedIntrinsicContentSize = size
   }
}
#endif
