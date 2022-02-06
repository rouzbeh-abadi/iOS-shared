//
//  TestableControllerPresentationMode.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 20.02.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

public enum TestableControllerPresentationMode {
   case fullScreen, width(CGFloat), margins(UIEdgeInsets), size(CGSize)
}
#endif
