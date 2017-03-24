//
//  MiniGame02Player.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit

class MiniGame02Player: SKSpriteNode, ContactListener {
    
    let velocity = 1000.0
    var invulnerable = false
    
    func setup() {
        
        if (PetManager.sharedInstance.petChoosed.type == .light) {
            self.texture = SKTexture(image: #imageLiteral(resourceName: "Parlepus"))
        } else {
            self.texture = SKTexture(image: #imageLiteral(resourceName: "Pardaemon"))
        }
        
        self.size = CGSize.init(width: 100, height: 100)
        
        self.setPhysicsBody()
        self.startShooting()
        
    }
    
    private func setPhysicsBody() {
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: 60, height: 60))
        self.physicsBody?.affectedByGravity = true
        
        self.physicsBody?.categoryBitMask = MiniGame02CategoryBitMasks.player.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = MiniGame02ContactTestBitMasks.enemy.rawValue
    }
    
    func setConstraints(in scene: SKScene) {
        
        let width = self.size.width
        let height = self.size.height
        
        let xRange = SKRange(lowerLimit: width / 2, upperLimit: scene.size.width - width / 2)
        let yRange = SKRange(lowerLimit: height / 2, upperLimit: scene.size.height - height / 2)
        
        let constraint = SKConstraint.positionX(xRange, y: yRange)
        
        self.constraints = [constraint]
        
    }
    
    private func startShooting() {
        
        let shoot = SKAction.run {
            let bullet = FriendlyBullet()
            bullet.setup()
            bullet.position = self.position
            self.scene?.addChild(bullet)
            
            let move = SKAction.moveBy(x: 0, y: 1000, duration: 1)
            let remove = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([move, remove]))
        }
        let delay = SKAction.wait(forDuration: 0.5)
        
        self.run(SKAction.repeatForever(SKAction.sequence([shoot, delay])), withKey: "shoot")
    }
    
    private func stopShooting() {
        
        self.removeAction(forKey: "shoot")
    }
    
    // MARK: contact test
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let otherBody = self.physicsBody == contact.bodyA ? contact.bodyB : contact.bodyA
        
        if otherBody.categoryBitMask & (MiniGame02CategoryBitMasks.enemy.rawValue | MiniGame02CategoryBitMasks.enemyBullet.rawValue) > 0 {
            if(!invulnerable) {
                MiniGame02Manager.instance.loseLife()
                self.die()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    // Plater fades out and then becomes invulnerable for 5 seconds
    private func die() {
        
        self.invulnerable = true
        self.stopShooting()
        
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let startInvulnerable = SKAction.run {
            self.alpha = 0.5;
            self.position = CGPoint.init(x: self.scene!.size.width / 2, y: self.scene!.size.height * 0.1)
            self.startShooting()
        }
        let delay = SKAction.wait(forDuration: 5.0)
        let endInvulnerable = SKAction.run {
            self.invulnerable = false
            self.alpha = 1.0
        }
        
        let sequence = SKAction.sequence([fadeOut, startInvulnerable, delay, endInvulnerable])
        
        self.run(sequence)
    }
    
}
