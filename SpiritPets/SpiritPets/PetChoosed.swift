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

    var frontImage = UIImage()
    var backImage = UIImage()
    var frontImageName = ""
    var backImageName = ""
    
    var type: PetType = .light
    var name: String = ""
    
    var number: Int! = 0
    var stage: PetStage = .chibi
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.growthAtt, forKey: "growthAtt")
        aCoder.encode(self.battleAtt, forKey: "battleAtt")
        aCoder.encode(self.baseBattleAtt, forKey: "baseBattleAtt")
        aCoder.encode(PetManager.sharedInstance.historyOfAtt, forKey:"historyOfAtt")
        aCoder.encode(self.frontImage, forKey: "frontImage")
        aCoder.encode(self.backImage, forKey: "backImage")
        aCoder.encode(self.frontImageName, forKey: "frontImageName")
        aCoder.encode(self.backImageName, forKey: "backImageName")
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.number, forKey: "number")
        aCoder.encode(self.stage.rawValue, forKey: "stage")
        aCoder.encode(self.isSleeping, forKey: "isSleeping")
        aCoder.encode(self.isEating, forKey: "isEating")
        aCoder.encode(self.isExercising, forKey: "isExercising")
    }
    
    required init(dict: [String : Any] ) {
        
        self.name = dict["name"] as! String
        self.number = dict["number"] as! Int
        self.frontImageName = dict["frontImage"] as! String
        self.backImageName  = dict["backImage"] as! String
        super.init(fed: 100, awake: 100, stamina: 100)
        
        self.languishDelegate = self
        setFeaturesPet(pet: dict)
        setBaseBattleAtt(pet: dict)
        calculateAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(fed: 100, awake: 100, stamina: 100)
        
        self.languishDelegate = self
        
        growthAtt = aDecoder.decodeObject(forKey: "growthAtt") as! GrowthAttributes
        battleAtt = aDecoder.decodeObject(forKey: "battleAtt") as! BattleAttributes
        baseBattleAtt = aDecoder.decodeObject(forKey: "baseBattleAtt") as! BattleAttributes
        PetManager.sharedInstance.historyOfAtt = aDecoder.decodeObject(forKey: "historyOfAtt") as! [BattleAttributes]
        frontImage = aDecoder.decodeObject(forKey: "frontImage") as! UIImage
        backImage = aDecoder.decodeObject(forKey: "backImage") as! UIImage
        frontImageName = aDecoder.decodeObject(forKey: "frontImageName") as! String
        backImageName = aDecoder.decodeObject(forKey: "backImageName") as! String
        type = PetType(rawValue: aDecoder.decodeObject(forKey: "type") as! String)!
        name = aDecoder.decodeObject(forKey: "name") as! String
        number = aDecoder.decodeObject(forKey: "number") as! Int
        stage = PetStage(rawValue: aDecoder.decodeObject(forKey: "stage") as! String)!
        self.isSleeping = aDecoder.decodeBool(forKey: "isSleeping")// as! Bool
        self.isEating = aDecoder.decodeBool(forKey: "isEating")// as! Bool
        isExercising = aDecoder.decodeBool(forKey: "isExercising")// as! Bool
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

        let base = self.baseBattleAtt
        let lv = 1
        let xp = 0
        let rdm = base.rdm!
        let hp = 2 * base.hp + 1 + Int(arc4random_uniform(UInt32(base.rdm)))
        let atk = base.atk + 1 + Int(arc4random_uniform(UInt32(base.rdm)))
        let dfs = base.dfs + 1 + Int(arc4random_uniform(UInt32(base.rdm)))

        self.battleAtt = BattleAttributes(hp: hp,
                                          atk: atk,
                                          dfs: dfs,
                                          rdm: rdm,
                                          lv: lv,
                                          xp: xp)

        let nextLv = BattleAttributes(hp: hp, atk: atk, dfs: dfs, rdm: rdm, lv: lv, xp: xp)

        PetManager.sharedInstance.historyOfAtt.append(nextLv)
    }

    func lvUp() {

        let number0: Int! = Int(arc4random_uniform(self.battleAtt.rdm + 1) / 2)
        let number1: Int! = Int(arc4random_uniform(self.battleAtt.rdm + 1) / 2)
        let number2: Int! = Int(arc4random_uniform(self.battleAtt.rdm + 1) / 2)
        
        let lv = self.battleAtt.lv + 1
        let xp = self.battleAtt.xp!
        let rdm = self.battleAtt.rdm!
        let hp = self.battleAtt.hp + self.baseBattleAtt.hp + number0
        let atk = self.battleAtt.atk + self.baseBattleAtt.atk + number1
        let dfs = self.battleAtt.dfs + self.baseBattleAtt.dfs + number2
        
        let nextLv = BattleAttributes(hp: hp, atk: atk, dfs: dfs, rdm: rdm, lv: lv, xp: xp)
        
        self.battleAtt = nextLv
        
        PetManager.sharedInstance.historyOfAtt.append(nextLv)
        PetManager.sharedInstance.evolve()
        
        print("\n\nUpou\n\n\(battleAtt)\n")
    }

    func xpUp(xp: Int) {

        self.battleAtt.xp! += xp
        while self.battleAtt.xp >= (self.baseBattleAtt.xp! * self.battleAtt.lv!) {
            self.battleAtt.xp! -= (self.baseBattleAtt.xp! * self.battleAtt.lv!)
            print("\n\nup = \(self.baseBattleAtt.xp! * self.battleAtt.lv!) to lv = \(battleAtt.lv! + 1)\n\n")
            self.lvUp()
        }
    }

    func lvDown() {

        let _ = PetManager.sharedInstance.historyOfAtt.popLast()
        self.battleAtt = PetManager.sharedInstance.historyOfAtt.last!
        self.battleAtt.xp = self.baseBattleAtt.xp * self.battleAtt.lv - 1
        print("\n\nDownou\n\n\(battleAtt)\n")
    }
    
    func xpDown(xp: Int) {
        
        self.battleAtt.xp! -= xp
        if self.battleAtt.xp < 0 {
            if PetManager.sharedInstance.historyOfAtt.count > 1 {
                self.lvDown()
            } else {
                self.battleAtt.xp = 0
            }
        }
    }
    
    func languish() {
        
        print("Morrendo. Xp = \(battleAtt.xp!) e lv = \(battleAtt.lv!)\n")
        xpDown(xp: depletionRate)
    }
}
