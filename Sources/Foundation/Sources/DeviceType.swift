//
//  DeviceType.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 08/08/2020.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

// See also: 
// - http://iosres.com
// - https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
public struct DeviceType {

   public static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
   public static let isPad = UIDevice.current.userInterfaceIdiom == .pad

    //iPhones
   public static var isPhone5OrLess: Bool {
      return DeviceType.isPhone && ScreenSize.maxLength <= 568.0 // Smallest screen we support.
   }

   public static var isPhone6Or7: Bool {
      return DeviceType.isPhone && ScreenSize.maxLength == 667.0
   }

   public static var isPhone6POr7P: Bool {
      return DeviceType.isPhone && ScreenSize.maxLength == 736.0
   }
    
    public static var isPhoneXOrXsOr11: Bool {
        return DeviceType.isPhone && ScreenSize.maxLength == 812.0
    }
    
    public static var isPhoneXrORMax: Bool {
        return DeviceType.isPhone && ScreenSize.maxLength == 896.0
    }

    //iPads
   public static var isPadProBig: Bool {
      return DeviceType.isPad && ScreenSize.maxLength == 1366.0
   }
    
    public static var isPadMiniORAir: Bool {
        return DeviceType.isPad && ScreenSize.maxLength == 1024.0
    }
    
    public static var isPadPro105: Bool {
        return DeviceType.isPad && ScreenSize.maxLength == 1112.0
    }
    
    public static var isPadPro11: Bool {
        return DeviceType.isPad && ScreenSize.maxLength == 1194.0
    }
}
#endif
