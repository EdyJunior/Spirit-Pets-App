//
//  MiniGame02Scene.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion


protocol ContactListener {
    func didBegin(_ contact: SKPhysicsContact)
    func didEnd(_ contact: SKPhysicsContact)
}


class MiniGame02Scene: SKScene, SKPhysicsContactDelegate, MiniGame02ManagerDelegate {
    
    var player = MiniGame02Player()
    var score: SKLabelNode?
    var lives: SKLabelNode?
    
    var motionManager = CMMotionManager()
    
    var count = 0
    var gameOver = false
    
    override func sceneDidLoad() {
        
        self.count = 0
        
        // Start motion updates
        
        self.motionManager.startGyroUpdates()
        
        // Set gameManager
        
        MiniGame02Manager.instance.delegate = self
        MiniGame02Manager.instance.setup()
        
        // Set physicWorld
        
        self.physicsWorld.gravity = CGVector.zero
        self.physicsWorld.contactDelegate = self
        
        // Set lives and score text
        
        self.lives = SKLabelNode(text: "3")
        self.score = SKLabelNode(text: "0")
        lives?.position = CGPoint.init(x: self.size.width * 0.1, y: self.size.height * 0.9)
        score?.position = CGPoint.init(x: self.size.width * 0.9, y: self.size.height * 0.9)
        self.addChild(score!)
        self.addChild(lives!)
        
        // Set player
        
        player.setup()
        player.setConstraints(in: self)
        player.position = CGPoint.init(x: self.size.width / 2, y: self.size.height * 0.1)
        player.zPosition = 1
        self.addChild(player)
        
        // Set enemy spawn
        
        let spawn = SKAction.run { self.spawnEnemy() }
        let delay = SKAction.wait(forDuration: 1.5)
        
        self.run(SKAction.repeatForever(SKAction.sequence([spawn, delay])))
        
    }
    
    private func spawnEnemy() {
        
        let smallEnemy = SmallEnemy.instantiate(inScene: self)
        self.addChild(smallEnemy)
        
        count += 1
        if count >= 10 {
            let bigEnemy = BigEnemy.instantiate(inScene: self)
            self.addChild(bigEnemy)
            count = 0
        }
    }
    
    //MARK: ContactListener
    
    func didBegin(_ contact: SKPhysicsContact) {
        (contact.bodyA.node as? ContactListener)?.didBegin(contact)
        (contact.bodyB.node as? ContactListener)?.didBegin(contact)
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        (contact.bodyA.node as? ContactListener)?.didEnd(contact)
        (contact.bodyB.node as? ContactListener)?.didEnd(contact)
    }
    
    //MARK: GameManagerDelegate
    
    func updateLives(to lives: Int) {
        self.lives?.text = "\(lives)"
    }
    
    func updateScore(to score: Int) {
        self.score?.text = "\(score)"
    }
    
    func didGameOver() {
        
        self.run(SKAction.wait(forDuration: 1.0), completion: {
            
            self.isPaused = true
            self.gameOver = true
            
            let gameOverLabel = SKLabelNode(text: "GAME OVER")
            gameOverLabel.position = CGPoint.init(x: self.size.width / 2, y: self.size.height / 2)
            
            let restartLabel = SKLabelNode(text: "click anywhere to restart")
            restartLabel.position = CGPoint.init(x: self.size.width / 2, y: self.size.height / 2 - gameOverLabel.frame.size.height * 1.5)
            
            self.addChild(gameOverLabel)
            self.addChild(restartLabel)
        })
    }
    
    //MARK: Restart game
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver {
            
            backToMenu()
        }
    }
    
    func backToMenu() {
        
        self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Movement Update
    
    override func update(_ currentTime: TimeInterval) {
        
        if let data = motionManager.gyroData?.rotationRate {
            
            self.physicsWorld.gravity = CGVector.init(dx: data.y * 3, dy: -data.x * 3)
        }
    }
}
