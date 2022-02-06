//
//  PersistentStoreType.swift
//  PIAPersistence
//
//  Created by Rouzbeh Abadi on 27.11.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import CoreData

public enum PersistentStoreType: Int {

   case memory, sql

   public var stringValue: String {
      switch self {
      case .memory:
         return NSInMemoryStoreType
      case .sql:
         return NSSQLiteStoreType
      }
   }
}
