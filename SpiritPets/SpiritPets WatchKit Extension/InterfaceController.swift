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
    
    var experienceValue: Int!
    var sleepValue: Int!
    var exerciseValue: Int!
    var fedValue: Int!
    
    override func awake(withContext context: Any?) {
        
        startConnectivity()
        setup()
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
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
        experienceValue = 0
        sleepValue = 0
        exerciseValue = 0
        fedValue = 0
    }
    
    func loadGauges() {
        experienceImage.setTitle("XP")
        experienceImage.setBackgroundImageNamed("Experience\(experienceValue!)Gauge")
        
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
        fedValue = 50
        loadGauges()
    }
    
    let session = WCSession.default()
    
    func startConnectivity() {
        session.delegate = self
        session.activate()
    }
    
    func send(message: [String : Any]) {
        if session.isReachable {
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
