//
//  InterfaceController.swift
//  SpiritPets WatchKit Extension
//
//  Created by Edvaldo Junior on 28/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController , WCSessionDelegate {
    @IBOutlet var experienceImage: WKInterfaceButton!
    @IBOutlet var sleepImage: WKInterfaceButton!
    @IBOutlet var exerciseImage: WKInterfaceButton!
    @IBOutlet var fedImage: WKInterfaceButton!
    
    var levelValue: Int!
    var experienceValue: Int!
    var sleepValue: Int!
    var exerciseValue: Int!
    var nextLevel: Int!
    var fedValue: Int!
    
    override func awake(withContext context: Any?) {
        
        startConnectivity()
        setup()
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        send(message: ["fed" : 10])
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func setup() {
        loadValues()
        loadGauges()
    }
    
    func loadValues() {
        levelValue = 1
        nextLevel = 30
        experienceValue = 0
        sleepValue = 0
        exerciseValue = 0
        fedValue = 0
    }
    
    func loadGauges() {
        experienceImage.setTitle("LV: \(levelValue!)")
        experienceImage.setBackgroundImageNamed("Experience\(Int(100 * experienceValue! / nextLevel!))Gauge")
        
        sleepImage.setTitle("SL")
        sleepImage.setBackgroundImageNamed("Sleep\(sleepValue!)Gauge")
        
        exerciseImage.setTitle("ST")
        exerciseImage.setBackgroundImageNamed("Exercise\(exerciseValue!)Gauge")
        
        fedImage.setTitle("FD")
        fedImage.setBackgroundImageNamed("Fed\(fedValue!)Gauge")
    }
    
    // MARK: instant message treta
    
    func uploadingChanges(_ data: [String : Any]) {
        // tratar os dados recebidos da mensagem aqui, mantendo o modelo para todas as VC
        print("\nRecebendo Watch\n\(data)\n")

        fedValue = data["fed"] as! Int
        sleepValue = data["awake"] as! Int
        exerciseValue = data["stamina"] as! Int
        experienceValue = data["experience"] as! Int
        nextLevel = data["nextLevel"] as! Int
        levelValue = data["level"] as! Int
        
        loadGauges()
    }
    
    let session = WCSession.default()
    
    func startConnectivity() {
        session.delegate = self
        session.activate()
    }
    
    func send(message: [String : Any]) {
        if session.isReachable {
            print("\nenviando Watch\n")
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.uploadingChanges(message)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
}
