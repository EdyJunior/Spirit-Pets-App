//
//  PetChoosed.swift
//  SpiritPets
//
//  Created by Edvaldo Junior on 02/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit

class PetChoosed: LivingBeing, PetProtocol, LanguishProtocol {

    var battleAtt = BattleAttributes(hp: 0, atk: 0, dfs: 0, rdm: 0, lv: 0, xp: 0)
    var baseBattleAtt = BattleAttributes(hp: 0, atk: 0, dfs: 0, rdm: 0, lv: 0, xp: 0)
    var historyOfAtt: [BattleAttributes] = []

    var frontImage = UIImage()
    var backImage = UIImage()
    
    var type: PetType = .light
    var name: String = ""
    
    var number: Int = 0
    var stage: PetStage = .chibi
    
    required init(name: String) {
        
        super.init(fed: 0, awake: 0, stamina: 0)
        
        self.name = name
        self.languishDelegate = self
        
        let pet = getPetDictionary()
        
        setFeaturesPet(pet: pet)
        setBaseBattleAtt(pet: pet)
        calculateAttributes()
    }

    func getPetDictionary() -> [String : Any] {

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
        
        if let alreadySet = defaults.object(forKey: "alreadySetBattleStatus") as? Bool, alreadySet {
            let attributes = defaults.object(forKey: "battleAtt") as! [String : Int]
            
            self.battleAtt = BattleAttributes(hp: attributes["hp"]!,
                                              atk: attributes["atk"]!,
                                              dfs: attributes["dfs"]!,
                                              rdm: UInt32(attributes["rdm"]!),
                                              lv: attributes["lv"]!,
                                              xp: attributes["xp"]!)
        } else {
            let base = self.baseBattleAtt
            let lv = 1
            let xp = 0
            let rdm = Int(base.rdm)
            let hp = 2 * base.hp + 1 + Int(arc4random_uniform(base.rdm))
            let atk = base.atk + 1 + Int(arc4random_uniform(base.rdm))
            let dfs = base.dfs + 1 + Int(arc4random_uniform(base.rdm))
            
            let attributes: [String : Int] = ["hp": hp, "atk": atk, "dfs": dfs, "rdm": rdm, "lv": lv, "xp": xp]
            self.battleAtt = BattleAttributes(hp: attributes["hp"]!,
                                              atk: attributes["atk"]!,
                                              dfs: attributes["dfs"]!,
                                              rdm: UInt32(attributes["rdm"]!),
                                              lv: attributes["lv"]!,
                                              xp: attributes["xp"]!)
            self.historyOfAtt.append(self.battleAtt)
            defaults.set(attributes, forKey: "battleAtt")
            defaults.set(true, forKey: "alreadySetBattleStatus")
        }
        defaults.set(false, forKey: "alreadySetBattleStatus")
    }
    
    func setGrowthAtt() {
        
        if let alreadySet = defaults.object(forKey: "alreadySetGrowthStatus") as? Bool, alreadySet {
            let fed = defaults.object(forKey: "fed") as! Int
            let awake = defaults.object(forKey: "awake") as! Int
            let stamina = defaults.object(forKey: "stamina") as! Int

            self.growthAtt = GrowthAttributes(fed: fed, awake: awake, stamina: stamina)
        } else {
            defaults.set(100, forKey: "fed")
            defaults.set(100, forKey: "awake")
            defaults.set(100, forKey: "stamina")
            self.growthAtt = GrowthAttributes(fed: 100, awake: 100, stamina: 100)
            defaults.set(true, forKey: "alreadySetGrowthStatus")
        }
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

        self.battleAtt.lv += 1
        self.battleAtt.hp += self.baseBattleAtt.hp + Int(arc4random_uniform(self.battleAtt.rdm + 1) / 2)
        self.battleAtt.atk += self.baseBattleAtt.atk + Int(arc4random_uniform(self.battleAtt.rdm + 1) / 2)
        self.battleAtt.dfs += self.baseBattleAtt.dfs + Int(arc4random_uniform(self.battleAtt.rdm + 1) / 2)
        self.historyOfAtt.append(self.battleAtt)

        print("\n\nUpou\n\n\(battleAtt)")
    }

    func xpUp(xp: Int) {

        self.battleAtt.xp += xp
        while self.battleAtt.xp >= (self.baseBattleAtt.xp * self.battleAtt.lv) {
            self.battleAtt.xp -= (self.baseBattleAtt.xp * self.battleAtt.lv)
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
        
        self.battleAtt.xp -= xp
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
