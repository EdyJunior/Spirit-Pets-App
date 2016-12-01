//
//  Bullet.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit

class Bullet: SKNode, ContactListener {
    
    var sprite: SKShapeNode!
    
    func setup() {
        
        self.sprite = SKShapeNode(circleOfRadius: 5)
        self.sprite.fillColor = SKColor.blue
        self.addChild(sprite)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = MiniGame02CategoryBitMasks.bullet.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = MiniGame02ContactTestBitMasks.enemy.rawValue | MiniGame02ContactTestBitMasks.player.rawValue
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    
}
