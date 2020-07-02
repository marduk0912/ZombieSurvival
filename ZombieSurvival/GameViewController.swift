//
//  GameViewController.swift
//  ZombieSurvival
//
//  Created by Fernando on 29/05/2020.
//  Copyright © 2020 Fernando Salvador. All rights reserved.
//
// 

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sview = view as! SKView
            
        let scene = MainMenu(size: CGSize(width: 2048, height: 1024))
        scene.scaleMode = .aspectFill
        sview.presentScene(scene)
            
          /*  // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene1.loadGame() ?? SKScene(fileNamed: "GameScene1"){
            
                // Set the scale mode to scale to fit the window
                
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            }*/
        sview.ignoresSiblingOrder = true
            
        sview.showsFPS = true
        sview.showsNodeCount = true
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
