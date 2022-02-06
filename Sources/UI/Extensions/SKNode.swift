//
//  SKNode.swift
//  PIASharedUI
//
//  Created by Rouzbeh Abadi on 12.02.20.
//  Copyright © 2020 Piavita AG. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {

   public convenience init(name: String) {
      self.init()
      self.name = name
   }

   public func addChilds(_ nodes: SKNode...) {
      for node in nodes {
         addChild(node)
      }
   }

   public func addChilds(_ nodes: [SKNode]) {
      for node in nodes {
         addChild(node)
      }
   }
}
