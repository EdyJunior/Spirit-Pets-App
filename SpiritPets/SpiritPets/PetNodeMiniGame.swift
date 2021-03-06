//
//  MiniGame01Scene.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/28/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol PetNodeMiniGameDelegate {
    func didTapPetNode(petNode: PetNodeMiniGame)
}

class PetNodeMiniGame : SKNode {
    
    var type: PetType
    
    var sprite: SKSpriteNode
    
    var delegate: PetNodeMiniGameDelegate?
    
    init(withType type: PetType, andTexture texture: SKTexture) {
        
        self.type = type
        
        self.sprite = SKSpriteNode(texture: PetNodeMiniGame.randomPetTextureOfType(type: type))
        
        super.init()
        
        self.isUserInteractionEnabled = true
        self.sprite.zPosition = -1
        self.addChild(self.sprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.didTapPetNode(petNode: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PetNodeMiniGame {
    
    static let textures = (light: [#imageLiteral(resourceName: "Parlepus")],
                           
                           dark: [#imageLiteral(resourceName: "Pardaemon")])
    
    static func randomPetOfType(type: PetType) -> PetNodeMiniGame {
        return PetNodeMiniGame(withType: type, andTexture: self.randomPetTextureOfType(type: type))
        
    }
    
    static func randomPetTextureOfType(type: PetType) -> SKTexture {
        let random = GKRandomSource()
        
        switch type {
        case .light:
            return SKTexture(image: self.textures.light[random.nextInt(upperBound: self.textures.light.count)] )
        case .dark:
            return SKTexture(image: self.textures.dark[random.nextInt(upperBound: self.textures.dark.count)] )
        }
    }
}
