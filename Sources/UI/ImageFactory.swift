//
//  ImageFactory.swift
//  PIAShared
//
//  Created by Rouzbeh Abadi on 10.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

public struct ImageFactory {

   public static func image(size: CGSize, fillColor: UIColor, rounded: Bool = false) -> UIImage {
      let renderer = UIGraphicsImageRenderer(size: size)
      return renderer.image { _ in
         let rect = CGRect(origin: .zero, size: size)
         if rounded {
            let radius = min(size.height, size.width)
            UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
         }
         fillColor.setFill()
         UIRectFill(rect)
      }
   }
}
#endif
