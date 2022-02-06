//
//  UITableView.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 23.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

extension UITableView {

   func tap(row: Int, section: Int = 0, file: StaticString = #file, line: UInt = #line) {
      TestSettings.shared.assert.notNil(delegate, nil, file: file, line: line)
      delegate?.tableView?(self, didSelectRowAt: IndexPath(row: row, section: section))
   }
}
#endif
