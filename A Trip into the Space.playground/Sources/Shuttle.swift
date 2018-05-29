//
//  Shuttle.swift
//  game_wwdc2018
//
//  Created by Ernesto De Crecchio on 23/03/18.
//  Copyright © 2018 ernesto-de-crecchio. All rights reserved.
//

import SpriteKit

public class Shuttle: SKSpriteNode {
  
  var lives = 3
  var support: SKSpriteNode?
  var removedSupport = false
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
    
    self.name = "shuttle"
    self.zPosition = Z.player
    
    self.physicsBody = SKPhysicsBody(texture: texture!, size: size)//(rectangleOf: size)
    self.physicsBody?.mass = 40.0
    self.physicsBody!.isDynamic = true
    self.physicsBody!.affectedByGravity = true
    self.physicsBody?.allowsRotation = false
    
    self.physicsBody?.categoryBitMask = PhysicsMask.player
    self.physicsBody?.contactTestBitMask = PhysicsMask.asteroid
    
    support = SKSpriteNode(imageNamed: "SupportShuttle")
    support?.size = CGSize(width: self.size.width - 10, height: self.size.height+30)
    support?.position.y = 20
    support?.zPosition = -7
    self.addChild(support!)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(position: CGPoint) {
    self.position = position
  }
  
  func removeSupport() {
    if removedSupport == false {
      removedSupport = true
      let moveAction = SKAction.move(by: CGVector(dx: 0, dy: -500), duration: 1.5)
      let removeAction = SKAction.removeFromParent()
      support?.run(SKAction.sequence([moveAction,removeAction]))
    }
  }
}
