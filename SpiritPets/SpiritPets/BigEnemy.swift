//
//  BigEnemy.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit
import GameplayKit

class BigEnemy: SKSpriteNode, Enemy {
    
    var life: Int = 8
    var value: Int = 3
    
    func setup() {
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: 70, height: 70))
        self.setPhysicsBody()
        
        self.texture = SKTexture(image: #imageLiteral(resourceName: "Dark_Pet_One_00"))
        self.size = CGSize.init(width: 80, height: 80)
    }
    
    class func instantiate(inScene scene: SKScene) -> SKNode {
        
        let bigEnemy = BigEnemy()
        bigEnemy.setup()
        
        bigEnemy.position.x = CGFloat(GKRandomSource().nextInt(upperBound: Int(scene.size.width) - 120)) + 60
        bigEnemy.position.y = scene.size.height + 60
        
        let moveAction = SKAction.moveBy(x: 0, y: -100, duration: 1)
        let shootAction = SKAction.run { bigEnemy.shoot() }
        let delayAction = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([shootAction, delayAction])
        
        bigEnemy.run(SKAction.sequence([moveAction, SKAction.repeatForever(sequence)]))
        bigEnemy.run(shootAction)
        
        return bigEnemy
    }
    
    private func shoot() {
        
        if let scene = self.scene as? MiniGame02Scene {
            
            let shoot = SKAction.run {
                let bullet = EnemyBullet()
                bullet.setup()
                bullet.position = self.position
                self.scene?.addChild(bullet)
                
                let move = SKAction.move(to: scene.player.position, duration: 1)
                let grow = SKAction.scale(by: 2, duration: 0.5)
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let end = SKAction.group([grow, fadeOut])
                let remove = SKAction.removeFromParent()
                bullet.run(SKAction.sequence([move, end, remove]))
            }
            self.run(shoot)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let otherBody = self.physicsBody == contact.bodyA ? contact.bodyB : contact.bodyA
        
        if otherBody.categoryBitMask & MiniGame02CategoryBitMasks.friendlyBullet.rawValue > 0 {
            
            self.life -= 1
            
            if self.life == 0 {
                
                self.physicsBody?.categoryBitMask = 0
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                self.removeAllActions()
                self.run(fadeOut, completion: {
                    self.removeFromParent()
                })
                MiniGame02Manager.instance.increaseScore(by: self.value)
            }
        }
    }
    
}
