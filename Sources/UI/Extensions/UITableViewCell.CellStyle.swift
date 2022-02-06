//
//  UITableViewCell.CellStyle.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 17.01.2020.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

extension UITableViewCell.CellStyle {

   public var stringValue: String {
      switch self {
      case .default:
         return "default"
      case .subtitle:
         return "subtitle"
      case .value1:
         return "value1"
      case .value2:
         return "value2"
      @unknown default: return "unknown"
      }
   }
}
#endif
