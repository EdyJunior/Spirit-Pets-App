//
//  MainScreenViewController.swift
//  SpiritPets
//
//  Created by padrao on 01/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController, DisableButtonsProtocol, TimeToTakeCareProtocol, SaveStatusDelegate {

    @IBOutlet weak var xperienceLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UILabel!

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var popupImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!

    @IBOutlet weak var feedBtn: CustomBtn!
    @IBOutlet weak var exerciseBtn: CustomBtn!
    @IBOutlet weak var playBtn: CustomBtn!
    @IBOutlet weak var battleBtn: CustomBtn!
    @IBOutlet weak var sleepBtn: CustomBtn!

    var pet: PetChoosed!
    var exercise = Exercise(cost: 0, gain: 0, time: 0)
    var lunch = Lunch(gain: 0, time: 0)
    
    var messages: Set<UIImage> = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var lastActivate: Date = Date()
    var backgroundTime: TimeInterval = TimeInterval()
    
    override func viewDidLoad() {

        super.viewDidLoad()

        let petData = defaults.data(forKey: "petDict")
        PetManager.sharedInstance.petChoosed = NSKeyedUnarchiver.unarchiveObject(with: petData!) as! PetChoosed!
        pet = PetManager.sharedInstance.petChoosed
        
        xperienceLabel.layer.borderColor = UIColor.white.cgColor
        xperienceLabel.layer.borderWidth = 2
        xperienceLabel.layer.cornerRadius = 10
        xperienceLabel.text = "XP: \(pet.battleAtt.xp!)/\(pet.baseBattleAtt.xp * pet.battleAtt.lv)"
        PetManager.sharedInstance.petChoosed.disableDelegate = self
        pet.careDelegate = self
        appDelegate.saveDelegate = self
        
        petImageView.image = pet.frontImage
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLabels),name: NSNotification.Name(rawValue: "UpdateStatusNotification"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        backgroundLabel.clipsToBounds = true
        backgroundLabel.frame.size.width = CGFloat(pet.battleAtt.xp / pet.baseBattleAtt.xp * pet.battleAtt.lv)
        backgroundLabel.layer.cornerRadius = 10
        
        levelLabel.layer.cornerRadius = levelLabel.frame.width / 2
        levelLabel.layer.borderColor = UIColor.white.cgColor
        levelLabel.layer.borderWidth = 2
        
        updateLabels()
    }
    
    func updateLabels(){
        
        let xp = CGFloat(pet.battleAtt.xp)
        let xpMax = CGFloat( pet.baseBattleAtt.xp * pet.battleAtt.lv )
        backgroundLabel.frame.size.width = ( xp / xpMax) * xperienceLabel.frame.width
        xperienceLabel.text = "XP: \(Int(xp))/\(Int(xpMax))"
        levelLabel.text = "LV:\n\(pet.battleAtt.lv!)"

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
            lunch = Lunch(gain: 70, time: 5)//60
            pet.tryFeed(duration: lunch.time)//60)
        }
    }
    
    @IBAction func sleepOrWakeUp(_ sender: CustomBtn) {
        
        if !pet.isSleeping {
            pet.sleep()
        } else {
            //print("ACORDOU")
            pet.wakeUp()
        }
    }
    
    @IBAction func exercise(_ sender: CustomBtn) {
        
        if !pet.isExercising {
            exercise = Exercise(cost: 40, gain: 30, time: 5)//3600)
            pet.tryExercise(typeOfExercise: exercise)
            //print("XP = \(pet.battleAtt.xp)")
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
        
        //print("Ativou pra acordar")
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

        //print("Ativou pra parar de comer")
        pet.feedUp(lunch: lunch.gain)
        lunch = Lunch(gain: 0, time: 0)
        changeEnabled(buttons: [feedBtn], to: true)
        if !pet.isExercising {
            changeEnabled(buttons: [sleepBtn], to: true)
        }
    }

    func disableByFeeding() {

        //print("DesAtivou pra comer")
        changeEnabled(buttons: [feedBtn, sleepBtn], to: false)
    }

    func enableByExercising() {

        //print("Ativou pra descansar")
        pet.xpUp(xp: exercise.gain)
        exercise = Exercise(cost: 0, gain: 0, time: 0)
        updateLabels()
        //print("XP += \(xpReceived)")
        changeEnabled(buttons: [exerciseBtn], to: true)
        if !pet.isEating {
            changeEnabled(buttons: [sleepBtn], to: true)
        }
    }

    func disableByExercising() {

        //print("DesAtivou pra exercitar")
        changeEnabled(buttons: [exerciseBtn, sleepBtn], to: false)
    }
    
    // MARK: TimeToTakeCareProtocol delegate
    
    func hungerMessage() {
        
        popupImageView.isHidden = false
        messageImageView.isHidden = false
        messages.insert(#imageLiteral(resourceName: "hungry"))
        animateMessages()
    }
    
    func sleepnessMessage() {
        
        popupImageView.isHidden = false
        messageImageView.isHidden = false
        messages.insert(#imageLiteral(resourceName: "sleepy"))
        
        animateMessages()
    }
    
    func tirednessMessage() {
        
        popupImageView.isHidden = false
        messageImageView.isHidden = false
        messages.insert(#imageLiteral(resourceName: "tired"))
        
        animateMessages()
    }
    
    func animateMessages() {
        
        var messageImages: [UIImage] = []
        for image in messages {
            messageImages.append(image)
        }
        messageImageView.stopAnimating()
        messageImageView.animationImages = messageImages
        messageImageView.animationDuration = 3.0
        messageImageView.animationRepeatCount = 0
        messageImageView.startAnimating()
    }
    
    func removeHunger() {
        
        messages.remove(#imageLiteral(resourceName: "hungry"))
        if messages.isEmpty {
            hiddenMessage()
        } else {
            animateMessages()
        }
    }
    
    func removeSleepness() {
        
        messages.remove(#imageLiteral(resourceName: "sleepy"))
        if messages.isEmpty {
            hiddenMessage()
        } else {
            animateMessages()
        }
    }
    
    func removeTiredness() {
        
        messages.remove(#imageLiteral(resourceName: "tired"))
        if messages.isEmpty {
            hiddenMessage()
        } else {
            animateMessages()
        }
    }
    
    func hiddenMessage() {
        
        messageImageView.stopAnimating()
        messageImageView.image = #imageLiteral(resourceName: "happy")
    }
    
    // MARK: - SaveStatusDelegate
    
    func save() {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: pet)
        defaults.set(data, forKey: "petDict")
    }
    
    func load(after time: TimeInterval) {
        
        pet = PetManager.sharedInstance.petChoosed
        if pet.isSleeping {
            pet.growthAtt.awake! += Int(time / sleepInterval)
        }
    }
}
