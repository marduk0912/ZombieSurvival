//
//  WinScene.swift
//  ZombieSurvival
//
//  Created by Fernando on 05/06/2020.
//  Copyright © 2020 Fernando Salvador. All rights reserved.
// id admob interstitial demo: ca-app-pub-3940256099942544/4411468910


import SpriteKit

class WinScene: SKScene {
    
    var win: Bool
    var lvl = 0
    var levelPass = SKScene()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(size: CGSize, win: Bool, lvl: Int){
        self.win = win
        super.init(size: CGSize(width: 2048, height: 1024))
        self.lvl = lvl
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
       
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showIntertitial"), object: nil)
        
        levelPass = SKScene(fileNamed: "GameScene\(lvl - 1)")!
        levelPass.view?.removeFromSuperview()
        
        // Background
            let background = SKSpriteNode(imageNamed: "win\(lvl - 1)")
            background.position = CGPoint(x: 0, y: 0)
            background.zPosition = -10
            background.scale(to: CGSize(width: 2048, height: 1024))
            background.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            
            addChild(background)
        
        // Set up labels
           let text = win ? "You Won 😃" : "Hola"
           let loseLabel = SKLabelNode(text: text)
           loseLabel.fontName = "Chalkduster"
           loseLabel.fontSize = 65
           loseLabel.fontColor = .red
           loseLabel.position = CGPoint(x: frame.midX, y: frame.midY*1.5 - 90)
           addChild(loseLabel)

           let label = SKLabelNode(text: "Press anywhere to play level \(lvl)")
           label.fontName = "Chalkduster"
           label.fontSize = 55
           label.fontColor = .red
           label.position = CGPoint(x: frame.midX, y: frame.midY - 150)
           addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        guard let gameScene = SKScene(fileNamed: "GameScene\(lvl)") else {
           fatalError("GameScene not found")
         }
        
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
          gameScene.scaleMode = .aspectFill
          view?.presentScene(gameScene, transition: transition)
       }
    
}




