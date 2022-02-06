#if !os(macOS)
import UIKit

open class ReusableScene: UIView, ReusableContentView {

   public private(set) weak var controller: UIViewController?

   open func willAppear(_ animated: Bool) {

   }

   open func didAppear(_ animated: Bool) {

   }

   open func willDisappear(_ animated: Bool) {

   }

   open func didDisappear(_ animated: Bool) {

   }

   public func setController(_ controller: UIViewController) {
      self.controller = controller
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   public var navigationItem: UINavigationItem? {
      return controller?.navigationItem
   }

   @objc open dynamic func setupUI() {
      // Base class does nothing.
   }

   @objc open dynamic func setupLayout() {
      // Base class does nothing.
   }

   @objc open dynamic func setupHandlers() {
      // Base class does nothing.
   }

   @objc open dynamic func setupDefaults() {
      // Base class does nothing.
   }
}
#endif
