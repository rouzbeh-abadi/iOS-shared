//
//  UIView.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 09.10.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

extension UIView {

   func tapButton(file: StaticString = #file, line: UInt = #line) {
      findView(UIButton.self, file: file, line: line) {
         Automator.tap(button: $0)
      }
   }

   func tapButton<T: UIButton>(ofType: T.Type, file: StaticString = #file, line: UInt = #line) {
      findView(ofType, file: file, line: line) {
         Automator.tap(button: $0)
      }
   }

   func tapButton(_ key: AccessibilityKey, file: StaticString = #file, line: UInt = #line) {
      guard let button = recursiveSubview(for: UIButton.self, accessibilityID: key.accessibilityKey) else {
         TestSettings.shared.assert.fail("Can't find button with accessibility ID: \(key.accessibilityKey)",
                                         file: file, line: line)
         return
      }
      Automator.tap(button: button)
   }

   func tapButton<TagType: RawRepresentable>(_ tag: TagType, file: StaticString = #file, line: UInt = #line)
      where TagType.RawValue == Int {
      guard let button = recursiveSubview(for: UIButton.self, tag: tag) else {
         TestSettings.shared.assert.fail("Can't find button with tag: \(tag.rawValue)", file: file, line: line)
         return
      }
      Automator.tap(button: button)
   }

   func tapView<TagType: RawRepresentable>(_ tag: TagType, file: StaticString = #file, line: UInt = #line)
      where TagType.RawValue == Int {
      guard let view = recursiveSubview(for: UIView.self, tag: tag) else {
         TestSettings.shared.assert.fail("Can't find view with tag: \(tag.rawValue)", file: file, line: line)
         return
      }
      Automator.tap(view: view, file: file, line: line)
   }

   func becomeFirstResponder(_ key: AccessibilityKey, file: StaticString = #file, line: UInt = #line) {
      guard let view = recursiveSubview(for: UIView.self, accessibilityID: key.accessibilityKey) else {
         TestSettings.shared.assert.fail("Can't find responder with accessibility ID: \(key.accessibilityKey)",
                                         file: file, line: line)
         return
      }
      view.becomeFirstResponder()
   }

   func tapSegment(index: Int, file: StaticString = #file, line: UInt = #line) {
      findView(UISegmentedControl.self, file: file, line: line) {
         $0.selectedSegmentIndex = index
         $0.sendActions(for: .valueChanged)
      }
   }

   func tapTable(row: Int, section: Int = 0, file: StaticString = #file, line: UInt = #line) {
      findView(UITableView.self, file: file, line: line) {
         $0.tap(row: row, section: section, file: file, line: line)
      }
   }

   func tapCollection(item: Int, section: Int = 0, file: StaticString = #file, line: UInt = #line) {
      findView(UICollectionView.self, file: file, line: line) {
         $0.tap(item: item, section: section, file: file, line: line)
      }
   }

   func changeText(_ text: String?, file: StaticString = #file, line: UInt = #line) {
      findView(UITextField.self, file: file, line: line) {
         Automator.changeText(text: text, textField: $0)
      }
   }

   func changeText<TagType: RawRepresentable>(_ tag: TagType, text: String?,
                                                     file: StaticString = #file, line: UInt = #line)
      where TagType.RawValue == Int {
      guard let textField = recursiveSubview(for: UITextField.self, tag: tag) else {
         TestSettings.shared.assert.fail("Can't find button with tag: \(tag.rawValue)", file: file, line: line)
         return
      }
      Automator.changeText(text: text, textField: textField)
   }

   func view(_ key: AccessibilityKey, file: StaticString = #file, line: UInt = #line) -> UIView? {
      guard let view = recursiveSubview(for: UIView.self, accessibilityID: key.accessibilityKey) else {
         TestSettings.shared.assert.fail("Can't find button with accessibility ID: \(key.accessibilityKey)",
                                         file: file, line: line)
         return nil
      }
      return view
   }

   func view<TagType: RawRepresentable>(_ tag: TagType, file: StaticString = #file, line: UInt = #line) -> UIView?
      where TagType.RawValue == Int {
      guard let view = recursiveSubview(for: UIView.self, tag: tag) else {
         TestSettings.shared.assert.fail("Can't find button with tag: \(tag.rawValue)", file: file, line: line)
         return nil
      }
      return view
   }

   private func findView<T: UIView>(_ type: T.Type, file: StaticString, line: UInt, callback: (T) -> Void) {
      if let target = self as? T {
         callback(target)
      } else {
         let views = recursiveSubviews(for: T.self)
         TestSettings.shared.assert.equals(views.count, 1, file: file, line: line)
         if let target = views.first {
            callback(target)
         }
      }
   }
}
#endif
