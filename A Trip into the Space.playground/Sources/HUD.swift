//
//  HUD.swift
//  game_wwdc2018
//
//  Created by Ernesto De Crecchio on 24/03/18.
//  Copyright © 2018 ernesto-de-crecchio. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
  
  let spacing:CGFloat = 5
  
  let leftEngineButton = SKSpriteNode(texture: SKTexture(imageNamed: "Engine"))
  let rightEngineButton = SKSpriteNode(texture: SKTexture(imageNamed: "Engine"))
  
  let sliderBar = SKSpriteNode(texture: SKTexture(imageNamed: "Slider1"))
  let sliderIndicator = SKSpriteNode(texture: SKTexture(imageNamed: "Slider2"))
  
  let timerLabel = SKLabelNode(fontNamed: "DIN Condensed")
  var timerLabelValue: Int = 200 {
    didSet {
      timerLabel.text = "Oxygen Left: \(timerLabelValue)"
    }
  }
  
//  let alert = SKSpriteNode(texture: SKTexture(imageNamed: "Alert"))
  var alert = SKSpriteNode()

  override init() {
    super.init()
    self.name = "HUD"
    self.zPosition = Z.HUD
    
    leftEngineButton.name = "leftEngineButton"
    leftEngineButton.scale(to: CGSize(width: 45, height: 75))
    leftEngineButton.alpha = 0.5
    
    rightEngineButton.name = "rightEngineButton"
    rightEngineButton.scale(to: CGSize(width: -45, height: 75))
    rightEngineButton.alpha = 0.5
    
    sliderBar.name = "slideBar"
    sliderBar.scale(to: CGSize(width: 30, height: 250))
    sliderBar.alpha = 0.5
    
    sliderIndicator.name = "sliderIndicator"
    sliderIndicator.zPosition = 110
    sliderIndicator.alpha = 1
    sliderIndicator.scale(to: CGSize(width: 40, height: 25))
    
    timerLabel.fontColor = SKColor.white
    timerLabel.fontSize = 20
    timerLabel.horizontalAlignmentMode = .left
    timerLabel.verticalAlignmentMode = .bottom
    
    alert.name = "alert"
    alert.zPosition = 120
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(size: CGSize) {
    rightEngineButton.position = CGPoint(x: size.width/2 - rightEngineButton.size.width/2 - spacing, y: -size.height/2 + rightEngineButton.size.height/2 + spacing)
    addChild(rightEngineButton)
    
    leftEngineButton.position = CGPoint(x: rightEngineButton.position.x - leftEngineButton.size.width - spacing, y: rightEngineButton.position.y)
    addChild(leftEngineButton)
    
    sliderBar.position = CGPoint(x: leftEngineButton.position.x + sliderBar.size.width/2 - spacing, y: leftEngineButton.position.y + leftEngineButton.size.height/2 + sliderIndicator.size.height/2 + spacing)
    sliderBar.anchorPoint = .zero
    addChild(sliderBar)
    
    sliderIndicator.position = CGPoint(x: sliderBar.position.x + sliderBar.size.width/2, y: sliderBar.frame.minY)
    addChild(sliderIndicator)
    
    timerLabel.position = CGPoint(x: -size.width/2 + spacing, y: -size.height/2 + spacing)
    timerLabel.text = "Oxigen Left: \(timerLabelValue)"
    addChild(timerLabel)
  }
  
  func slider_updatePositionIndicator(pos: CGPoint) {
    if (pos.y >= sliderBar.frame.minY) && (pos.y <= sliderBar.frame.maxY) {
      sliderIndicator.position.y = pos.y
    }
  }
  
  func slider_checkValue() -> CGFloat {
    return CGFloat((sliderIndicator.position.y  + 236) * 3)
  }
  
  func startTimer() {
    let wait = SKAction.wait(forDuration: 1)
    let block = SKAction.run({[unowned self] in
      if self.timerLabelValue > 0{
        self.timerLabelValue -= 1
      } else {
        self.removeAction(forKey: "countdown")
      }
    })
    
    let sequence = SKAction.sequence([wait, block])
    run(SKAction.repeatForever(sequence), withKey: "countdown")
  }
  
  func presentAlert(typeAlert: Int) {
    let fadeOut = SKAction.fadeOut(withDuration: 0.5)
    let fadeIn = SKAction.fadeIn(withDuration: 0.5)

    let animation = SKAction.sequence([fadeIn, fadeOut])
    
    switch typeAlert {
    case 1:
      alert = SKSpriteNode(texture: SKTexture(imageNamed: "Alert Velocity"))
      break
    default:
      alert = SKSpriteNode(texture: SKTexture(imageNamed: "Alert"))
      break
    }
    
    addChild(alert)
    alert.run(SKAction.repeatForever(animation), withKey: "fading")
  }
  
  func removeAlert() {
    alert.alpha = 1 //Reset the aplha
    alert.removeAllActions()
    alert.removeFromParent()
  }
}
