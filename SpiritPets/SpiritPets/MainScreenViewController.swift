//
//  MainScreenViewController.swift
//  SpiritPets
//
//  Created by padrao on 01/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var xperienceLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var backgroundLabel: UILabel!
    
    @IBOutlet weak var petImageView: UIImageView!
    
    @IBOutlet weak var popupImageView: UIImageView!
    
    var pet: PetChoosed!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let uiEdgeInsets = UIEdgeInsets(top: CGFloat(20), left: CGFloat(20), bottom: CGFloat(20), right: CGFloat(20))
        
        xperienceLabel.layer.borderColor = UIColor.white.cgColor
        xperienceLabel.layer.borderWidth = 2
        xperienceLabel.layer.cornerRadius = 10
        xperienceLabel.text = "XP: 79/120"
        
        for btn in buttons{
            btn.imageEdgeInsets = uiEdgeInsets
        }
        
        petImageView.image = pet.frontImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        backgroundLabel.clipsToBounds = true
        backgroundLabel.frame.size.width = 150
        //backgroundLabel.layer.cornerRadius = backgroundLabel.frame.width / 2
        backgroundLabel.layer.cornerRadius = 10
        
        levelLabel.layer.cornerRadius = levelLabel.frame.width / 2
        levelLabel.layer.borderColor = UIColor.white.cgColor
        levelLabel.layer.borderWidth = 2
        levelLabel.text = "LV:\n12"
        
        for btn in buttons{
            print("btn width \(btn.frame.width) height \(btn.frame.height)")
            btn.layer.cornerRadius = btn.frame.width / 2
        }
    }
    
    @IBAction func onButtonTap(_ sender: UIButton) {
        
    }
    
    
    @IBAction func onLevelLabelTap(_ sender: UITapGestureRecognizer){
        let statusViewController = PetStatusViewController()
        statusViewController.pet = self.pet
        self.present(statusViewController, animated: true, completion: nil)
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
