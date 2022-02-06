//
//  Array.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 13.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation

extension Array {

   public func element(at index: Int) -> Element? {
      if index < 0 || index >= count {
         return nil
      }
      return self[index]
   }

   public func chunked(into size: Int) -> [[Element]] {
      return stride(from: 0, to: count, by: size).map {
         Array(self[$0 ..< Swift.min($0 + size, count)])
      }
   }
}

extension Array where Element: Equatable {

   public var distinct: [Element] {
      var uniqueValues: [Element] = []
      forEach { item in
         if !uniqueValues.contains(item) {
            uniqueValues.append(item)
         }
      }
      return uniqueValues
   }

   public func ordered(by preferredOrder: [Element]) -> [Element] {
      // See also: https://stackoverflow.com/a/51683055/1418981
      return sorted { left, right in
         guard let first = preferredOrder.firstIndex(of: left) else {
            return false
         }
         guard let second = preferredOrder.firstIndex(of: right) else {
            return true
         }
         return first < second
      }
   }
}

extension Array where Element == Range<Int> {

   public func combined() -> [Range<Int>] {
      var combined = [Range<Int>]()
      var accumulator = 0 ..< 0 // empty range
      for interval in sorted(by: { $0.lowerBound < $1.lowerBound }) {
         if accumulator == 0 ..< 0 {
            accumulator = interval
         }
         if accumulator.upperBound >= interval.upperBound {
            // interval is already inside accumulator
         } else if accumulator.upperBound >= interval.lowerBound {
            // interval hangs off the back end of accumulator
            accumulator = accumulator.lowerBound ..< interval.upperBound
         } else if accumulator.upperBound <= interval.lowerBound {
            // interval does not overlap
            combined.append(accumulator)
            accumulator = interval
         }
      }
      if accumulator != 0 ..< 0 {
         combined.append(accumulator)
      }
      return combined
   }
}
