//
//  String.Index.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 10.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension String.Index {

   public func shifting(by offset: Int, in string: String) -> String.Index {
      return String.Index(utf16Offset: utf16Offset(in: string) + offset, in: string)
   }
}
