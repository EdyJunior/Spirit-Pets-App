//
//  PetAnimationScene.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 12/8/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit
import WatchKit

class PetAnimationScene: SKScene {
    
    override func sceneDidLoad() {
        setup()
    }
    
    func setup() {
        loadBackground()
    }
    
    func loadBackground() {
        let background = SKSpriteNode(imageNamed: "SpriteKitFamiliaPeq")
        addChild(background)
    }
}
