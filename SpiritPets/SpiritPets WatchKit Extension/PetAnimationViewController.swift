//
//  PetAnimationViewController.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 12/7/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import Foundation
import SpriteKit
import WatchKit

class PetAnimationViewController: WKInterfaceController {
    
    @IBOutlet var skView: WKInterfaceSKScene!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
        let scene = PetAnimationScene(fileNamed: "PetAnimationScene")
        scene?.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
