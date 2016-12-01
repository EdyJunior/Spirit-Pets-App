//
//  MiniGameViewController.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/29/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import SpriteKit

class MiniGameViewController: UIViewController {
    
    var numberScene: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadScene()
        
    }
    
    func chooseScene() -> SKScene {
        var chosenScene: SKScene? = nil
        switch numberScene! {
        case 1:
            chosenScene = MiniGame01Scene(size: UIScreen.main.bounds.size)
        case 2:
            
            chosenScene = MiniGame02Scene(size: UIScreen.main.bounds.size)
        default:
            print("This MiniGame does not exist.")
            break
        }
        return chosenScene!
    }
    
    func loadScene() {
        //let scene = chooseScene()
        let scene = MiniGame02Scene(size: UIScreen.main.bounds.size)
        
        scene.scaleMode = .aspectFill
        
        let skView = SKView(frame: self.view.frame)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        self.view.addSubview(skView)
        
        skView.presentScene(scene)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

