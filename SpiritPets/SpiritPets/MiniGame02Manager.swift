//
//  MiniGame02Manager.swift
//  SpiritPets
//
//  Created by Augusto Falcão on 11/30/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import UIKit
import SpriteKit

protocol MiniGame02ManagerDelegate {
    
    func updateLives(to lives: Int)
    func updateScore(to score: Int)
    func didGameOver()
}

class MiniGame02Manager {
    
    var delegate: MiniGame02ManagerDelegate? = nil
    
    var lives: Int = 3
    var score: Int = 0
    
    static let instance = MiniGame02Manager()
    
    private init() {}
    
    func setup() {
        self.lives = 3
        self.score = 0
    }
    
    func increaseScore(by score: Int) {
        self.score += score
        self.delegate?.updateScore(to: self.score)
    }
    
    func loseLife() {
        self.lives -= 1
        self.delegate?.updateLives(to: self.lives)
        self.checkGameOver()
    }
    
    private func checkGameOver() {
        
        if(self.lives == 0) {
            self.delegate?.didGameOver()
        }
    }
    
}
