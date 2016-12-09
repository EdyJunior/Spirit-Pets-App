//
//  MainScreenViewController.swift
//  SpiritPets
//
//  Created by padrao on 01/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController, DisableButtonsProtocol {

    @IBOutlet weak var xperienceLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var popupImageView: UIImageView!
    
    @IBOutlet weak var feedBtn: CustomBtn!
    @IBOutlet weak var exerciseBtn: CustomBtn!
    @IBOutlet weak var playBtn: CustomBtn!
    @IBOutlet weak var battleBtn: CustomBtn!
    @IBOutlet weak var sleepBtn: CustomBtn!
    
    var pet: PetChoosed!
    var xpReceived = 0
    var feedPoints = 0
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        xperienceLabel.layer.borderColor = UIColor.white.cgColor
        xperienceLabel.layer.borderWidth = 2
        xperienceLabel.layer.cornerRadius = 10
        xperienceLabel.text = "XP: 79/120"
        pet.disableDelegate = self
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

    @IBAction func onLevelLabelTap(_ sender: UITapGestureRecognizer) {

    }

    func changeEnabled(buttons: [UIButton], to: Bool) {

        for btn in buttons {
            btn.isEnabled = to
        }
    }

    // MARK: Buttons' actions

    @IBAction func feed(_ sender: CustomBtn) {

        if !pet.isEating {
            pet.tryFeed(duration: 60)
            feedPoints = 10
        }
    }
    
    @IBAction func sleepOrWakeUp(_ sender: CustomBtn) {
        
        if !pet.isSleeping {
            pet.sleep()
        } else {
            print("ACORDOU")
            pet.wakeUp()
        }
    }
    
    @IBAction func exercise(_ sender: CustomBtn) {
        
        if !pet.isExercising {
            xpReceived = pet.tryExercise(typeOfExercise: Exercise(cost: 40, gain: 30, time: 3600))
            print("XP = \(pet.battleAtt.xp)")
        }
    }
    
    @IBAction func play(_ sender: CustomBtn) {
        
    }
    
    @IBAction func achievementsBtn(_ sender: CustomBtn) {
        
    }
    
    @IBAction func battle(_ sender: CustomBtn) {
        
    }
    
    // MARK: DisableButtonsProtocol delegate
    
    func enableBySleeping() {
        
        print("Ativou pra acordar")
        if !pet.isEating {
            changeEnabled(buttons: [feedBtn], to: true)
        }
        if !pet.isExercising {
            changeEnabled(buttons: [exerciseBtn], to: true)
        }
        sleepBtn.setImage(#imageLiteral(resourceName: "zzz"), for: .normal)
    }
    
    func disableBySleeping() {
        
        print("DesAtivou pra durmir")
        changeEnabled(buttons: [feedBtn, exerciseBtn], to: false)
        sleepBtn.setImage(#imageLiteral(resourceName: "sun"), for: .normal)
    }

    func enableByFeeding() {

        print("Ativou pra parar de comer")
        pet.feedUp(lunch: feedPoints)
        changeEnabled(buttons: [feedBtn], to: true)
        if !pet.isExercising {
            changeEnabled(buttons: [sleepBtn], to: true)
        }
    }

    func disableByFeeding() {

        print("DesAtivou pra comer")
        changeEnabled(buttons: [feedBtn, sleepBtn], to: false)
    }

    func enableByExercising() {

        print("Ativou pra descansar")
        pet.xpUp(xp: xpReceived)
        print("XP += \(xpReceived)")
        changeEnabled(buttons: [exerciseBtn], to: true)
        if !pet.isEating {
            changeEnabled(buttons: [sleepBtn], to: true)
        }
    }

    func disableByExercising() {

        print("DesAtivou pra exercitar")
        changeEnabled(buttons: [exerciseBtn, sleepBtn], to: false)
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
