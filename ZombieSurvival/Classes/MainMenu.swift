//
//  MainMenu.swift
//  ZombieSurvival
//
//  Created by Fernando on 22/06/2020.
//  Copyright © 2020 Fernando Salvador. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenu: SKScene{
    
    override func didMove(to view: SKView){
        let background = SKSpriteNode(imageNamed: "horror-1848696_1920")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -100
        background.scale(to: CGSize(width: 2048, height: 1024))
        addChild(background)
        
        let textNameGame = "Zombie Survival"
        let nameGameLabel = SKLabelNode(text: textNameGame)
        nameGameLabel.name = "new"
        nameGameLabel.fontName = "Chalkduster"
        nameGameLabel.fontSize = 130
        nameGameLabel.fontColor = .white
        nameGameLabel.position = CGPoint(x: size.width/2, y: size.height - 150)
        addChild(nameGameLabel)
        
        let textNewGame = "New Game"
        let newGameLabel = SKLabelNode(text: textNewGame)
        newGameLabel.name = "new"
        newGameLabel.fontName = "Chalkduster"
        newGameLabel.fontSize = 65
        newGameLabel.fontColor = .white
        newGameLabel.position = CGPoint(x: size.width/3 - 100, y: size.height/5 - 100)
        addChild(newGameLabel)
        
        let textLoadGame = "Load Game"
        let loadGameLabel = SKLabelNode(text: textLoadGame)
        loadGameLabel.name = "load"
        loadGameLabel.fontName = "Chalkduster"
        loadGameLabel.fontSize = 65
        loadGameLabel.fontColor = .white
        loadGameLabel.position = CGPoint(x: size.width/2 + 400, y: size.height/5 - 100)
        addChild(loadGameLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        
        if let touchNode = atPoint(touch.location(in: self)) as? SKLabelNode{
            if touchNode.name == "new"{
                guard let gameScene = SKScene(fileNamed: "GameScene1") else {
                  fatalError("GameScene not found")
                }
                 let transition = SKTransition.push(with: .down, duration: 1.0)
                 gameScene.scaleMode = .aspectFill
                 view?.presentScene(gameScene, transition: transition)
            }else if touchNode.name == "load"{
                if let scene = GameScene1.loadGame() ?? SKScene(fileNamed: "GameScene1"){
                 let transition = SKTransition.push(with: .down, duration: 1.0)
                 scene.scaleMode = .aspectFill
                 view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
