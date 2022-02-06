//
//  UIColor.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 12.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UIColor {

   public static var random: UIColor {
      let randomRed: CGFloat = CGFloat(drand48())
      let randomGreen: CGFloat = CGFloat(drand48())
      let randomBlue: CGFloat = CGFloat(drand48())
      return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
   }

   public convenience init(hex: String) {
      var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

      if cString.hasPrefix("#") {
         cString.remove(at: cString.startIndex)
      }

      if cString.count != 6 {
         self.init()
         return
      }

      var rgbValue: UInt32 = 0
      Scanner(string: cString).scanHexInt32(&rgbValue)

      self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0))
   }
}
#endif
