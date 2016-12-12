//
//  PetChoosed.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 02/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class PetChoosed: LivingBeing, PetProtocol, LanguishProtocol, NSCoding {

    var battleAtt = BattleAttributes(hp: 0, atk: 0, dfs: 0, rdm: 0, lv: 0, xp: 0)
    var baseBattleAtt = BattleAttributes(hp: 0, atk: 0, dfs: 0, rdm: 0, lv: 0, xp: 0)
    var historyOfAtt: [BattleAttributes] = []

    var frontImage = UIImage()
    var backImage = UIImage()
    var frontImageName = ""
    var backImageName = ""
    
    var type: PetType = .light
    var name: String = ""
    
    var number: Int! = 0
    var stage: PetStage = .chibi
    
    //var baseDict = [String: Any]()
    
    /*required init(name: String) {
        
        super.init(fed: 0, awake: 0, stamina: 0)
        
        self.name = name
        self.languishDelegate = self
        
        let pet = getPetFromJson()
        
        setFeaturesPet(pet: pet)
        setBaseBattleAtt(pet: pet)
        calculateAttributes()
    }*/
    
    required init( dict: [String : Any] ){
        self.name = dict["name"] as! String
        self.number = dict["number"] as! Int
        self.frontImageName = dict["frontImage"] as! String
        self.backImageName  = dict["backImage"] as! String
        super.init(fed: 0, awake: 0, stamina: 0)
        
        self.languishDelegate = self
        setFeaturesPet(pet: dict)
        setBaseBattleAtt(pet: dict)
        calculateAttributes()
    }

    /*func getPetDictionary() -> [String: Any] {
    
        var petDict = [String: Any]()
        petDict["number"] = self.number
        petDict["name"] = self.name
        petDict["type"] = self.type.rawValue
        petDict["stage"] = self.stage.rawValue
        petDict["battleAtt"] = ["hp": battleAtt.hp, "atk": battleAtt.atk,                                        "dfs": battleAtt.dfs, "rdm": battleAtt.rdm, "lv": battleAtt.lv,                                        "xp": battleAtt.xp]
        petDict["baseBattleAttt"] = ["hp": baseBattleAtt.hp, "atk": baseBattleAtt.atk, "dfs": baseBattleAtt.dfs, "rdm": baseBattleAtt.rdm, "lv": baseBattleAtt.lv, "xp": baseBattleAtt.xp]
        petDict["historyOfAtt"] = historyOfAtt as AnyObject?
        //let dictFromJson = getPetFromJson()
        petDict["frontImage"] = baseDict["frontImage"] as! String
        petDict["backImage"] = baseDict["backImage"]   as! String
        petDict["nextEvo"] = baseDict["nextEvo"]       as! String
        
        return petDict

    }
    
    private func getPetFromJson() -> [String : Any] {

        guard let path = Bundle(for: type(of: self)).path(forResource: "PetsAttributes", ofType: "json")
            else { fatalError("Can't find PetsAttributes JSON resource.") }

        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String : Any]]
        
        var pet: [String : Any] = [:]
        
        for petJson in json {
            let petName = petJson["name"] as? String
            if petName == name {
                pet = petJson
                break
            }
        }
        return pet
    }*/
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.growthAtt, forKey: "growthAtt")
        aCoder.encode(self.battleAtt, forKey: "battleAtt")
        aCoder.encode(self.baseBattleAtt, forKey: "baseBattleAtt")
        aCoder.encode(self.historyOfAtt, forKey:"historyOfAtt")
        aCoder.encode(self.frontImage, forKey: "frontImage")
        aCoder.encode(self.backImage, forKey: "backImage")
        aCoder.encode(self.frontImageName, forKey: "frontImageName")
        aCoder.encode(self.backImageName, forKey: "backImageName")
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.number, forKey: "number")
        aCoder.encode(self.stage.rawValue, forKey: "stage")
    }
    
    required init?(coder aDecoder: NSCoder) {
        //let growthAttributes = aDecoder.decodeObject(forKey: "growthAtt") as! GrowthAttributes
        super.init(fed: 100, awake: 100, stamina: 100)
        self.languishDelegate = self
        growthAtt = aDecoder.decodeObject(forKey: "growthAtt") as! GrowthAttributes
        battleAtt = aDecoder.decodeObject(forKey: "battleAtt") as! BattleAttributes
        baseBattleAtt = aDecoder.decodeObject(forKey: "baseBattleAtt") as! BattleAttributes
        historyOfAtt = aDecoder.decodeObject(forKey: "historyOfAtt") as! [BattleAttributes]
        frontImage = aDecoder.decodeObject(forKey: "frontImage") as! UIImage
        backImage = aDecoder.decodeObject(forKey: "backImage") as! UIImage
        frontImageName = aDecoder.decodeObject(forKey: "frontImageName") as! String
        backImageName = aDecoder.decodeObject(forKey: "backImageName") as! String
        type = PetType( rawValue: aDecoder.decodeObject(forKey: "type") as! String)!
        name = aDecoder.decodeObject(forKey: "name") as! String
        number = aDecoder.decodeObject(forKey: "number") as! Int
        stage = PetStage( rawValue: aDecoder.decodeObject(forKey: "stage") as! String)!
    }
    
    func setFeaturesPet(pet: [String : Any]) {
        
        self.type = PetType(rawValue: pet["type"] as! String)!
        self.frontImage = UIImage(named: pet["frontImage"] as! String)!
        self.backImage = UIImage(named: pet["backImage"] as! String)!
        self.number = pet["number"] as! Int
        self.stage = PetStage(rawValue: pet["stage"] as! String)!
    }
    
    func setBaseBattleAtt(pet: [String : Any]) {
        
        let base = pet["baseBattleAtt"] as! [String : Int]
        self.baseBattleAtt = BattleAttributes(hp: base["hp"]!,
                                              atk: base["atk"]!,
                                              dfs: base["dfs"]!,
                                              rdm: UInt32(base["rdm"]!),
                                              lv: base["lv"]!,
                                              xp: base["xp"]!)
    }
    
    func calculateAttributes() {
        
        setBattleAtt()
        setGrowthAtt()
    }

    func setBattleAtt() {
        
//        if let alreadySet = defaults.object(forKey: "alreadySetBattleStatus") as? Bool, alreadySet {
//            let attributes = defaults.object(forKey: "battleAtt") as! [String : Int]
//            
//            self.battleAtt = BattleAttributes(hp: attributes["hp"]!,
//                                              atk: attributes["atk"]!,
//                                              dfs: attributes["dfs"]!,
//                                              rdm: UInt32(attributes["rdm"]!),
//                                              lv: attributes["lv"]!,
//                                              xp: attributes["xp"]!)
//            self.historyOfAtt.append(self.battleAtt)
//        } else {
        let base = self.baseBattleAtt
        let lv = 1
        let xp = 0
        let rdm = Int(base.rdm)
        let hp = 2 * base.hp + 1 + Int(arc4random_uniform(UInt32(base.rdm)))
        let atk = base.atk + 1 + Int(arc4random_uniform(UInt32(base.rdm)))
        let dfs = base.dfs + 1 + Int(arc4random_uniform(UInt32(base.rdm)))
        
        let attributes: [String : Int] = ["hp": hp, "atk": atk, "dfs": dfs, "rdm": rdm, "lv": lv, "xp": xp]
        self.battleAtt = BattleAttributes(hp: attributes["hp"]!,
                                          atk: attributes["atk"]!,
                                          dfs: attributes["dfs"]!,
                                          rdm: UInt32(attributes["rdm"]!),
                                          lv: attributes["lv"]!,
                                          xp: attributes["xp"]!)
        
        let nextLv = BattleAttributes(hp: 0, atk: 0, dfs: 0, rdm: 0, lv: 0, xp: 0)
        nextLv.lv = self.battleAtt.lv
        nextLv.xp = self.battleAtt.xp
        nextLv.hp = self.battleAtt.hp
        nextLv.atk = self.battleAtt.atk
        nextLv.dfs = self.battleAtt.dfs

        //defaults.set(attributes, forKey: "battleAtt")
        self.historyOfAtt.append(nextLv)
            //defaults.set(true, forKey: "alreadySetBattleStatus")
        //}
        //defaults.set(false, forKey: "alreadySetBattleStatus")
    }

    func setGrowthAtt() {
        
//        if let alreadySet = defaults.object(forKey: "alreadySetGrowthStatus") as? Bool, alreadySet {
//            let fed = defaults.object(forKey: "fed") as! Int
//            let awake = defaults.object(forKey: "awake") as! Int
//            let stamina = defaults.object(forKey: "stamina") as! Int
//
//            self.growthAtt = GrowthAttributes(fed: fed, awake: awake, stamina: stamina)
//        } else {
//        defaults.set(100, forKey: "fed")
//        defaults.set(100, forKey: "awake")
//        defaults.set(100, forKey: "stamina")
        self.growthAtt = GrowthAttributes(fed: 100, awake: 100, stamina: 100)
            //defaults.set(true, forKey: "alreadySetGrowthStatus")
//        }
    }
    
    func calculateOffensivePower() -> Int {
        return (battleAtt.atk + 2 * Int(battleAtt.rdm))
    }
    
    func calculateDamageReceived(enemysOffensive offensive: Int) -> Int {
        
        let dano = (offensive - (battleAtt.dfs + 2 * Int(battleAtt.rdm)))
        return dano > 0 ? dano : 1
    }
    
    func add(toHp: Int, theValue value: Int) -> Int {
        
        var hp = toHp + value
        if hp < 0 {
            hp = 0
        } else if hp > battleAtt.hp {
            hp = battleAtt.hp
        }
        return hp
    }

    func lvUp() {

        let number0: Int! = Int(arc4random_uniform(self.battleAtt.rdm + 1) / 2)
        let number1: Int! = Int(arc4random_uniform(self.battleAtt.rdm + 1) / 2)
        let number2: Int! = Int(arc4random_uniform(self.battleAtt.rdm + 1) / 2)
        
        let nextLv = BattleAttributes(hp: 0, atk: 0, dfs: 0, rdm: 0, lv: 0, xp: 0)
        nextLv.lv = self.battleAtt.lv + 1
        nextLv.xp = self.battleAtt.xp
        nextLv.hp = self.battleAtt.hp + self.baseBattleAtt.hp + number0
        nextLv.atk = self.battleAtt.atk + self.baseBattleAtt.atk + number1
        nextLv.dfs = self.battleAtt.dfs + self.baseBattleAtt.dfs + number2
        
        battleAtt.lv = nextLv.lv
        battleAtt.xp = nextLv.xp
        battleAtt.hp = nextLv.hp
        battleAtt.atk = nextLv.atk
        battleAtt.dfs = nextLv.dfs
        
        self.historyOfAtt.append(nextLv)

        print("\n\nUpou\n\n\(battleAtt)")
    }

    func xpUp(xp: Int) {

        self.battleAtt.xp = xp + self.battleAtt.xp
        while self.battleAtt.xp >= (self.baseBattleAtt.xp * self.battleAtt.lv) {
            self.battleAtt.xp = self.battleAtt.xp - (self.baseBattleAtt.xp * self.battleAtt.lv)
            print("\n\nup = \(self.baseBattleAtt.xp * self.battleAtt.lv) to lv = \(battleAtt.lv + 1)\n\n")
            self.lvUp()
        }
    }

    func lvDown() {

        let _ = self.historyOfAtt.popLast()
        self.battleAtt = self.historyOfAtt.last!
        self.battleAtt.xp = self.baseBattleAtt.xp * self.battleAtt.lv - 1

        print("\n\nDownou\n\n\(battleAtt)")
    }
    
    func xpDown(xp: Int) {
        
        self.battleAtt.xp = self.battleAtt.xp - xp
        if self.battleAtt.xp < 0 {
            if self.battleAtt.lv > 1 {
                self.lvDown()
            } else {
                self.battleAtt.xp = 0
            }
        }
    }
    
    func languish() {
        
        print("Morrendo. Xp = \(battleAtt.xp) e lv = \(battleAtt.lv)")
        xpDown(xp: 10)
    }
}
