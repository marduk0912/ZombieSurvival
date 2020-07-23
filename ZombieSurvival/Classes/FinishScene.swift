//
//  FinishScene.swift
//  ZombieSurvival
//
//  Created by Fernando on 22/07/2020.
//  Copyright © 2020 Fernando Salvador. All rights reserved.
//

import SpriteKit

class FinishScene: SKScene {
    
    var finish: Bool
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(size: CGSize, finish: Bool){
        self.finish = finish
        super.init(size: CGSize(width: 2048, height: 1024))
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
       
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showIntertitial"), object: nil)
        
        // Background
            let background = SKSpriteNode(imageNamed: "winning)")
            background.position = CGPoint(x: 0, y: 0)
            background.zPosition = -10
            background.scale(to: CGSize(width: 2048, height: 1024))
            background.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            
            addChild(background)
        
        // Set up labels
           let text = finish ? "Felicitaciones!!! Has terminado el juego" : "Hola"
           let finishLabel = SKLabelNode(text: text)
           finishLabel.fontName = "Chalkduster"
           finishLabel.fontSize = 65
           finishLabel.fontColor = .red
           finishLabel.position = CGPoint(x: frame.midX, y: frame.midY*1.5 - 90)
           addChild(finishLabel)

           let label = SKLabelNode(text: "Presiona la pantalla para comenzar nuevamente")
           label.fontName = "Chalkduster"
           label.fontSize = 55
           label.fontColor = .red
           label.position = CGPoint(x: frame.midX, y: frame.midY - 150)
           addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let gameScene = SKScene(fileNamed: "MainMenu") else {
           fatalError("GameScene not found")
         }
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.8)
          gameScene.scaleMode = .aspectFill
          view?.presentScene(gameScene, transition: transition)
       }
    

}
