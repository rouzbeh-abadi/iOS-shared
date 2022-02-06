//
//  UICollectionView.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 17.07.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

extension UICollectionView {

   func tap(item: Int, section: Int = 0, file: StaticString = #file, line: UInt = #line) {
      TestSettings.shared.assert.notNil(delegate, nil, file: file, line: line)
      delegate?.collectionView?(self, didSelectItemAt: IndexPath(item: item, section: section))
   }
}
#endif
