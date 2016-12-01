//
//  EnemyBullet.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit

class EnemyBullet: Bullet {
    
    override func setup() {
        super.setup()
        self.sprite.fillColor = SKColor.red
        self.physicsBody?.categoryBitMask = MiniGame02CategoryBitMasks.enemyBullet.rawValue
        self.physicsBody?.contactTestBitMask = MiniGame02CategoryBitMasks.player.rawValue
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        
        let otherBody = self.physicsBody == contact.bodyA ? contact.bodyB : contact.bodyA
        
        if otherBody.categoryBitMask & MiniGame02CategoryBitMasks.player.rawValue > 0 {
            self.removeFromParent()
        }
    }
}
