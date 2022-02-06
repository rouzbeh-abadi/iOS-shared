//
//  NSMutableAttributedString.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 12.07.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {

   public func append(_ string: String) {
      append(NSAttributedString(string: string))
   }
}
