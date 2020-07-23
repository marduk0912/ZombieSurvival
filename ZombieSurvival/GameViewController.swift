//
//  GameViewController.swift
//  ZombieSurvival
//
//  Created by Fernando on 29/05/2020.
//  Copyright © 2020 Fernando Salvador. All rights reserved.
//
// id admob interstitial real: ca-app-pub-9116099785246857/1557502059

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    
    @IBOutlet weak var banner: GADBannerView!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sview = view as! SKView
            
        let scene = MainMenu(size: CGSize(width: 2048, height: 1024))
        scene.scaleMode = .aspectFill
        sview.presentScene(scene)
        
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = self
        banner.load(GADRequest())
            
          /*  // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene1.loadGame() ?? SKScene(fileNamed: "GameScene1"){
            
                // Set the scale mode to scale to fit the window
                
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            }*/
        hideAdmodBanner()
        
        self.interstitial =  crateAndLoadInstertitial()
        NotificationCenter.default.addObserver(self, selector: #selector(showIntertitial), name: NSNotification.Name(rawValue: "showIntertitial"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(showAdmodBanner), name: NSNotification.Name(rawValue: "showBanner"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(hideAdmodBanner), name: NSNotification.Name(rawValue: "hideBanner"), object: nil)
        
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
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        URLCache.shared.removeAllCachedResponses()
    }
    
    func crateAndLoadInstertitial() -> GADInterstitial {
        let instertitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        instertitial.delegate = self
        instertitial.load(GADRequest())
        return instertitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitial = crateAndLoadInstertitial()
    }
    
    @objc func showIntertitial() {
        if self.interstitial.isReady{
            self.interstitial.present(fromRootViewController: self)
        }
    }
    
    @objc func showAdmodBanner(){
        self.banner.isHidden = false
    }
    
    @objc func hideAdmodBanner(){
        self.banner.isHidden = true
        
    }
}
