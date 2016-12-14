//
//  BattleScene.swift
//  SpiritPets
//
//  Created by padrao on 13/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity


protocol GameStateDelegate {
    func onFinishGame()
}

class BattleScene: SKScene {
    
    enum CurrentPlayer : String {
        case player1 = "player 1"
        case player2 = "player 2"
        case none = ""
    }
    
    var hp = 20
    
    var gameDelegate: GameStateDelegate?
    
    var currentPlayer = CurrentPlayer.player1
    var winner = CurrentPlayer.none.rawValue
    var opponentName: String?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dictionary: [String: AnyObject]!
    
    var labelHp: SKLabelNode!
    var labelAtk: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.white
        let button1 = SKShapeNode.init(rect: CGRect.init(x: 100, y: 100, width: 50, height: 50))
        button1.fillColor = SKColor.black
        button1.name = "btn1"
        self.addChild(button1)
        
        self.labelHp = SKLabelNode.init(text: "HP: \(self.hp)")
        self.labelHp.position = CGPoint.init(x: self.labelHp.frame.width, y: 50)
        self.labelHp.fontColor = SKColor.black
        self.addChild(self.labelHp)
        
        self.labelAtk = SKLabelNode.init(text: "Atk: 0000")
        self.labelAtk.position = CGPoint.init(x: self.labelAtk.frame.width, y: 0)
        self.labelAtk.fontColor = SKColor.black
        self.addChild(self.labelAtk)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMPCReceivedDataWithNotification(notification:)), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendArrayPeer(notification:)), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)
        
        for (key, value) in dictionary {
            if key == "turn" {
                appDelegate.gameTurn = value as? Bool
            } else if key == "user" {
                appDelegate.gameUser = value as? Int
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            if node.name == "btn1"{
                
                if appDelegate.gameTurn! {
                    //view.isUserInteractionEnabled = false
                    //sender.isUserInteractionEnabled = false
                    //send atack
                    let atk = (arc4random() % 5) + 1
                    self.labelAtk.text = "ATK: \(atk)"
                    let dictAtk = [ "atk": String(atk), "message": ""]
                    appDelegate.multipeerManager.sendData(dictionaryWithData: dictAtk, toPeer: appDelegate.multipeerManager.session.connectedPeers[0])
                    
                    
                    appDelegate.gameTurn = false
                    sendTappedField()
                    print("\(appDelegate.multipeerManager.localPeer.displayName) tocou")
                    if appDelegate.gameUser == 1 {
                        //xisPositions.append(sender.tag)
                    } else {
                        //circlePositions.append(sender.tag)
                    }
                        
                    checkResult()
                } else {
                    print("Não é seu turno ainda")
                }
            }
        }
    }
    
    //override func viewDidAppear(_ animated: Bool) {
      //  appDelegate.multipeerManager.advertiser.stopAdvertisingPeer()
        //sendBasicInformation()
    //}
    
    func receiveMessage(dic: NSDictionary) {
        self.fillTicTacToe()
        //self.sendBasicInformation()
        self.sendTappedField()
        OperationQueue.main.addOperation {
            self.checkResult()
        }
        print("rodou aq")
    }
    
    func fillTicTacToe() {
        /*OperationQueue.main.addOperation {
            for (index, user) in self.appDelegate.gameArray.enumerated() {
                if user == 1 {
                    self.buttons[index].setImage(#imageLiteral(resourceName: "x"), for: .normal)
                    self.buttons[index].isUserInteractionEnabled = false
                } else if user == 2 {
                    self.buttons[index].setImage(#imageLiteral(resourceName: "o"), for: .normal)
                    self.buttons[index].isUserInteractionEnabled = false
                }
            }
        }*/
        
    }
    
    func sendBasicInformation() {
        let messageDictionary: [String: String] = ["message": appDelegate.multipeerManager.localPeer.displayName]
        
        if appDelegate.multipeerManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.multipeerManager.session.connectedPeers[0]) {
            print("Enviou os dados BÁSICOS")
        } else {
            print("Enviar dados BÁSICOS não funcionou")
        }
    }
    
    func sendTappedField() {
        let messageDictionary: [String: [Int]] = ["array": appDelegate.gameArray]
        
        if appDelegate.multipeerManager.sendDataInt(dictionaryWithData: messageDictionary, toPeer: appDelegate.multipeerManager.session.connectedPeers[0]) {
            //appDelegate.con.sendMessage(export: ["gameArray" : appDelegate.gameArray, "gameUser" : appDelegate.gameUser!, "gameTurn" : appDelegate.gameTurn!])
            print("Enviou saporra")
        } else {
            print("Não consegue enviar um dick com array int")
        }
    }
    
    func endBattle() {
        let messageDictionary: [String: String] = ["message": "_end_chat_"]
        
        if appDelegate.multipeerManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.multipeerManager.session.connectedPeers[0]) {
            /*dismiss(animated: true, completion: {
                self.appDelegate.multipeerManager.session.disconnect()
                self.appDelegate.con.sendMessage(export: ["gameArray" : self.appDelegate.gameArray, "gameUser" : self.appDelegate.gameUser!, "gameTurn" : self.appDelegate.gameTurn!])
            })*/
        }
    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        let data = receivedDataDictionary["data"] as? Data
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data!) as! NSDictionary //Dictionary<String, String>
        
        if dataDictionary.allKeys.first as! String == "message" {
            if let message = dataDictionary["message"] {
                if message as! String != "_end_chat_" {
                    OperationQueue.main.addOperation {
                        /// A ATUALIZAÇÃO DO JOGO FICA AQUI. REGRAS DE NEGÓCIO PROVAVELMENTE FICARÃO AQUI.
                        //self.user01.text = self.appDelegate.multipeerManager.peer.displayName
                        //self.user02.text = fromPeer.displayName
                        self.opponentName = fromPeer.displayName
                        //self.appDelegate.con.sendMessage(export: ["gameArray" : self.appDelegate.gameArray, "gameUser" : self.appDelegate.gameUser!, "gameTurn" : self.appDelegate.gameTurn!])
                        let atkStr = dataDictionary["atk"] as! String
                        let atk = Int(atkStr)
                        self.hp -= atk!
                        self.labelHp.text = "HP: \(self.hp)"
                        if self.hp < 1 {
                            print("Eu perdi")
                            self.endBattle()
                            self.gameDelegate?.onFinishGame()
                        }
                    }
                } else {
                    
                    let alert = UIAlertController(title: "Victory!", message: "\(fromPeer.displayName) surrendered.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let doneAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        self.appDelegate.multipeerManager.session.disconnect()
                        //self.dismiss(animated: true, completion: nil)
                    })
                    
                    alert.addAction(doneAction)
                    print("Eu ganhei")
                    self.gameDelegate?.onFinishGame()
                    
                    OperationQueue.main.addOperation {
                        //self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func sendArrayPeer(notification: NSNotification) {
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        let data = receivedDataDictionary["data"] as? Data
        
        let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data!) as! NSDictionary // as! Dictionary<String, [Int]>
        
        if dataDictionary.allKeys.first as! String == "array" {
            if let newArray = dataDictionary["array"] {
                OperationQueue.main.addOperation {
                    self.appDelegate.gameArray = newArray as! [Int]
                    self.appDelegate.gameTurn = true
                    self.fillTicTacToe()
                    //self.appDelegate.con.sendMessage(export: ["gameArray" : self.appDelegate.gameArray, "gameUser" : self.appDelegate.gameUser!, "gameTurn" : self.appDelegate.gameTurn!])
                    self.checkResult()
                    //self.fixArray()
                }
            }
        }
    }
    
    
    func checkResult(){
    }
    
    
}
