//
//  ObservableProperty.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 08.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public final class ObservableProperty<T> {

   public typealias Observer = (T) -> Void

   public var value: T {
      willSet {
         willSet?(value, newValue)
      }
      didSet {
         container.fire(value)
         didSet?(oldValue, value)
      }
   }

   private let container = ObserversContainer<T>()
   private let willSet: ((_ old: T, _ new: T) -> Void)?
   private let didSet: ((_ old: T, _ new: T) -> Void)?

   public init(_ value: T, willSet: ((_ old: T, _ new: T) -> Void)? = nil, didSet: ((_ old: T, _ new: T) -> Void)? = nil) {
      self.value = value
      self.willSet = willSet
      self.didSet = didSet
   }

   public func addObserver(fireWithInitialValue: Bool = false, on queue: DispatchQueue? = nil,
                           _ observer: @escaping Observer) -> Disposable {
      let result = container.addObserver(on: queue, observer)
      if fireWithInitialValue {
         if let queue = queue {
            queue.async { observer(self.value) }
         } else {
            observer(value)
         }
      }
      return result
   }

   public func removeAllObservers() {
      container.removeAllObservers()
   }

   public func setValue(_ value: T, on: DispatchQueue) {
      on.async {
         self.value = value
      }
   }
}

public func <- <T>(left: ObservableProperty<T>, right: T) {
   left.value = right
}

public postfix func ^ <T>(left: ObservableProperty<T>) -> T {
   return left.value
}
