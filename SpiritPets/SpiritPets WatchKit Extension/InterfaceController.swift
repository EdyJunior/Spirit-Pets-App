//
//  InterfaceController.swift
//  SpiritPets WatchKit Extension
//
//  Created by Edvaldo Junior on 28/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
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
        setup()
        super.willActivate()
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
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
