//
//  GameScene.swift
//  game_wwdc2018
//
//  Created by Ernesto De Crecchio on 23/03/18.
//  Copyright © 2018 ernesto-de-crecchio. All rights reserved.
//

import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
  
  let startBackground = SKSpriteNode(imageNamed: "backgroundstart")
  let marsSprite = SKSpriteNode(imageNamed: "Mars")
  
  //Management
  var sliderIndicatorTouched = false //Indicates if the slider insidator has been touched
  var outOfTrajectory = false //Indicates if the shuttle is out of borders of the screen
  var tooSlow = false //Indicates if the velocity fo the shuttle is too low to start flying
  var startSpawningEnemies = false //Indicates if enemies are spawning
  var alerting = false //Indicates if there is an alert message activated
  var borders = SKShapeNode() //Borders of the playable area
  
  //Actors
  let player = Shuttle(texture: SKTexture.init(imageNamed: "Shuttle"), color: .yellow, size: CGSize(width: 80, height: 120))
  let hud = HUD()
  
  //Camera
  let cameraNode = SKCameraNode()
  var cameraRect : CGRect {
    let x = cameraNode.position.x - size.width/2
    let y = cameraNode.position.y - size.height/2
    return CGRect(x: x, y: y, width: size.width, height: size.height)
  }
  
  override public init(size: CGSize) {
    super.init(size: size)
    self.backgroundColor = .black
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //Before the Scene
  override public func sceneDidLoad() {
    self.physicsWorld.contactDelegate = self
    self.physicsWorld.gravity = CGVector(dx:0, dy: -9.8)
  }
  
  override public func didMove(to view: SKView) {
    startBackground.anchorPoint = CGPoint.zero
    startBackground.zPosition = Z.background
    startBackground.position.x = (scene?.position.x)!
    addChild(startBackground)
    
    let backgorundstartDecorations = SKSpriteNode(imageNamed: "backgroundStartDecorations")
    backgorundstartDecorations.zPosition = Z.Clouds
    backgorundstartDecorations.position = CGPoint(x: backgorundstartDecorations.size.width/2, y: backgorundstartDecorations.size.height/2 + startBackground.position.y + 139)
    addChild(backgorundstartDecorations)
    
    for i in 0...1 {
      let background = backgroundNode()
      background.anchorPoint = CGPoint.zero
      background.position = CGPoint(x: 0, y: CGFloat(i)*background.size.height + startBackground.size.height)
      background.name = "background"
      background.zPosition = Z.background
      addChild(background)
    }
    //MARK: SETUP
    
    //Player Setup
    player.setup(position: CGPoint(x: (scene?.size.width)!/2, y: frame.minY + 60))
    addChild(player)
    
    //Mars Setup
    marsSprite.position = CGPoint(x: (scene?.size.width)!/2, y: 20000)
    marsSprite.zPosition = Z.Mars
    addChild(marsSprite)
    
    //Moon Setup
    let moonSprite = SKSpriteNode(imageNamed: "Moon")
    moonSprite.position = CGPoint(x: (scene?.size.width)!, y: 4000)
    marsSprite.zPosition = Z.Mars
    addChild(moonSprite)
    
    //Camera Setup
    cameraNode.position = CGPoint(x: (scene?.size.width)!/2, y: cameraRect.size.height/2)
    addChild(cameraNode)
    camera = cameraNode
    
    //HUD Setup
    hud.setup(size: cameraRect.size)
    cameraNode.addChild(hud)
    hud.startTimer()
    
    //Border Setup
    let playableRect = CGRect(x: 0, y: 0, width: frame.width + (player.size.width*4), height: frame.height)
    borders = SKShapeNode(rect: playableRect)
    borders.strokeColor = .clear
    borders.position = CGPoint(x: -frame.width/2 - player.size.width*2, y: -frame.height/2)
    borders.physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
    borders.physicsBody?.friction = 0
    borders.physicsBody?.categoryBitMask = PhysicsMask.borders
    
    cameraNode.addChild(borders)
  }
  
  public func didBegin(_ contact: SKPhysicsContact) {
    if (contact.bodyA.categoryBitMask == PhysicsMask.player) {
      if (contact.bodyB.categoryBitMask == PhysicsMask.asteroid) {
        player.lives -= 1
        
        contact.bodyB.node?.physicsBody?.categoryBitMask = PhysicsMask.removedAsteroid
        let scaleDown = SKAction.scale(to: 0, duration: 1)
        let remove = SKAction.removeFromParent()
        let removeActions = [scaleDown, remove]
        contact.bodyB.node?.run(SKAction.sequence(removeActions))
        
        //Death for explosion
        if player.lives < 0 {
          let gameOverScene = GameOverScene(size: size, type: 4)
          gameOverScene.scaleMode = scaleMode
          view?.presentScene(gameOverScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
        }
      }
    }
  }
  
  //MARK: TOUCH FUNCTIONS
  func touchDown(atPoint pos : CGPoint) {
    let touchedNode = self.atPoint(pos)
    if touchedNode.name == "sliderIndicator" {
      sliderIndicatorTouched = true
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if sliderIndicatorTouched {
      hud.slider_updatePositionIndicator(pos: pos)
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    sliderIndicatorTouched = false
    
    let touchedNode = self.atPoint(pos)
    if touchedNode.name == "leftEngineButton" && player.position.y >= startBackground.size.height {
      player.run(SKAction.moveBy(x: 50, y: 0, duration: 0.5))
    }
    
    if touchedNode.name == "rightEngineButton" && player.position.y >= startBackground.size.height {
      player.run(SKAction.moveBy(x: -50, y: 0, duration: 0.5))
    }
  }
  
  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchMoved(toPoint: t.location(in: cameraNode)) }
  }
  
  override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  func spawnAsteroid(startPoint: CGFloat) {
    let texture: SKTexture
    let size: CGSize
    if player.position.y <= 4000 {
      texture = SKTexture(imageNamed: "Satellite")
      size = CGSize(width: 80, height: 40)
    } else {
      texture = SKTexture(imageNamed: "Asteroid")
      size = CGSize(width: 75, height: 50)
    }
    
    let asteroid = Asteroid(texture: texture, color: .black, size: size)
    
    let randomX = CGFloat(arc4random_uniform(UInt32((scene?.size.width)!)))
    let randomY = CGFloat(arc4random_uniform(UInt32((scene?.size.height)!)))
    asteroid.position = CGPoint(x: randomX, y: player.position.y + cameraRect.size.height + randomY)
    addChild(asteroid)
    
    asteroid.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -100))
  }
  
  func spawnEnemies() {
    if startSpawningEnemies == false {
      startSpawningEnemies = true
      run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {
        [weak self] in self?.spawnAsteroid(startPoint: (self?.startBackground.size.height)!)
        }, SKAction.wait(forDuration: 1.0)])))
    }
  }
  
  func checkDeleteAsteroid() {
    enumerateChildNodes(withName: "asteroid") { asteroid, _ in
      if  asteroid.position.y < self.player.position.y - self.cameraRect.size.height/2 {
        asteroid.removeFromParent()
      }
    }
  }
  
  func checkOutOfTrajectory() {
    if (player.position.x < 0 || player.position.x > frame.width) {
      outOfTrajectory = true
      if(alerting == false) {
        hud.presentAlert(typeAlert: 0)
        alerting = true
        
        //Death for out of trajectory
        let countdown = SKAction.wait(forDuration: 5)
        let changeScene = SKAction.run({
          let gameOverScene = GameOverScene(size: self.size, type: 3)
          gameOverScene.scaleMode = self.scaleMode
          self.view?.presentScene(gameOverScene, transition: SKTransition.crossFade(withDuration: 0.5))
        })
        self.run(SKAction.sequence([countdown, changeScene]), withKey: "countdown")
      }
    } else {
      outOfTrajectory = false
      self.removeAction(forKey: "countdown")
      hud.removeAlert()
      alerting = false
    }
  }
  
  func checkWin() {
    if player.position.y >= marsSprite.position.y - marsSprite.size.height/4 {
      let gameOverScene = GameOverScene(size: size, type: 1)
      gameOverScene.scaleMode = scaleMode
      view?.presentScene(gameOverScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
    }
  }
  
  func backgroundNode() -> SKSpriteNode {
    let backgroundNode = SKSpriteNode()
    backgroundNode.anchorPoint = CGPoint.zero
    backgroundNode.name = "background"
    
    let background1 = SKSpriteNode(imageNamed: "background1")
    background1.anchorPoint = CGPoint.zero
    background1.position = CGPoint(x: 0, y: 0)
    backgroundNode.addChild(background1)
    
    let background2 = SKSpriteNode(imageNamed: "background1")
    background2.anchorPoint = CGPoint.zero
    background2.position = CGPoint(x: 0, y: background1.size.height)
    backgroundNode.addChild(background2)
    
    backgroundNode.size = CGSize(
      width: background1.size.width,
      height: background1.size.height + background2.size.height)
    return backgroundNode
  }
  
  func moveCamera() {
    if player.position.y > cameraRect.size.height/4 {
      cameraNode.position.y = player.position.y + cameraRect.size.height/4
    }
    
    enumerateChildNodes(withName: "background") { node, _ in
      let background = node as! SKSpriteNode
      if background.position.y + background.size.height < self.cameraRect.origin.y {
        background.position = CGPoint(x: background.position.x, y: background.position.y + background.size.height*2)
      }
    }
  }
  
  //MARK: UPDATE
  override public func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    player.physicsBody?.velocity = CGVector(dx: 0, dy: hud.slider_checkValue())
    
    
    if player.position.y >= startBackground.size.height {
      player.physicsBody?.affectedByGravity = false
      spawnEnemies()
      player.removeSupport()
    }
    
    checkOutOfTrajectory()
    checkDeleteAsteroid()
    checkWin()
    
    //Death for oxigen finished
    if hud.timerLabelValue <= 0 {
      let gameOverScene = GameOverScene(size: size, type: 2)
      gameOverScene.scaleMode = scaleMode
      view?.presentScene(gameOverScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
    }
    
    moveCamera()
  }
}
