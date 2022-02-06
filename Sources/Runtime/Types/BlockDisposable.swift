//
//  BlockDisposable.swift
//  PIARuntime
//
//  Created by Rouzbeh Abadi on 08.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

public final class BlockDisposable {

   private var handler: (() -> Void)?

   private let lock = NSRecursiveLock()

   public init(_ handler: @escaping () -> Void) {
      self.handler = handler
   }

   deinit {
      dispose()
   }
}

extension BlockDisposable: Disposable {

   public var isDisposed: Bool {
      return handler == nil
   }

   public func dispose() {
      lock.lock()

      handler?()
      handler = nil

      lock.unlock()
   }
}
