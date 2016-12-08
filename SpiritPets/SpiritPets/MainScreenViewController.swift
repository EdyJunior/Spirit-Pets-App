//
//  MainScreenViewController.swift
//  SpiritPets
//
//  Created by padrao on 01/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var xperienceLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var popupImageView: UIImageView!
    
    @IBOutlet weak var feedBtn: CustomBtn!
    @IBOutlet weak var exerciseBtn: CustomBtn!
    @IBOutlet weak var playBtn: CustomBtn!
    @IBOutlet weak var battleBtn: CustomBtn!
    
    var pet: PetChoosed!

    override func viewDidLoad() {

        super.viewDidLoad()

        xperienceLabel.layer.borderColor = UIColor.white.cgColor
        xperienceLabel.layer.borderWidth = 2
        xperienceLabel.layer.cornerRadius = 10
        xperienceLabel.text = "XP: 79/120"

        petImageView.image = pet.frontImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        backgroundLabel.clipsToBounds = true
        backgroundLabel.frame.size.width = 150
        backgroundLabel.layer.cornerRadius = 10

        levelLabel.layer.cornerRadius = levelLabel.frame.width / 2
        levelLabel.layer.borderColor = UIColor.white.cgColor
        levelLabel.layer.borderWidth = 2
        levelLabel.text = "LV:\n12"
    }
    
    @IBAction func onButtonTap(_ sender: UIButton) {
        
    }
    
    @IBAction func onLevelLabelTap(_ sender: UITapGestureRecognizer){
        let bergStoryBoard = UIStoryboard.init(name: "BergStoryboard", bundle: nil)
        let statusViewController = bergStoryBoard.instantiateViewController(withIdentifier: "statusPet") as! PetStatusViewController
        statusViewController.pet = self.pet
        self.show(statusViewController, sender: nil)
    }
    
    func changeEnabled(buttons: [UIButton], to: Bool) {
        
        for btn in buttons {
            btn.isEnabled = to
        }
    }
    
    // MARK: - Buttons' actions
    
    @IBAction func feed(_ sender: CustomBtn) {
        
        if !pet.isSleeping {
            pet.feed(lunch: 20)
        }
    }
    
    @IBAction func sleepBtn(_ sender: CustomBtn) {
        
        pet.isSleeping = !pet.isSleeping
        if !pet.isSleeping {
            sender.setImage(#imageLiteral(resourceName: "zzz"), for: .normal)
            changeEnabled(buttons: [feedBtn, playBtn, battleBtn, exerciseBtn], to: true)
        } else {
            sender.setImage(#imageLiteral(resourceName: "sun"), for: .normal)
            changeEnabled(buttons: [feedBtn, playBtn, battleBtn, exerciseBtn], to: false)
        }
        print("LOLOLO = \(pet.isSleeping)")
        
        
    }
    
    @IBAction func exercise(_ sender: CustomBtn) {
        
        if !pet.isSleeping {
            pet.xpUp(xp: 20)
        }
    }
    
    @IBAction func play(_ sender: CustomBtn) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let navigationMiniGames = mainStoryboard.instantiateViewController(withIdentifier: "navigationMiniGames")
        self.present(navigationMiniGames, animated: true, completion: nil)
    }
    
    @IBAction func achievementsBtn(_ sender: CustomBtn) {
        
    }
    
    @IBAction func battle(_ sender: CustomBtn) {
        
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
