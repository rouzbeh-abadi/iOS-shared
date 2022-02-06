//
//  Font.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 19.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

public struct Font {}

extension Font {

   public static func fixedRegular(size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .regular)
   }

   public static func fixedSemibold(size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .semibold)
   }

   public static func fixedBold(size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .bold)
   }

   public static func fixedHeavy(size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .heavy)
   }

   public static func fixedItalic(size: CGFloat) -> UIFont {
      return UIFont.italicSystemFont(ofSize: size)
   }

   public static func fixedMedium(size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .medium)
   }

   public static func regular(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedRegular(size: size))
   }

   public static func semibold(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedSemibold(size: size))
   }

   public static func bold(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedBold(size: size))
   }

   public static func heavy(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedHeavy(size: size))
   }

   public static func italic(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedItalic(size: size))
   }

   public static func medium(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedMedium(size: size))
   }
}
#endif
