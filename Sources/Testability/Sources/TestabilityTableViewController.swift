//
//  TestabilityTableViewController.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

public class TestabilityTableViewController<T: UITableViewCell>: UITableViewController {

   private var numberOfInstances = 1
   let cellID = "cid:Testability"

   public init() {
      super.init(style: .plain)
   }

   required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return numberOfInstances
   }

   public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) {
         return cell
      } else {
         return T(style: .default, reuseIdentifier: cellID)
      }
   }

   public func cell(forRow row: Int) -> T {
      if row > numberOfInstances - 1 {
         numberOfInstances += 1
         tableView.reloadData()
      }
      if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? T {
         return cell
      } else {
         fatalError()
      }
   }
}

#endif
