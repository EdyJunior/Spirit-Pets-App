//
//  GrowthActionsViewController.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 12/7/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class GrowthActionsViewController: WKInterfaceController, WCSessionDelegate {
    
    override func awake(withContext context: Any?) {
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
    
    @IBAction func eatAction() {
        let message = ["command" : 1]
        send(message: message)
    }
    
    @IBAction func sleepAction() {
        let message = ["command" : 2]
        send(message: message)
    }
    
    @IBAction func exerciseAction() {
        let message = ["command" : 3]
        send(message: message)
    }
    
    // MARK: instant message treta
    
    func uploadingChanges(_ data: [String : Any]) {
        // tratar os dados recebidos da mensagem aqui, mantendo o modelo para todas as VC
        print("\nRecebendo Watch\n\(data)\n")
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
