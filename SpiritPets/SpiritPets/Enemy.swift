//
//  Enemy.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol Enemy: ContactListener {
    
    var life: Int { get set }
    var value: Int { get set }
    
    func setup()
    
    static func instantiate(inScene scene: SKScene) -> SKNode
}

extension Enemy {
    
    func setPhysicsBody() {
        
        if let node = self as? SKNode {
            
            node.physicsBody?.affectedByGravity = false
            
            node.physicsBody?.categoryBitMask = MiniGame02CategoryBitMasks.enemy.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.physicsBody?.contactTestBitMask = MiniGame02ContactTestBitMasks.bullet.rawValue | MiniGame02ContactTestBitMasks.player.rawValue
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
