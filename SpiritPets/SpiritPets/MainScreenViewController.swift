//
//  MainScreenViewController.swift
//  SpiritPets
//
//  Created by padrao on 01/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import WatchConnectivity

class MainScreenViewController: UIViewController, DisableButtonsProtocol, TimeToTakeCareProtocol, SaveStatusDelegate, WCSessionDelegate {

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
        startConnectivity()

        let petData = defaults.data(forKey: "petDict")
        PetManager.sharedInstance.petChoosed = NSKeyedUnarchiver.unarchiveObject(with: petData!) as! PetChoosed!
        pet = PetManager.sharedInstance.petChoosed
        
        xperienceLabel.layer.borderColor = UIColor.white.cgColor
        xperienceLabel.layer.borderWidth = 2
        xperienceLabel.layer.cornerRadius = 10
        xperienceLabel.text = "XP: \(pet.battleAtt.xp!)/\(pet.baseBattleAtt.xp * pet.battleAtt.lv)"
        pet.disableDelegate = self
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

    //Enable or disanable buttons passed as parameter based on boolean 'to'
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
            PetManager.sharedInstance.sleep(during: sleepDefaultTime)
        } else {
            PetManager.sharedInstance.wakeUp()
        }
    }
    
    @IBAction func exercise(_ sender: CustomBtn) {
        
        if !pet.isExercising {
            exercise = Exercise(cost: 20, gain: 30, time: 6)//3600)
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
    
    //Enables exercise and feed buttons when pet wake up
    func enableBySleeping() {
        
        if !pet.isEating {
            changeEnabled(buttons: [feedBtn], to: true)
        }
        if !pet.isExercising {
            changeEnabled(buttons: [exerciseBtn], to: true)
        }
        sleepBtn.setImage(#imageLiteral(resourceName: "zzz"), for: .normal)
    }
    
    //Disables feed and exercise buttons when sleep button is pressed
    func disableBySleeping() {
        
        print("DesAtivou pra durmir")
        changeEnabled(buttons: [feedBtn, exerciseBtn], to: false)
        sleepBtn.setImage(#imageLiteral(resourceName: "sun"), for: .normal)
    }

    //Enables feed and sleep (if pet isn't exercising) buttons when pet finish eating
    func enableByFeeding() {

        lunch = Lunch(gain: 0, time: 0)
        changeEnabled(buttons: [feedBtn], to: true)
        if !pet.isExercising {
            changeEnabled(buttons: [sleepBtn], to: true)
        }
    }

    //Disables feed and sleep buttons when feed button is pressed
    func disableByFeeding() {
        changeEnabled(buttons: [feedBtn, sleepBtn], to: false)
    }

    //Enables exercise and sleep (if pet isn't eating) buttons when pet finish exercising
    func enableByExercising() {

        exercise = Exercise(cost: 0, gain: 0, time: 0)
        updateLabels()
        changeEnabled(buttons: [exerciseBtn], to: true)
        if !pet.isEating {
            changeEnabled(buttons: [sleepBtn], to: true)
        }
        if PetManager.sharedInstance.evolve() {
            var Images: [UIImage] = []
            for num in 0...15 {
                Images.append(UIImage(named: "Effect-\(num)")!)
            }
            petImageView.stopAnimating()
            petImageView.animationImages = Images
            petImageView.animationDuration = 3.0
            petImageView.animationRepeatCount = 2
            petImageView.startAnimating()
            
            
            
            petImageView.stopAnimating()
            petImageView.image = pet.frontImage
        }
    }

    //Disables exercise and sleep buttons when exercise button is pressed
    func disableByExercising() {
        changeEnabled(buttons: [exerciseBtn, sleepBtn], to: false)
    }
    
    // MARK: TimeToTakeCareProtocol delegate
    
    //Presents hunger status image in feedback ballon
    func hungerMessage() {
        
        popupImageView.isHidden = false
        messageImageView.isHidden = false
        messages.insert(#imageLiteral(resourceName: "hungry"))
        animateMessages()
    }
    
    //Presents sleep status image in feedback ballon
    func sleepnessMessage() {
        
        popupImageView.isHidden = false
        messageImageView.isHidden = false
        messages.insert(#imageLiteral(resourceName: "sleepy"))
        
        animateMessages()
    }
    
    //Presents tired status image in feedback ballon
    func tirednessMessage() {
        
        popupImageView.isHidden = false
        messageImageView.isHidden = false
        messages.insert(#imageLiteral(resourceName: "tired"))
        
        animateMessages()
    }
    
    //Alternates status images in feedback ballon
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
    
    //Stops present hunger status image in feedback ballon
    func removeHunger() {
        
        messages.remove(#imageLiteral(resourceName: "hungry"))
        if messages.isEmpty {
            hiddenMessage()
        } else {
            animateMessages()
        }
    }
    
    //Stops present sleep status image in feedback ballon
    func removeSleepness() {
        
        messages.remove(#imageLiteral(resourceName: "sleepy"))
        if messages.isEmpty {
            hiddenMessage()
        } else {
            animateMessages()
        }
    }
    
    //Stops present tired status image in feedback ballon
    func removeTiredness() {
        
        messages.remove(#imageLiteral(resourceName: "tired"))
        if messages.isEmpty {
            hiddenMessage()
        } else {
            animateMessages()
        }
    }
    
    //Presents the default status image in feedback ballon
    func hiddenMessage() {
        
        messageImageView.stopAnimating()
        messageImageView.image = #imageLiteral(resourceName: "happy")
    }
    
    //Saves some variables when app enters in background
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
        
        var backTime = appDelegate.saveDelegate!.backgroundTime
        PetManager.sharedInstance.feedController.timer?.invalidate()
        PetManager.sharedInstance.exerciseController.timer?.invalidate()
        var LanguishingByHungerTime: Int = 0
        var LanguishingBySleepnessTime: Int = 0
        
        //Eating in background
        
        if pet.isEating {
            var feedInterval = defaults.object(forKey: "feedInterval") as! TimeInterval
            
            //Pet will keep eating when it come back from background
            if feedInterval > backTime {
                pet.growthAtt.fed! += Int(backTime)
                feedInterval -= backTime
                lunch = Lunch(gain: 10, time: feedInterval)//60
                PetManager.sharedInstance.feed(with: lunch)
            }
            //Pet finished eating while it was in background
            else {
                pet.growthAtt.fed! += Int(feedInterval)
                pet.isEating = false
                backTime -= feedInterval
                if pet.growthAtt.fed! - (hungerHighRate * Int(backTime / updateInterval)) < hungerMortalValue {
                    LanguishingByHungerTime = Int(updateInterval) * (hungerMortalValue - (pet.growthAtt.fed! - (hungerHighRate * Int(backTime / updateInterval))))
                }
                pet.growthAtt.fed! -= (hungerHighRate * Int(backTime / updateInterval))
            }
        }
        //Pet wasn't eating when it entered in background
        else {
            if pet.growthAtt.fed! - (hungerHighRate * Int(backTime / updateInterval)) < hungerMortalValue {
                LanguishingByHungerTime = Int(updateInterval) * (hungerMortalValue - (pet.growthAtt.fed! - (hungerHighRate * Int(backTime / updateInterval))))
            }
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
            let timeExercisingBeforeBackground = exercise.time - exerciseInterval
            var cost: Int = 0
            //Pet will keep exercising when it come back from background
            if exerciseInterval > backTime {
                //The cost of stamina of the exercise wasn't consumed in background
                if exercise.cost >= Int(timeExercisingBeforeBackground + backTime) {
                    pet.growthAtt.stamina! -= Int(backTime)
                    cost = exercise.cost - Int(timeExercisingBeforeBackground + backTime)
                }
                //The cost of stamina of the exercise was consumed in background
                else if exercise.cost > Int(timeExercisingBeforeBackground) {
                    pet.growthAtt.stamina! -= (exercise.cost - Int(timeExercisingBeforeBackground))
                    cost = 0
                }
                exerciseInterval -= backTime
                
                exercise = Exercise(cost: cost, gain: exercise.gain, time: exerciseInterval)
                PetManager.sharedInstance.exercise(typeOfExercise: exercise)
            }
            //Pet finished exercising while it was in background
            else {
                cost = exercise.cost - Int(timeExercisingBeforeBackground)
                pet.growthAtt.stamina! -= cost
                pet.xpUp(xp: exercise.gain)
                pet.isExercising = false
                backTime -= exerciseInterval
                let rate = (pet.isLanguishing ? 0 : staminaLowRate)
                pet.growthAtt.stamina! += (rate * Int(backTime / updateInterval))
            }
        }
        //Pet wasn't exercising when it entered in background
        else {
            let rate = (pet.isLanguishing ? 0 : (pet.isSleeping ? staminaHighRate : staminaLowRate))
            pet.growthAtt.stamina! += (rate * Int(backTime / updateInterval))
        }
        
        //Sleeping in background
        
        if pet.isSleeping {
            var sleepInterval = defaults.object(forKey: "sleepInterval") as! TimeInterval
            
            //Pet will keep sleeping when it come back from background
            if sleepInterval > backTime {
                pet.growthAtt.awake! += sleepnessUpRate * Int(backTime / updateInterval)
                sleepInterval -= backTime
                PetManager.sharedInstance.sleep(during: sleepInterval)
            }
                //Pet finished sleeping while it was in background
            else {
                pet.growthAtt.fed! += sleepnessUpRate * Int(sleepInterval / updateInterval)
                pet.isSleeping = false
                backTime -= sleepInterval
                if pet.growthAtt.awake! - (sleepnessDownRate * Int(backTime / updateInterval)) < sleepnessMortalValue {
                    LanguishingBySleepnessTime = Int(updateInterval) * (sleepnessMortalValue - (pet.growthAtt.awake! - (sleepnessDownRate * Int(backTime / updateInterval))))
                }
                pet.growthAtt.awake! -= (sleepnessDownRate * Int(backTime / updateInterval))
            }
        }
            //Pet wasn't sleeping when it entered in background
        else {
            if pet.growthAtt.awake! - (sleepnessDownRate * Int(backTime / updateInterval)) < sleepnessMortalValue {
                LanguishingBySleepnessTime = Int(updateInterval) * (sleepnessMortalValue - (pet.growthAtt.awake! - (sleepnessDownRate * Int(backTime / updateInterval))))
            }
            pet.growthAtt.awake! -= (sleepnessDownRate * Int(backTime / updateInterval))
        }
        
        //Languishing in background
        
        let languishTime = LanguishingBySleepnessTime > LanguishingByHungerTime ? LanguishingBySleepnessTime : LanguishingByHungerTime
        PetManager.sharedInstance.languishInstantaniously(basedOn: TimeInterval(languishTime))
        
//        if pet.growthAtt.fed < hungerMortalValue || pet.growthAtt.awake < sleepnessMortalValue {
//            //TODO: testar os dois menores do que 30, que tb vão regredir
//            
//            var depletionTime = TimeInterval(hungerMortalValue)
//            if pet.growthAtt.fed < hungerMortalValue {
//                depletionTime -= TimeInterval(hungerMortalValue)
//            } else if pet.growthAtt.awake < sleepnessMortalValue {
//                depletionTime -= TimeInterval(sleepnessMortalValue)
//            }
//            PetManager.sharedInstance.languishInstantaniously(basedOn: depletionTime)
//        }
    }
    
    // MARK: instant message treta
    
    func uploadingChanges(_ data: [String : Any]) {
        print("\nrecebendo iPhone\n\(data)\n")
        
        if data.keys.first == "command" {
            let cmd = data["command"] as! Int
            switch cmd {
            case 1:
                let lunch = Lunch(gain: 10, time: 10) //60
                PetManager.sharedInstance.feed(with: lunch)
            case 2:
                PetManager.sharedInstance.sleep(during: sleepDefaultTime)
            case 3:
                let exercise = Exercise(cost: 20, gain: 30, time: 6) //3600
                PetManager.sharedInstance.exercise(typeOfExercise: exercise)
            default:
                print("O debug tá bom demais!")
            }
        }
    }
    
    let session = WCSession.default()
    
    func startConnectivity() {
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func send(message: [String : Any]) {
        if session.isReachable {
            print("\nenviando iPhone\n")
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.uploadingChanges(message)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
}
