//
//  SmartCache.swift
//  PIAFoundation
//
//  Created by Rouzbeh Abadi on 24.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit
#endif

public class SmartCache<ObjectType: AnyObject>: NSCache<NSString, AnyObject> {}

extension SmartCache {

   public convenience init(name: String) {
      self.init()
      self.name = name
   }

   public convenience init(type: Any.Type) {
      self.init()
      name = String(describing: type)
   }

   public convenience init(limit: Int) {
      self.init()
      totalCostLimit = limit
   }
}

extension SmartCache {

   public func isObjectCached(key: String) -> Bool {
      let value = object(for: key)
      return value != nil
   }

   public func object(for key: String) -> ObjectType? {
      return object(forKey: key as NSString) as? ObjectType
   }

   public func set(object: ObjectType, forKey key: String) {
      setObject(object, forKey: key as NSString)
   }

   public func removeObject(for key: String) {
      removeObject(forKey: key as NSString)
   }
}

extension SmartCache where ObjectType: NSData {

   public func data(for key: String) -> Data? {
      return object(forKey: key as NSString) as? Data
   }

   public func set(data: Data, forKey key: String) {
      setObject(data as NSData, forKey: key as NSString)
   }
}

extension SmartCache where ObjectType: NSNumber {

   public func float(for key: String) -> Float? {
      return object(forKey: key as NSString)?.floatValue
   }

   public func set(float: Float?, forKey key: String) {
      if let value = float {
         setObject(NSNumber(value: value), forKey: key as NSString)
      } else {
         removeObject(for: key)
      }
   }

   public func cgFloat(for key: String) -> CGFloat? {
      if let value = float(for: key) {
         return CGFloat(value)
      } else {
         return nil
      }
   }

   public func set(cgFloat: CGFloat?, forKey key: String) {
      if let value = cgFloat {
         set(float: Float(value), forKey: key)
      } else {
         removeObject(for: key)
      }
   }
}

#if !os(macOS)
extension SmartCache where ObjectType: UIImage {

   public func image(for key: String) -> UIImage? {
      return object(forKey: key as NSString) as? UIImage
   }

   public func set(value: UIImage, forKey key: String) {
      if let cost = cost(for: value) {
         setObject(value, forKey: key as NSString, cost: cost)
      } else {
         setObject(value, forKey: key as NSString)
      }
   }

   private func cost(for image: UIImage) -> Int? {
      if let bytesPerRow = image.cgImage?.bytesPerRow, let height = image.cgImage?.height {
         return bytesPerRow * height // Cost in bytes
      }
      return nil
   }
}
#endif
