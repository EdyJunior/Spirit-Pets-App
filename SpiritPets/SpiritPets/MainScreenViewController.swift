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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels),name: NSNotification.Name(rawValue: "UpdateStatusNotification"), object: nil)
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
        //TODO: Transformar lunch em inteiro, já que o tempo gasto pra comer é o número de pontos ganhos em fed
        if !pet.isEating {
            lunch = Lunch(gain: 10, time: 10)//60
            PetManager.sharedInstance.feed(with: lunch)
        }
    }
    
    @IBAction func sleepOrWakeUp(_ sender: CustomBtn) {
        
        if !pet.isSleeping {
            pet.sleep()
        } else {
            pet.wakeUp()
        }
    }
    
    @IBAction func exercise(_ sender: CustomBtn) {
        
        if !pet.isExercising {
            exercise = Exercise(cost: 10, gain: 30, time: 30)//3600)
            PetManager.sharedInstance.exercise(typeOfExercise: exercise)
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

        //pet.feedUp(lunch: lunch.gain)
        lunch = Lunch(gain: 0, time: 0)
        changeEnabled(buttons: [feedBtn], to: true)
        if !pet.isExercising {
            changeEnabled(buttons: [sleepBtn], to: true)
        }
    }

    func disableByFeeding() {
        changeEnabled(buttons: [feedBtn, sleepBtn], to: false)
    }

    func enableByExercising() {

//        pet.xpUp(xp: exercise.gain)
        exercise = Exercise(cost: 0, gain: 0, time: 0)
        updateLabels()
        changeEnabled(buttons: [exerciseBtn], to: true)
        if !pet.isEating {
            changeEnabled(buttons: [sleepBtn], to: true)
        }
    }

    func disableByExercising() {
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
    
    func saveState() {
        
        defaults.set(PetManager.sharedInstance.feedController.interval, forKey: "feedInterval")
        defaults.set(PetManager.sharedInstance.sleepController.interval, forKey: "sleepInterval")
        defaults.set(PetManager.sharedInstance.exerciseController.interval, forKey: "exerciseInterval")
    }
    
    // MARK: - SaveStatusDelegate
    
    func save() {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: pet)
        defaults.set(data, forKey: "petDict")
        let exerciseDict: [String : Any] = ["cost" : exercise.cost,
                                            "gain" : exercise.gain,
                                            "time" : exercise.time]
        defaults.set(exerciseDict, forKey: "exerciseDict")
        saveState()
    }

    func load(after time: TimeInterval) {
        
        pet = PetManager.sharedInstance.petChoosed
        var backTime = appDelegate.saveDelegate!.backgroundTime
        PetManager.sharedInstance.feedController.timer?.invalidate()
        PetManager.sharedInstance.exerciseController.timer?.invalidate()
        
        //Eating in background
        
        if pet.isEating {
            var feedInterval = defaults.object(forKey: "feedInterval") as! TimeInterval
            
            if feedInterval > backTime {
                pet.growthAtt.fed! += Int(backTime)
                feedInterval -= backTime
                lunch = Lunch(gain: 10, time: feedInterval)//60
                PetManager.sharedInstance.feed(with: lunch)
            } else {
                pet.growthAtt.fed! += Int(feedInterval)
                pet.isEating = false
                if pet.growthAtt.fed > 100 {
                    pet.growthAtt.fed = 100
                }
                backTime -= feedInterval
                pet.growthAtt.fed! -= (hungerHighRate * Int(backTime / updateInterval))
            }
        } else {
            let rate = (pet.isSleeping ? hungerLowRate : hungerHighRate)
            pet.growthAtt.fed! -= (rate * Int(backTime / updateInterval))
        }
        
        //Exercising in background
        
        if pet.isExercising {
            var exerciseInterval = defaults.object(forKey: "exerciseInterval") as! TimeInterval
            let exerciseDict = defaults.object(forKey: "exerciseDict") as! [String : Any]
            
            exercise = Exercise(cost: exerciseDict["cost"] as! Int,
                                gain: exerciseDict["gain"] as! Int,
                                time: exerciseDict["time"] as! TimeInterval)
            if exerciseInterval > backTime {
                pet.growthAtt.stamina! -= Int(backTime)
                exerciseInterval -= backTime
                let cost = (exercise.cost > Int(backTime) ? exercise.cost - Int(backTime) : 0)
                exercise = Exercise(cost: cost, gain: exercise.gain, time: exerciseInterval)
                PetManager.sharedInstance.exercise(typeOfExercise: exercise)
            } else {
                let cost = (Int(exercise.time - exerciseInterval) >= exercise.cost ? 0 : exercise.cost - Int(exercise.time - exerciseInterval))
                pet.growthAtt.stamina! -= cost
                pet.isExercising = false
                backTime -= exerciseInterval
                pet.growthAtt.stamina! += (staminaLowRate * Int(backTime / updateInterval))
            }
        }
        
        //Languishing in background
        
        if pet.growthAtt.fed < hungerMortalValue || pet.growthAtt.awake < sleepnessMortalValue {
            //TODO: testar os dois menores do que 30, que tb vão regredir
            
            var depletionTime = TimeInterval(hungerMortalValue)
            if pet.growthAtt.fed < hungerMortalValue {
                depletionTime -= TimeInterval(hungerMortalValue)
            } else if pet.growthAtt.awake < sleepnessMortalValue {
                depletionTime -= TimeInterval(sleepnessMortalValue)
            }
            PetManager.sharedInstance.languishInstantaniously(basedOn: depletionTime)
        }
        
        //Sleeping in background
        
        if pet.isSleeping {
            pet.growthAtt.awake! += Int(time / updateInterval)
            if pet.growthAtt.awake > 100 {
                pet.growthAtt.awake! = 100
            }
            print("Soma = \(time / updateInterval)\n")
        }
    }
}
