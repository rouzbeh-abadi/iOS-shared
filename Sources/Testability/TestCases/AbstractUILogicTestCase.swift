//
//  AbstractUILogicTestCase.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 04.09.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

open class AbstractUILogicTestCase<Expectation, TestCase: TestCaseType>: AbstractLogicTestCase<Expectation, TestCase>
   where TestCase.Expectation == Expectation {

   open var testEnvironment: TestEnvironment {
      return TestSettings.shared.testEnvironment
   }

   public lazy var window = UIWindow(frame: UIScreen.main.bounds)
   var overlayWindow: TestabilityOverlayWindow?

   public lazy var playExpectation = testCase.defaultExpectation(function: #function, file: #file, line: #line)

   open override func setUp() {
      super.setUp()
      UIView.setAnimationsEnabled(testEnvironment.isUnderPlaygroundTesting)
      window.makeKeyAndVisible()
   }

   open override func tearDown() {
      overlayWindow?.isHidden = true
      overlayWindow?.removeFromSuperview()
      window.isHidden = true
      window.removeFromSuperview()
      UIView.setAnimationsEnabled(testEnvironment.isUnderPlaygroundTesting)
      rotate(isLandscape: false)
      super.tearDown()
   }

   public func showWindow(_ window: UIWindow) {
      window.makeKeyAndVisible()
      playIfNeeded()
      window.isHidden = true
      window.removeFromSuperview()
   }

   @discardableResult
   public func presentViewController<T: UIViewController>(_ vc: T, mode: TestableControllerPresentationMode = .fullScreen,
                                                          delay: TimeInterval = 0,
                                                          configureBlock: ((T) throws -> Void)? = nil) -> UIViewController {
      let presenter = UIViewController.makePresenterController()
      configureWindow(mode: mode)
      setRootViewController(presenter, delay: delay)
      waitForAnimationTransactionCompleted {
         presenter.present(vc, animated: true, completion: nil)
      }
      do {
         try configureBlock?(vc)
      } catch {
         assert.shouldNeverHappen(error, file: #file, line: #line)
      }
      playIfNeeded(vc)
      return presenter
   }

   public func showViewController<T: UIViewController>(_ vc: T,
                                                       mode: TestableControllerPresentationMode = .fullScreen,
                                                       delay: TimeInterval = 0,
                                                       shouldPlay: Bool = true,
                                                       configureBlock: ((T) throws -> Void)? = nil) {
      configureWindow(mode: mode)
      setRootViewController(vc, delay: delay)
      if let workItem = configureBlock {
         waitForAnimationTransactionCompleted {
            do {
               try workItem(vc)
            } catch {
               assert.shouldNeverHappen(error, file: #file, line: #line)
            }
         }
      }
      if shouldPlay {
         playIfNeeded(vc)
      }
   }

   public func showViewController<T: UIViewController>(_ vc: T,
                                                       observable: ObservableProperty<Bool>,
                                                       mode: TestableControllerPresentationMode = .fullScreen,
                                                       delay: TimeInterval = 0,
                                                       shouldPlay: Bool = true,
                                                       configure: ((T) throws -> Void)? = nil) {
      wait(observable: observable, configure: {
         showViewController(vc, mode: mode, delay: delay, shouldPlay: shouldPlay, configureBlock: configure)
      })
   }

   func showView(_ view: UIView, size: CGSize) {
      view.frame = CGRect(origin: view.frame.origin, size: size)
      showView(view)
   }

   public func showView(_ view: UIView, width: CGFloat) {
      view.frame = frame(forView: view, fittingWidth: width)
      view.frame = CGRect(origin: view.frame.origin, size: CGSize(width: width, height: view.frame.height))
      let offsetX = 0.5 * (UIScreen.main.bounds.width - view.frame.width)
      if offsetX > 0 {
         view.frame = view.frame.offsetBy(dx: offsetX, dy: 0)
      }
      let offsetY = 0.5 * (UIScreen.main.bounds.height - view.frame.height)
      if offsetY > 0 {
         view.frame = view.frame.offsetBy(dx: 0, dy: offsetY)
      }
      showView(view)
   }

   func showView(_ view: UIView, fittingWidth: CGFloat) {
      view.frame = frame(forView: view, fittingWidth: fittingWidth)
      let offsetX = 0.5 * (UIScreen.main.bounds.width - view.frame.width)
      if offsetX > 0 {
         view.frame = view.frame.offsetBy(dx: offsetX, dy: 0)
      }
      let offsetY = 0.5 * (UIScreen.main.bounds.height - view.frame.height)
      if offsetY > 0 {
         view.frame = view.frame.offsetBy(dx: 0, dy: offsetY)
      }
      showView(view)
   }

   public func showView<T: UIView>(_ view: T, at: CGPoint, configureBlock: ((T) -> Void)? = nil) {
      view.frame = CGRect(origin: at, size: view.frame.size)
      showView(view, configureBlock: configureBlock)
   }

   public func showView<T: UIView>(_ view: T, mode: TestableViewPresentationMode = .fullScreen,
                                   delay: TimeInterval = 0,
                                   isLandscape: Bool = false,
                                   shouldPlay: Bool = true,
                                   configureBlock: ((T) -> Void)? = nil) {
      if isLandscape {
         // This is workaround to `reset` window to initial state.
         // In iOS 12 not needed, but in iOS 13 without this code sequential tests with landscape view cause wrong view size.
         configureWindow(mode: .fullScreen)
         setRootViewController(UIViewController())
      }
      let vc = TestabilityViewController(supportedInterfaceOrientations: isLandscape ? .landscapeRight : nil)
      vc.configure(view: view, mode: mode)
      configureWindow(mode: .fullScreen)
      setRootViewController(vc, delay: delay)
      configureBlock?(view)
      if shouldPlay {
         playIfNeeded(vc)
      }
   }

   @discardableResult
   public func showViews(_ views: UIView..., mode: TestableViewPresentationMode = .fullWidth,
                         axis: NSLayoutConstraint.Axis = .vertical, alignment: UIStackView.Alignment = .fill) -> UIStackView {
      return showViews(views, mode: mode, axis: axis, alignment: alignment)
   }

   @discardableResult
   public func showViews(_ views: [UIView], mode: TestableViewPresentationMode = .fullWidth,
                         axis: NSLayoutConstraint.Axis = .vertical, alignment: UIStackView.Alignment = .fill) -> UIStackView {
      let stackView = UIStackView(arrangedSubviews: views)
      stackView.spacing = 8
      stackView.axis = axis
      stackView.distribution = .equalSpacing
      stackView.alignment = alignment
      showView(stackView, mode: mode)
      return stackView
   }

   private var statusBarOffset: CGFloat {
      var topOffset: CGFloat = 0
      #if os(iOS)
      topOffset = UIApplication.shared.statusBarFrame.size.height
      #endif
      return topOffset
   }

   func frame(forView view: UIView, fittingWidth: CGFloat) -> CGRect {
      let size = view.systemLayoutSizeFitting(CGSize(width: fittingWidth, height: 0),
                                              withHorizontalFittingPriority: .fittingSizeLevel,
                                              verticalFittingPriority: .fittingSizeLevel)
      let frame = CGRect(origin: CGPoint(x: 0, y: statusBarOffset), size: size)
      return frame
   }

   private func performAnimatedTransaction(workItem: () -> Void, completion: @escaping () -> Void) {
      CATransaction.begin()
      CATransaction.setCompletionBlock {
         completion()
      }
      workItem()
      CATransaction.commit()
   }

   public func waitForAnimationTransactionCompleted(delay: TimeInterval? = nil, workItem: () -> Void) {
      let exp = testCase.defaultExpectation(function: #function, file: #file, line: #line)
      performAnimatedTransaction(workItem: workItem) {
         if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
               exp.fulfill()
            }
         } else {
            DispatchQueue.main.async {
               exp.fulfill()
            }
         }
      }
      testCase.wait(for: [exp], timeout: defaultExpectationTimeout, enforceOrder: false)
   }

   public func waitAsyncOnce() {
      // Wait one loop, because controller observe properties on main thread only.
      let exp = testCase.defaultExpectation(function: #function, file: #file, line: #line)
      DispatchQueue.main.async {
         exp.fulfill()
      }
      testCase.wait(for: [exp], timeout: defaultExpectationTimeout, enforceOrder: false)
   }

   public func waitAsync(interval: TimeInterval) {
      let exp = testCase.defaultExpectation(function: #function, file: #file, line: #line)
      DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
         exp.fulfill()
      }
      testCase.wait(for: [exp], timeout: defaultExpectationTimeout, enforceOrder: false)
   }

   public func waitAlongsideTransition(_ vc: UIViewController?, file: StaticString = #file,
                                       line: UInt = #line, workItem: () -> Void) {
      assert.notNil(vc, nil, file: file, line: line)
      guard let vc = vc else {
         return
      }
      let exp = testCase.defaultExpectation(function: #function, file: #file, line: #line)
      workItem()
      vc.transitionCoordinator?.animate(alongsideTransition: nil, completion: { _ in
         exp.fulfill()
      })
      testCase.wait(for: [exp], timeout: defaultExpectationTimeout, enforceOrder: false)
   }

   public func takeScreenshot(_ view: UIView, id: String) -> Screenshot {

      let width = UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale
      let height = UIScreen.main.nativeBounds.size.height / UIScreen.main.nativeScale
      var screenSufix = "\(Int(width))x\(Int(height))"
      if UIDevice.current.userInterfaceIdiom == .pad {
         screenSufix = "\(Int(height))x\(Int(width))" // FIXME: Just to avoid renaming fixtures. Remove it later.
      }

      // After cleanup `rootFolder` should be like `Charts`.
      var rootFolder = (testCaseBundleID.components(separatedBy: ".").last ?? testCaseBundleID)
      rootFolder = rootFolder.replacingOccurrences(of: "Tests", with: "")
      rootFolder = rootFolder.replacingOccurrences(of: "PIA", with: "")

      var fileName = testCaseClassName.replacingOccurrences(of: "Tests", with: "")
      let id = id.replacingOccurrences(of: "test_", with: "").replacingOccurrences(of: "()", with: "")
      fileName += "-" + id + "-" + screenSufix + ".png"

      let pathComponent = rootFolder.appendingPathComponent(fileName)

      let fixturesBundlePath = TestSettings.shared.fixture.bundlePath(for: .screenshot)

      // Disabling blinking cursor
      let textFields = view.recursiveSubviews(for: UITextField.self).filter { $0.isFirstResponder }.map { ($0, $0.tintColor) }
      textFields.forEach { $0.0.tintColor = .clear }

      let localFixturesBundlePath = TestSettings.shared.fixture.localPath(for: .screenshot)
      let screenshot = Screenshot(view: view, pathComponent: pathComponent, fixturesBundlePath: fixturesBundlePath,
                                  localFixturesBundlePath: localFixturesBundlePath)

      textFields.forEach { $0.0.tintColor = $0.1 }
      return screenshot
   }

   func rotate(isLandscape: Bool) {
      let orientation: UIInterfaceOrientation = isLandscape ? .landscapeLeft : .portrait
      let deviceOrientation: UIDeviceOrientation = isLandscape ? .landscapeLeft : .portrait
      if UIApplication.shared.statusBarOrientation != orientation {
         UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
         UIViewController.attemptRotationToDeviceOrientation()
      }
   }
}

extension AbstractUILogicTestCase {

   private func configureWindow(mode: TestableControllerPresentationMode) {
      var rect = window.bounds
      switch mode {
      case .fullScreen:
         break
      case .width(let width):
         rect = CGRect(origin: rect.origin, size: CGSize(width: width, height: rect.height))
      case .margins(let insets):
         rect = rect.inset(by: insets)
      case .size(let size):
         rect = CGRect(origin: rect.origin, size: size)
      }
      window.bounds = rect
   }

   private func setRootViewController(_ vc: UIViewController, delay: TimeInterval = 0) {
      vc.loadViewIfNeeded()
      waitForAnimationTransactionCompleted(delay: delay) {
         window.rootViewController = vc
      }
   }

   public func playIfNeeded(_ vc: UIViewController? = nil) {
      if testEnvironment.isUnderPlaygroundTesting {
         play(vc)
      }
   }

   private func play(_ vc: UIViewController? = nil) {
      var sizes = TestabilityScreenSize.allCases.filter {
         $0.size.width <= window.bounds.width && $0.size.height <= window.bounds.height
      }
      if UIDevice.current.userInterfaceIdiom == .pad {
         sizes = []
      }

      overlayWindow = TestabilityOverlayWindow()
      overlayWindow?.isHidden = false
      overlayWindow?.viewController.eventHandler = { [weak vc, weak self] in
         switch $0 {
         case .close:
            self?.playExpectation.fulfill()
         case .showMenu:
            if sizes.count == 1 || sizes.isEmpty {
               self?.playExpectation.fulfill()
            } else if let presenter = vc {
               let menu = TestabilityMenuViewController()
               menu.activeSizes = sizes
               menu.popoverPresentationController?.sourceView = presenter.view
               menu.popoverPresentationController?.sourceRect = CGRect(x: 8, y: 8, width: 8, height: 8)
               presenter.present(menu, animated: false, completion: nil)
               menu.eventHandler = { event in
                  vc?.dismiss(animated: false) {
                     switch event {
                     case .close:
                        self?.playExpectation.fulfill()
                     case .resize(let size):
                        if let vc = vc {
                           self?.resize(viewController: vc, to: size)
                        }
                     }
                  }
               }
            } else {
               self?.playExpectation.fulfill()
            }
         }
      }
      testCase.wait(for: [playExpectation], timeout: 360, enforceOrder: false)
   }

   private func resize(viewController: UIViewController, to: TestabilityScreenSize) {
      let size = to.size
      let windowSize = window.bounds.size

      if windowSize.width == size.width, windowSize.height == size.height {
         viewController.view.frame = CGRect(origin: CGPoint(), size: size)
         return
      }
      var origin = CGPoint(x: 0.5 * (windowSize.width - size.width),
                           y: windowSize.height - size.height - window.safeAreaInsets.bottom)
      if let value = TestabilityScreenSize(size: windowSize) {
         let keyboardSizeDifference = value.keyboardHeight - to.keyboardHeight - window.safeAreaInsets.bottom
         origin = CGPoint(x: origin.x, y: origin.y - keyboardSizeDifference)
      }
      guard origin.x >= 0, origin.y >= 0 else {
         return
      }
      viewController.view.frame = CGRect(origin: origin, size: size)
   }
}
#endif
