//
//  DisplayLink.swift
//  PIAShared
//
//  Created by Rouzbeh Abadi on 22.01.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

#if !os(macOS)
import Foundation
import QuartzCore

public class DisplayLink {

   private lazy var displayLink = CADisplayLink(target: self, selector: #selector(performTasks))

   public var isPaused: Bool {
      return displayLink.isPaused
   }

   public var timestamp: CFTimeInterval {
      return displayLink.timestamp
   }

   public var targetTimestamp: CFTimeInterval {
      return displayLink.targetTimestamp
   }

   public var duration: CFTimeInterval {
      return displayLink.duration
   }

   public var callback: (() -> Void)?

   deinit {
      displayLink.invalidate()
   }

   public init(preferredFramesPerSecond: Int) {
      displayLink.preferredFramesPerSecond = preferredFramesPerSecond
      displayLink.isPaused = true
      displayLink.add(to: .current, forMode: RunLoop.Mode.default)
   }

   public func start() {
      displayLink.isPaused = false
   }

   public func stop() {
      displayLink.isPaused = true
   }

   // MARK: - Private

   @objc private func performTasks() {
      callback?()
   }
}
#endif
