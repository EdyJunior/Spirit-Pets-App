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

        let petData = defaults.data(forKey: "petDict")
        pet = NSKeyedUnarchiver.unarchiveObject(with: petData!) as! PetChoosed!
        
        xperienceLabel.layer.borderColor = UIColor.white.cgColor
        xperienceLabel.layer.borderWidth = 2
        xperienceLabel.layer.cornerRadius = 10
        xperienceLabel.text = "XP: \(pet.battleAtt.xp)/\(pet.baseBattleAtt.xp * pet.battleAtt.lv)"
        pet.disableDelegate = self
        petImageView.image = pet.frontImage
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateXpLabel),name: NSNotification.Name(rawValue: "UpdateStatusNotification"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        backgroundLabel.clipsToBounds = true
        backgroundLabel.frame.size.width = CGFloat(pet.battleAtt.xp / pet.baseBattleAtt.xp * pet.battleAtt.lv)
        backgroundLabel.layer.cornerRadius = 10

        levelLabel.layer.cornerRadius = levelLabel.frame.width / 2
        levelLabel.layer.borderColor = UIColor.white.cgColor
        levelLabel.layer.borderWidth = 2
        levelLabel.text = "LV:\n\(pet.battleAtt.lv!)"
    }
    
    func updateXpLabel(){
        
        let xp = CGFloat(pet.battleAtt.xp)
        let xpMax = CGFloat( pet.baseBattleAtt.xp * pet.battleAtt.lv )
        backgroundLabel.frame.size.width = ( xp / xpMax) * xperienceLabel.frame.width
        print((xp / xpMax) * xperienceLabel.frame.width)
        xperienceLabel.text = "XP: \(Int(xp))/\(Int(xpMax))"
        
    }
    
    @IBAction func onLevelLabelTap(_ sender: UITapGestureRecognizer){
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let statusViewController = storyBoard.instantiateViewController(withIdentifier: "statusPet") as! PetStatusViewController
        statusViewController.pet = self.pet
        self.show(statusViewController, sender: nil)
    }
    
    func changeEnabled(buttons: [UIButton], to: Bool) {
        
        for btn in buttons {
            btn.isEnabled = to
        }
    }
    
    // MARK: Buttons' actions
    
    @IBAction func feed(_ sender: CustomBtn) {
        
        if !pet.isEating {
            pet.tryFeed(duration: 5)
            feedPoints = 20
        }
    }
    
    @IBAction func sleepOrWakeUp(_ sender: CustomBtn) {
        
        if !pet.isSleeping {
            pet.trySleep()
        } else {
            print("ACORDOU")
            pet.wakeUp()
        }
        //print("SleepOrWake: dormindo = \(pet.isSleeping)")
    }
    
    @IBAction func exercise(_ sender: CustomBtn) {
        
        if !pet.isExercising {
            xpReceived = pet.tryExercise(typeOfExercise: Exercise(cost: 10, gain: 10))
            print("XP = \(pet.battleAtt.xp)")
        }
    }
    
    @IBAction func play(_ sender: CustomBtn) {
//        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let navigationMiniGames = mainStoryboard.instantiateViewController(withIdentifier: "navigationMiniGames")
//        self.present(navigationMiniGames, animated: true, completion: nil)
    }
    
    @IBAction func achievementsBtn(_ sender: CustomBtn) {
        
    }
    
    @IBAction func battle(_ sender: CustomBtn) {
        
    }
    
    // MARK: DisableButtonsProtocol delegate
    
    func enableBySleeping() {
        
        print("Ativou pra acordar")
        changeEnabled(buttons: [feedBtn, playBtn, battleBtn, exerciseBtn], to: true)
        sleepBtn.setImage(#imageLiteral(resourceName: "zzz"), for: .normal)
    }
    
    func disableBySleeping() {
        
        print("DesAtivou pra durmir")
        changeEnabled(buttons: [feedBtn, playBtn, battleBtn, exerciseBtn], to: false)
        sleepBtn.setImage(#imageLiteral(resourceName: "sun"), for: .normal)
    }

    func enableByFeeding() {
        print("Ativou pra parar de comer")
        pet.feedUp(lunch: feedPoints)
        changeEnabled(buttons: [feedBtn, playBtn, battleBtn, exerciseBtn, sleepBtn], to: true)
    }
    
    func disableByFeeding() {
        print("DesAtivou pra comer")
        changeEnabled(buttons: [feedBtn, playBtn, battleBtn, exerciseBtn, sleepBtn], to: false)
    }
    
    func enableByExercising() {
        
        print("Ativou pra descansar")
        pet.xpUp(xp: xpReceived)
        print("XP += \(xpReceived)")
        changeEnabled(buttons: [feedBtn, playBtn, battleBtn, exerciseBtn, sleepBtn], to: true)
    }
    
    func disableByExercising() {
        print("DesAtivou pra exercitar")
        changeEnabled(buttons: [feedBtn, playBtn, battleBtn, exerciseBtn, sleepBtn], to: false)
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
