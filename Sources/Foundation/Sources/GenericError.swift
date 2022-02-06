//
//  GenericError.swift
//  Piavita
//
//  Created by Rouzbeh Abadi on 26.10.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

// FIXME: Localize. After `error flow` reviewed then change this.
import Foundation

public struct GenericError: Swift.Error {

   public enum Kind {
      case unableToInitialize(Any.Type)
      case shouldNotBeNil(Any.Type)
   }

   public let message: String

   public init(message: String) {
      self.message = message
   }

   public init(kind: Kind) {
      message = kind.localizedDescription
   }
}

extension GenericError: LocalizedError {

   public var errorDescription: String? {
      return message
   }
}

extension GenericError.Kind {

   var localizedDescription: String {
      switch self {
      case .unableToInitialize(let type):
         return "Unable to initialize \(String(describing: type))"
      case .shouldNotBeNil(let type):
         return "Should not be nil \(String(describing: type))"
      }
   }
}
