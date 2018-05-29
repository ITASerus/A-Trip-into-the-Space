//
//  Asteroid.swift
//  game_wwdc2018
//
//  Created by Ernesto De Crecchio on 26/03/18.
//  Copyright © 2018 ernesto-de-crecchio. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode {
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
    
    self.name = "asteroid"
    self.zPosition = Z.player
    
    self.physicsBody = SKPhysicsBody(texture: texture!, size: size)
    self.physicsBody?.mass = 1.0
    self.physicsBody!.isDynamic = true
    self.physicsBody!.affectedByGravity = false
    self.physicsBody?.allowsRotation = true
    
    self.physicsBody?.categoryBitMask = PhysicsMask.asteroid
    self.physicsBody?.collisionBitMask = PhysicsMask.player | PhysicsMask.asteroid
    self.physicsBody?.contactTestBitMask = PhysicsMask.player
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
