//
//  WinScene.swift
//  ZombieSurvival
//
//  Created by Fernando on 05/06/2020.
//  Copyright © 2020 Fernando Salvador. All rights reserved.
//

import SpriteKit

class WinScene: SKScene {
    
    var win: Bool
    var lvl = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(size: CGSize, win: Bool, lvl: Int){
        self.win = win
        super.init(size: size)
        self.lvl = lvl
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(white: 0.3, alpha: 1)
        
        // Set up labels
           let text = win ? "You Won 😃" : "Hola"
           let loseLabel = SKLabelNode(text: text)
           loseLabel.fontName = "AvenirNext-Bold"
           loseLabel.fontSize = 65
           loseLabel.fontColor = .white
           loseLabel.position = CGPoint(x: frame.midX, y: frame.midY*1.5)
           addChild(loseLabel)

           let label = SKLabelNode(text: "Press anywhere to play again!")
           label.fontName = "AvenirNext-Bold"
           label.fontSize = 55
           label.fontColor = .white
           label.position = CGPoint(x: frame.midX, y: frame.midY)
           addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let gameScene = SKScene(fileNamed: "GameScene\(lvl)") else {
           fatalError("GameScene not found")
         }
          let transition = SKTransition.push(with: .down, duration: 1.0)
          gameScene.scaleMode = .aspectFill
          view?.presentScene(gameScene, transition: transition)
       }
    

}
