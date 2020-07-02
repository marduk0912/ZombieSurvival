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
    let zombieSpeed: CGFloat = 80.0
    var cantidadCorazones: [SKNode] = []
    var nodosLeft: Int = 0
    var lastUpdatedTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let playerPixelPerSecond: CGFloat = 200.0
    var velocityPlayer = CGPoint.zero
    var level = GameScene1.level+1
    var loseLevel = Int()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        player = childNode(withName: "player") as! SKSpriteNode
        corazon = childNode(withName: "corazon") as! SKSpriteNode
        camera = (childNode(withName: "camera") as! SKCameraNode)
        for child in self.children{
                   if child.name == "zombie"{
                       if let child = child as? SKSpriteNode{
                           zombies.append(child)
                       }
                   }
               }
        if let loseLevel = userData?.object(forKey: "loseLevel") as? Int {
        self.loseLevel = loseLevel }
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didMove(to view: SKView) {
        
        saveGame()
        physicsWorld.contactDelegate = self
        player.isPaused = true
        player = childNode(withName: "player") as! SKSpriteNode
        corazon = childNode(withName: "corazon") as! SKSpriteNode
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
       self.isPaused = false
       player.isPaused = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       let touch = touches.first! as UITouch
       let location = touch.location(in: self)
       sceneTouched(touchLocation: location)
       
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdatedTime > 0 {
            dt = currentTime - lastUpdatedTime
        }else{
            dt = 0
        }
        lastUpdatedTime = currentTime
        
        if (player.position - lastTouchLocation).length() < playerPixelPerSecond * CGFloat(dt) {
            velocityPlayer = CGPoint.zero
            player.isPaused = true
        }else {
             moveSprite(sprite: player, velocity: velocityPlayer)
        }
        rotatePlayer(sprite: player, direction: velocityPlayer)
        updateZombie()
        updateCamera()
        cantidadCorazones = self["corazon"]
        nodosLeft = cantidadCorazones.count
        newScene()
    }
    
    
    func moveSprite(sprite:SKSpriteNode, velocity:CGPoint){
        
        // Espacio es igual a Velocidad por Tiempo
        let cantidad = velocity * CGFloat(dt)
        sprite.position += cantidad
    }
    
    func playerToLocation(location: CGPoint) {
        
        //  Cantidad de movimiento que debemos darle al player para llegar donde hemos tocado
        let offset = location - player.position
        
        
        // Vector unitario de movimiento
        let direccion = offset.normalized()
        velocityPlayer = direccion * playerPixelPerSecond
    }
    
    func sceneTouched(touchLocation: CGPoint){
        
        lastTouchLocation = touchLocation
        playerToLocation(location: touchLocation)
    }
    
    
    func rotatePlayer(sprite: SKSpriteNode, direction: CGPoint){
        
        
        let angle = atan2(direction.y, direction.x)
        let rotationSprite = SKAction.rotate(toAngle: angle + CGFloat(Double.pi * 0.5), duration: 0)
        sprite.run(rotationSprite)
        
       
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
      let loseScene = LoseScene(size: size, lose: lose, lvl: loseLevel)
      let transition = SKTransition.push(with: .down, duration: 1.0)
      view?.presentScene(loseScene, transition: transition)
    }
    
    func youWin(_ win: Bool) {
      let winScene = WinScene(size: size, win: win, lvl: loseLevel+1)
      let transition = SKTransition.push(with: .down, duration: 1.0)
      view?.presentScene(winScene, transition: transition)
    }
    
    func newScene(){
        if nodosLeft == 0 {
            youWin(true)
        }
    }
    
    
}

extension GameScene2{
    @objc func applicationDidBecomeAvctive(){
        self.isPaused = true
        print("* applicationDidBecomeActive")
    }
    @objc func applicationWillResignActive(){
        self.isPaused = true
        print("* applicationWillResignActive")
    }
    @objc func applicationDidEnterBackground(){
        self.isPaused = true
        print("* applicationDidEnterBackground")
    }
   
    
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeAvctive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
}

extension GameScene2{
    
    func saveGame(){
        //  Recupera el directorio de la Biblioteca de la aplicación interactuando con el sistema de archivos usando el FileManager
        let fileManager = FileManager.default
        guard let directory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first
            else{return}
        // Configura la URL del directorio para el nuevo archivo
        let saveURL = directory.appendingPathComponent("SavedGames")
        // La creación de directorios puede fallar por varias razones. Adjuntando esto en un intento ... catch le permite capturar y mostrar cualquier error que ocurra. Esto no fallará si el directorio ya existe.
        do{
            try fileManager.createDirectory(atPath: saveURL.path, withIntermediateDirectories: true, attributes: nil)
        }catch let error as NSError{
            fatalError("Failed to create directory: \(error.debugDescription)")
        }
        // Luego configura la ruta final para el nuevo archivo. Imprimir el nombre del archivo es útil para que luego pueda ubicarlo en el sistema de archivos.
        let fileURL = saveURL.appendingPathComponent("saved-game")
        print("* saving: \(fileURL.path)")
        // Finalmente, archivas la escena en el archivo. NSKeyedArchiver comienza en el nivel de escena y serializa cada nodo en el gráfico de objetos de escena.
        do{
        let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        try data.write(to: fileURL)
        }catch{print("Couldn't write file")}
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(player, forKey: "player")
        coder.encode(zombies, forKey: "zombies")
        coder.encode(corazon, forKey: "corazon")
        super.encode(with: coder)
    }
   
}


