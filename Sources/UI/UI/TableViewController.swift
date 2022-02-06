//
//  TableViewController.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 02.12.19.
//  Copyright © 2019 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

open class TableViewController: UITableViewController {

   private let layoutUntil = DispatchUntil()

   open override func loadView() {
      super.loadView()
      view.backgroundColor = .white
   }

   public init() {
      super.init(nibName: nil, bundle: nil)
   }

   public override init(style: UITableView.Style) {
      super.init(style: style)
   }

   public required init?(coder: NSCoder) {
      super.init(coder: coder)
   }

   open override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      applyFixForNotUpToDateViewFrameIfNeeded(view: tableView.tableHeaderView)
      applyFixForNotUpToDateViewFrameIfNeeded(view: tableView.tableFooterView)
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   open override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      layoutUntil.fulfill()
      view.assertOnAmbiguityInSubviewsLayout()
   }

   open override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      setupLayout()
      setupHandlers()
      setupDataSource()
      setupDefaults()
   }

   @objc open dynamic func setupUI() {}

   @objc open dynamic func setupLayout() {}

   @objc open dynamic func setupHandlers() {}

   @objc open dynamic func setupDataSource() {}

   @objc open dynamic func setupDefaults() {}

   @objc open dynamic func setupLayoutDefaults() {}
}

extension TableViewController {
   private func applyFixForNotUpToDateViewFrameIfNeeded(view: UIView?) {
      guard let view = view else { return }

      let width = tableView.bounds.width
      let size = view.systemLayoutSizeFitting(width: width, verticalFitting: .fittingSizeLevel)
      let frame = CGRect(x: 0, y: view.frame.origin.y, width: width, height: size.height)
      if view.frame != frame {
         view.frame = frame
      }
   }
}
#endif
