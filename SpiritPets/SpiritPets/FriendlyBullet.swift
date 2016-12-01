//
//  File.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit

class FriendlyBullet: Bullet {
    
    override func setup() {
        super.setup()
        self.physicsBody?.categoryBitMask = MiniGame02CategoryBitMasks.friendlyBullet.rawValue
        self.physicsBody?.contactTestBitMask = MiniGame02CategoryBitMasks.enemy.rawValue
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        
        let otherBody = self.physicsBody == contact.bodyA ? contact.bodyB : contact.bodyA
        
        if otherBody.categoryBitMask & MiniGame02CategoryBitMasks.enemy.rawValue > 0 {
            self.removeFromParent()
        }
    }
    
}
