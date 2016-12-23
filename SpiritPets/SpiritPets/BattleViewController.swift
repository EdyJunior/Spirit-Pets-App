//
//  BattleViewController.swift
//  SpiritPets
//
//  Created by padrao on 13/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import SpriteKit

class BattleViewController: UIViewController {
    
    var dictionary: [String: AnyObject]!
    var opponentImageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = BattleScene(size: view.bounds.size)
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        if let oldScene = skView.scene{
            oldScene.removeFromParent()
        }
        
        scene.dictionary = self.dictionary
        //scene.opponentPetImageName = self.opponentImageName
        //print(scene.dictionary)
        scene.parentVC = self
        skView.presentScene(scene)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //GameStateDelegate
    func onFinishGame(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
