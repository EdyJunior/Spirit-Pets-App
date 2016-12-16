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


class InterfaceController: WKInterfaceController, ConnectivityManagerProtocol {
    @IBOutlet var experienceImage: WKInterfaceButton!
    @IBOutlet var sleepImage: WKInterfaceButton!
    @IBOutlet var exerciseImage: WKInterfaceButton!
    @IBOutlet var fedImage: WKInterfaceButton!
    
    var experienceValue: Int!
    var sleepValue: Int!
    var exerciseValue: Int!
    var fedValue: Int!
    
    override func awake(withContext context: Any?) {
        
        setup()
        
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        ConnectivityManager.connectivityManager.addDataChangedDelegate(delegate: self)
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        ConnectivityManager.connectivityManager.removeDataChangedDelegate(delegate: self)
        super.didDeactivate()
    }
    
    func setup() {
        loadValues()
        loadGauges()
    }
    
    func loadValues() {
        // implementar consumo de dados
        
        experienceValue = 100
        sleepValue = 75
        exerciseValue = 50
        fedValue = 25
    }
    
    func loadGauges() {
        //experienceImage.setEnabled(false)
        experienceImage.setTitle("XP")
        experienceImage.setBackgroundImageNamed("Experience\(experienceValue!)Gauge")
        
        //sleepImage.setEnabled(false)
        sleepImage.setTitle("SL")
        sleepImage.setBackgroundImageNamed("Sleep\(sleepValue!)Gauge")
        
        //exerciseImage.setEnabled(false)
        exerciseImage.setTitle("ST")
        exerciseImage.setBackgroundImageNamed("Exercise\(exerciseValue!)Gauge")
        
        //fedImage.setEnabled(false)
        fedImage.setTitle("FD")
        fedImage.setBackgroundImageNamed("Fed\(fedValue!)Gauge")
        
    }
    
    @IBAction func sendMsg() {
        messageTest()
    }
    
    func messageTest() {
        print("\n\n\nCheguei")
        
        let fedMessage = ["fed" : 0]
        
        let message = ["updateStatus" : fedMessage]
        
        do {
            try ConnectivityManager.connectivityManager.updateApplicationContext(applicationContext: message as [String : AnyObject])
            print("\(message)\n\n\n")
        } catch {
            print("Error")
        }
    }
    
    // MARK: Connectivity Delegate
    
    func changeUI() {
        print("\n\n2\n\n")
        fedValue = 50
        loadGauges()
    }
 
}
