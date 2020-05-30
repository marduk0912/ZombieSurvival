//
//  GameScene.swift
//  ZombieSurvival
//
//  Created by Fernando on 29/05/2020.
//  Copyright © 2020 Fernando Salvador. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player = SKSpriteNode()
    let playerSpeed: CGFloat = 200.0
    var lastTouchLocation = CGPoint.zero
    var velocityPlayer = CGPoint.zero
    var lastUpdatedTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    
    override func didMove(to view: SKView) {
        
        player = childNode(withName: "player") as! SKSpriteNode
        player.position = CGPoint(x: -800, y: -370)
        player.isPaused = true
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
    
    func updatePlayer (sprite: SKSpriteNode, touchL: CGPoint){
        
        let angle = atan2(player.position.y - lastTouchLocation.y, player.position.x - lastTouchLocation.x) + CGFloat(Double.pi)
        player.run(SKAction.rotate(toAngle: angle + CGFloat(Double.pi * 0.5), duration: 0))
    }
    
   
    override func update(_ currentTime: TimeInterval) {
        
   //     let angle = atan2(player.position.y - lastTouchLocation.y, player.position.x - lastTouchLocation.x) + CGFloat(Double.pi)
        
        if lastUpdatedTime > 0 {
                   dt = currentTime - lastUpdatedTime
               }else{
                   dt = 0
               }
        lastUpdatedTime = currentTime
        
        if (player.position - lastTouchLocation).length() < playerSpeed * CGFloat(dt) {
                  velocityPlayer = CGPoint.zero
                  player.isPaused = true
              }else {
                   moveSprite(sprite: player, velocity: velocityPlayer)
                //   player.run(SKAction.rotate(toAngle: angle + CGFloat(Double.pi * 0.5), duration: 0))
                   updatePlayer(sprite: player, touchL: lastTouchLocation)
              }
    }
    
    func moveSprite(sprite:SKSpriteNode, velocity:CGPoint){
           
           // Espacio es igual a Velocidad por Tiempo
           let cantidad = velocity * CGFloat(dt)
           sprite.position += cantidad
       }
    
    func playerToLocation(location: CGPoint) {
           
           //  Cantidad de movimiento que debemos darle al policia para llegar donde hemos tocado
           let offset = location - player.position
           
           
           // Vector unitario de movimiento
           let direccion = offset.normalized()
           velocityPlayer = direccion * playerSpeed
       }
       
       func sceneTouched(touchLocation: CGPoint){
           
           lastTouchLocation = touchLocation
           playerToLocation(location: touchLocation)
       }
}
