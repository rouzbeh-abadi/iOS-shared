//
//  TestabilityViewController.swift
//  PIATestability
//
//  Created by Rouzbeh Abadi on 20.02.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import UIKit

class TestabilityViewController: UIViewController {

   private let safeAreaView = UIView()
   private var testableView = UIView()
   private var supportedInterfaceOrientationsValue: UIInterfaceOrientationMask?

   override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      return supportedInterfaceOrientationsValue ?? super.supportedInterfaceOrientations
   }

   init(supportedInterfaceOrientations: UIInterfaceOrientationMask?) {
      supportedInterfaceOrientationsValue = supportedInterfaceOrientations
      super.init(nibName: nil, bundle: nil)
   }

   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      viewRespectsSystemMinimumLayoutMargins = false
      view.insetsLayoutMarginsFromSafeArea = false
      view.layoutMargins = UIEdgeInsets()
      let gr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
      gr.cancelsTouchesInView = false
      view.addGestureRecognizer(gr)
      view.backgroundColor = .lightGray
      setupSafeAreaView()
   }

   required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
      coordinator.animate(alongsideTransition: { _ in
         self.view.layoutIfNeeded()
      }, completion: nil)
   }

   func configure(view testableView: UIView, mode: TestableViewPresentationMode) {
      self.testableView = testableView
      testableView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(testableView)

      var constraints: [NSLayoutConstraint] = []
      switch mode {
      case .fullScreen:
         constraints += [testableView.topAnchor.constraint(equalTo: view.topAnchor),
                         view.bottomAnchor.constraint(equalTo: testableView.bottomAnchor),
                         testableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                         view.trailingAnchor.constraint(equalTo: testableView.trailingAnchor)]
      case .fullScreenInsideSafeAreas:
         constraints += [testableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                         view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: testableView.bottomAnchor),
                         testableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                         view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: testableView.trailingAnchor)]
      case .fullWidth:
         constraints += [testableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                         view.trailingAnchor.constraint(equalTo: testableView.trailingAnchor),
                         testableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
      case .fullWidthInsideSafeAreas:
         constraints += [testableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                         view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: testableView.trailingAnchor),
                         testableView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)]
      case .fullHeight:
         constraints += [testableView.topAnchor.constraint(equalTo: view.topAnchor),
                         view.bottomAnchor.constraint(equalTo: testableView.bottomAnchor),
                         testableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
      case .fullHeightInsideSafeAreas:
         constraints += [testableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                         view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: testableView.bottomAnchor),
                         testableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
      case .atCenter:
         constraints += [testableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                         testableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
      case .margins(let insets):
         constraints += [testableView.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
                         view.bottomAnchor.constraint(equalTo: testableView.bottomAnchor, constant: insets.bottom),
                         testableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
                         view.trailingAnchor.constraint(equalTo: testableView.trailingAnchor, constant: insets.right)]
      case .atCenterWithHeight(let height):
         constraints += [testableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                         testableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                         testableView.heightAnchor.constraint(equalToConstant: height)]
      case .atCenterWithWidth(let width):
         constraints += [testableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                         testableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                         testableView.widthAnchor.constraint(equalToConstant: width)]
      case .fullWidthWithHeight(let height):
         constraints += [testableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                         view.trailingAnchor.constraint(equalTo: testableView.trailingAnchor),
                         testableView.heightAnchor.constraint(equalToConstant: height),
                         testableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
      case .fullHeightWithWidth(let width):
         constraints += [testableView.topAnchor.constraint(equalTo: view.topAnchor),
                         view.bottomAnchor.constraint(equalTo: testableView.bottomAnchor),
                         testableView.widthAnchor.constraint(equalToConstant: width),
                         testableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
      }
      NSLayoutConstraint.activate(constraints)
   }

   // MARK: - Private

   private func setupSafeAreaView() {
      safeAreaView.translatesAutoresizingMaskIntoConstraints = false
      safeAreaView.layer.borderWidth = 0.5
      safeAreaView.layer.borderColor = UIColor.green.cgColor

      view.addSubview(safeAreaView)

      safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
      view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor).isActive = true
      safeAreaView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor).isActive = true
   }

   @objc private func handleTap() {
      view.endEditing(true)
   }
}
#endif
