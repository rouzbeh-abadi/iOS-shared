import Foundation

extension DispatchQueue {

   public func testabilityAsyncAfter(delay: TimeInterval, qos: DispatchQoS = .unspecified,
                                     flags: DispatchWorkItemFlags = [], execute work: @escaping () -> Void) {
      testabilityAsyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
   }

   public func testabilityAsyncAfter(deadline: DispatchTime, qos: DispatchQoS = .unspecified,
                                     flags: DispatchWorkItemFlags = [], execute work: @escaping () -> Void) {
      if RuntimeInfo.isUnderTesting {
         asyncAfter(deadline: .now(), qos: qos, flags: flags, execute: work)
      } else {
         asyncAfter(deadline: deadline, qos: qos, flags: flags, execute: work)
      }
   }
}
