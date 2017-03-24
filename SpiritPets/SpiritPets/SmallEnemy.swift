//
//  SmallEnemy.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit
import GameplayKit

class SmallEnemy: SKSpriteNode, Enemy {
    
    var life: Int = 2
    var value: Int = 1
    
    func setup() {
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: 50, height: 50))
        self.setPhysicsBody()
        
        if (PetManager.sharedInstance.petChoosed.type == .light) {
            self.texture = SKTexture(image: #imageLiteral(resourceName: "Pardaemon"))
        } else {
            self.texture = SKTexture(image: #imageLiteral(resourceName: "Parlepus"))
        }
        
        self.size = CGSize.init(width: 60, height: 60)
    }
    
    class func instantiate(inScene scene: SKScene) -> SKNode {
        
        let smallEnemy = SmallEnemy()
        smallEnemy.setup()
        
        smallEnemy.position.x = CGFloat(GKRandomSource().nextInt(upperBound: Int(scene.size.width) - 120)) + 60
        smallEnemy.position.y = scene.size.height + 60
        
        let moveAction = SKAction.moveBy(x: 0, y: -1000, duration: 10)
        let removeAction = SKAction.removeFromParent()
        
        smallEnemy.run(SKAction.sequence([moveAction, removeAction]))
        
        return smallEnemy
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
