//
//  GameScene2.swift
//  ZombieSurvival
//
//  Created by Fernando on 05/06/2020.
//  Copyright © 2020 Fernando Salvador. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene2: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode()
    var corazon = SKSpriteNode()
    let playerSpeed: CGFloat = 200.0
    var lastTouchLocation = CGPoint.zero
    var zombies: [SKSpriteNode] = []
    let zombieSpeed: CGFloat = 100.0
    var cantidadCorazones: [SKNode] = []
    var nodosLeft: Int = 0
  
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        player = childNode(withName: "player") as! SKSpriteNode
        corazon = childNode(withName: "corazon") as! SKSpriteNode
        player.position = CGPoint(x: -800, y: -370)
        player.isPaused = true
        
        for child in self.children{
            if child.name == "zombie"{
                if let child = child as? SKSpriteNode{
                    zombies.append(child)
                }
            }
        }
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       let touch = touches.first! as UITouch
       let location = touch.location(in: self)
       sceneTouched(touchLocation: location)
       player.isPaused = false
       
      
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       let touch = touches.first! as UITouch
       let location = touch.location(in: self)
       sceneTouched(touchLocation: location)
       
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        updateCamera()
        cantidadCorazones = self["corazon"]
        nodosLeft = cantidadCorazones.count
        newScene()
        
    }
    
    func updatePosition(sprite: SKSpriteNode, target: CGPoint, speed: CGFloat){
        
        
        let currentPosition = player.position
        
        let angle = CGFloat.pi + atan2(currentPosition.y - target.y,
                                       currentPosition.x - target.x)
        let rotateAction = SKAction.rotate(toAngle: angle + (CGFloat.pi*0.5),
                                           duration: 0)
        sprite.run(rotateAction)
        
        
        let velocityX = speed * cos(angle)
        let velocityY = speed * sin(angle)
            
        
        let newVelocity = CGVector(dx: velocityX, dy: velocityY)
        sprite.physicsBody?.velocity = newVelocity
        
        updateCamera()
        
    }
    
       func sceneTouched(touchLocation: CGPoint){
           
        lastTouchLocation = touchLocation
        updatePosition(sprite: player, target: lastTouchLocation, speed: playerSpeed)
        updateZombie()
       }
    
    func updateZombie (){
        let targetPotition = player.position
        
        for zombie in zombies{
            let currentPotition = zombie.position
            let angle = atan2(currentPotition.y - targetPotition.y, currentPotition.x - targetPotition.x) + CGFloat(Double.pi)
            let rotationZombie = SKAction.rotate(toAngle: angle + CGFloat(Double.pi * 0.5), duration: 0)
            zombie.run(rotationZombie)
            let velocityX = zombieSpeed * cos(angle)
            let velocityY = zombieSpeed * sin(angle)
            
            let newVelocity = CGVector(dx: velocityX, dy: velocityY)
            zombie.physicsBody?.velocity = newVelocity
        }
    }
    
    func updateCamera(){
        camera?.position = player.position
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == player.physicsBody?.categoryBitMask && secondBody.categoryBitMask == corazon.physicsBody?.categoryBitMask{
           
                secondBody.node?.removeFromParent()
        }else if secondBody.categoryBitMask == zombies[0].physicsBody?.categoryBitMask{
            gameOver(true)
            }
        }
    
    
    func gameOver(_ lose: Bool) {
      let loseScene = LoseScene(size: size, lose: lose)
      let transition = SKTransition.push(with: .down, duration: 1.0)
      view?.presentScene(loseScene, transition: transition)
    }
    
    func youWin(_ win: Bool) {
      let winScene = WinScene(size: size, win: win)
      let transition = SKTransition.push(with: .down, duration: 1.0)
      view?.presentScene(winScene, transition: transition)
    }
    
    func newScene(){
        if nodosLeft == 0 {
            youWin(true)
        }
    }
    
    
}

