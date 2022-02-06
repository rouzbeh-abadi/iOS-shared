//
//  ObserversContainer.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 08.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public final class ObserversContainer<T> {

   private var observers: [Int: Observer] = [:]
   private var uniqueID = (0...).makeIterator()

   public init() {}

   public func addObserver(on queue: DispatchQueue? = nil, _ observer: @escaping (T) -> Void) -> Disposable {
      guard let id = uniqueID.next() else {
         fatalError("There should always be a next unique id")
      }
      observers[id] = Observer(queue, observer)
      let disposable = BlockDisposable {
         self.observers[id] = nil
      }

      return disposable
   }

   public func fire(_ value: T) {
      observers.values.forEach { observer in
         if let queue = observer.queue {
            queue.async { observer.handler(value) }
         } else {
            observer.handler(value)
         }
      }
   }

   public func removeAllObservers() {
      observers.removeAll()
   }

   private class Observer {

      let queue: DispatchQueue?
      let handler: (T) -> Void

      init(_ queue: DispatchQueue?, _ handler: @escaping (T) -> Void) {
         self.queue = queue
         self.handler = handler
      }
   }
}
