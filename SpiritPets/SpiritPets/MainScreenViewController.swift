//
//  MainScreenViewController.swift
//  SpiritPets
//
//  Created by padrao on 01/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var exerciceButton: UIButton!
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var achievementButton: UIButton!
    @IBOutlet weak var swordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uiEdgeInsets = UIEdgeInsets(top: CGFloat(20), left: CGFloat(20), bottom: CGFloat(20), right: CGFloat(20))
        
        feedButton.imageEdgeInsets = uiEdgeInsets
        exerciceButton.imageEdgeInsets = uiEdgeInsets
        sleepButton.imageEdgeInsets = uiEdgeInsets
        playButton.imageEdgeInsets = uiEdgeInsets
        achievementButton.imageEdgeInsets = uiEdgeInsets
        swordButton.imageEdgeInsets = uiEdgeInsets
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
