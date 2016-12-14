//
//  PetUtils.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 30/11/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import Foundation

//Types of pet. For now types won't influentiate the playability.
enum PetType: String {
    
    case light
    case dark
}

//Stages of the evolution of pets. chibi is the first one and monster is the most advanced
enum PetStage: String {
    
    case chibi
    case kid
    case big
    case monster
}

//Cost is the cost of stamina. Gain is the increase in the pet's experience. Time is the time needed to finish the exercise
struct Exercise {
    
    let cost: Int
    let gain: Int
    let time: Int
}

//Types of lunch. Gain is the increase in the pet's fed status. Time is the time needed to finish the meal
struct Lunch {
    
    let gain: Int
    let time: Int
}

//Variables related to battle
let hpKey = "hp"
let atkKey = "atk"
let dfsKey = "dfs"
let rdmKey = "rdm"
let lvKey = "lv"
let xpKey = "xp"

class BattleAttributes: NSObject, NSCoding {
    
    var  hp: Int!
    var atk: Int!
    var dfs: Int!
    var rdm: UInt32!
    var  lv: Int!
    var  xp: Int!
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.hp, forKey: hpKey)
        aCoder.encode(self.atk, forKey: atkKey)
        aCoder.encode(self.dfs, forKey: dfsKey)
        aCoder.encode(self.rdm, forKey: rdmKey)
        aCoder.encode(self.lv, forKey: lvKey)
        aCoder.encode(self.xp, forKey: xpKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.hp = aDecoder.decodeObject(forKey: hpKey) as! Int
        self.atk = aDecoder.decodeObject(forKey: atkKey) as! Int
        self.dfs = aDecoder.decodeObject(forKey: dfsKey) as! Int
        self.rdm = aDecoder.decodeObject(forKey: rdmKey) as! UInt32
        self.lv = aDecoder.decodeObject(forKey: lvKey) as! Int
        self.xp = aDecoder.decodeObject(forKey: xpKey) as! Int
        super.init()
    }
    
    init(hp: Int, atk: Int, dfs: Int, rdm: UInt32, lv: Int, xp: Int) {
        
        self.hp = hp
        self.atk = atk
        self.dfs = dfs
        self.rdm = rdm
        self.lv = lv
        self.xp = xp
        super.init()
    }
    
    override var description: String {
        return "hp = \(hp!)\natk = \(atk!)\ndfs = \(dfs!)\nrdm = \(rdm!)\nlv = \(lv!)\nxp = \(xp!)"
    }
}

struct StateOfAttributes {
    
    var previous: BattleAttributes
    var current: BattleAttributes
}

class GrowthAttributes: NSObject, NSCoding {
    
    var fed: Int!
    var awake: Int!
    var stamina: Int!
    
    required init?(coder aDecoder: NSCoder) {
        
        self.fed = aDecoder.decodeObject(forKey: "fed") as! Int
        self.awake = aDecoder.decodeObject(forKey: "awake") as! Int
        self.stamina = aDecoder.decodeObject(forKey: "stamina") as! Int
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.fed, forKey: "fed")
        aCoder.encode(self.awake, forKey: "awake")
        aCoder.encode(self.stamina, forKey: "stamina")
    }
    
    init(fed: Int, awake: Int, stamina: Int){
        
        self.fed = fed
        self.awake = awake
        self.stamina = stamina
    }
    
    override var description: String {
        return "fed = \(self.fed!)\nawake = \(self.awake!)\nstamina = \(self.stamina!)"
    }
}

let updateInterval: TimeInterval = 6/*2592*/

let sleepInterval: TimeInterval = 10/*36000*/
let sleepnessUpRate: Int = 50//1
let sleepnessDownRate: Int = -5//1
let sleepnessWarningValue: Int = 50
let sleepnessDangerousValue: Int = 30
let sleepnessMortalValue: Int = 10

let hungerHighRate: Int = 10//2
let hungerLowRate: Int = 1
let hungerWarningValue: Int = 50
let hungerDangerousValue: Int = 30
let hungerMortalValue: Int = 10

let staminaHighRate: Int = 4
let staminaLowRate: Int = 2
let staminaMinDecentValue = 10

let defaults = UserDefaults.standard
