//
//  TestabilityMenuViewController.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

class TestabilityMenuViewController: UITableViewController {

   enum Event {
      case close
      case resize(TestabilityScreenSize)
   }

   var eventHandler: ((Event) -> Void)?
   var activeSizes: [TestabilityScreenSize] = []

   init() {
      super.init(style: .plain)
      modalPresentationStyle = .popover
      popoverPresentationController?.delegate = self
      view.backgroundColor = UIColor.white
      tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
   }

   required init?(coder: NSCoder) {
      fatalError()
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      preferredContentSize = tableView.contentSize
   }

   override func numberOfSections(in tableView: UITableView) -> Int {
      return 2
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return section == 0 ? 1 : activeSizes.count
   }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell: UITableViewCell
      let reuseIdentifier = "cid:standard.default"
      if let value = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
         cell = value
      } else {
         cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
      }
      cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
      cell.backgroundColor = .clear
      if indexPath.section == 0 {
         cell.textLabel?.text = "Close"
      } else {
         let menuID = activeSizes[indexPath.row]
         cell.textLabel?.text = menuID.rawValue
      }
      return cell
   }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      if indexPath.section == 0 {
         eventHandler?(.close)
      } else {
         let menuID = activeSizes[indexPath.row]
         eventHandler?(.resize(menuID))
      }
   }
}

extension TestabilityMenuViewController: UIPopoverPresentationControllerDelegate {

   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
}
#endif
