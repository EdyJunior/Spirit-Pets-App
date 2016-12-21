//
//  BattleScene.swift
//  SpiritPets
//
//  Created by padrao on 13/12/16.
//  Copyright © 2016 Edvaldo Junior. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity


class BattleScene: SKScene {
    
    enum CurrentPlayer : String {
        case player1 = "player 1"
        case player2 = "player 2"
        case none = ""
    }
    
    var hp = 20
    var finished = false
    
    var parentVC: BattleViewController!
    
    var currentPlayer = CurrentPlayer.player1
    var winner = CurrentPlayer.none.rawValue
    var opponentName: String?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dictionary: [String: AnyObject]!
    
    var myPetNode: SKSpriteNode!
    var myHpBar: SKSpriteNode!
    
    var opponentPetNode: SKSpriteNode!
    var opponentHpBar: SKSpriteNode!
    var opponentPetImageName: String!
    
    var labelHp: SKLabelNode!
    var labelAtk: SKLabelNode!
    var popUp: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        for (key, value) in dictionary {
            if key == "turn" {
                appDelegate.gameTurn = value as? Bool
            } else if key == "user" {
                appDelegate.gameUser = value as? Int
            }
            else if key == "imageNameOpponent"{
                self.opponentPetImageName = value as! String
            }
        }
        self.hp = 20
        
        print("session: \(appDelegate.multipeerManager.session.connectedPeers.count)")
        self.backgroundColor = SKColor.white
        let backgroundTexture = SKTexture.init(image: UIImage.init(named: "background")!)
        let backgroundNode = SKSpriteNode.init(texture: backgroundTexture)
        backgroundNode.position = CGPoint.init(x: self.frame.width / 2 , y: self.frame.height / 2)
        backgroundNode.size = self.frame.size
        self.addChild(backgroundNode)
        backgroundNode.zPosition = -1
        
        let backButton = SKSpriteNode.init(texture: SKTexture.init(image: UIImage.init(named: "backButton")!))
        backButton.size.width = self.frame.width / 5
        backButton.size.height = self.frame.width / 5
        backButton.position = CGPoint.init(x: backButton.size.width / 2 + 10, y: self.frame.height - backButton.size.height / 2 - 30)
        backButton.name = "backButton"
        self.addChild(backButton)
        
        let atkNode = SKShapeNode(rectOf: CGSize(width: self.frame.width * 0.8, height: self.frame.height * 0.2), cornerRadius: 5)
        atkNode.strokeColor = SKColor.white
        atkNode.position = CGPoint.init(x: self.frame.midX, y: ( atkNode.frame.height / 2 ) + 20)
        
        let btnAtk0 = SKShapeNode(rectOf: CGSize(width: (atkNode.frame.width / 2) - 10, height: 50), cornerRadius: 5)
        btnAtk0.strokeColor = SKColor.white
        btnAtk0.fillColor = SKColor.white
        btnAtk0.name = "btnAtk0"
        btnAtk0.position = CGPoint(x: -btnAtk0.frame.width / 2, y: 0)
        let btn0Label = SKLabelNode(text: "Atack 1")
        btn0Label.position = CGPoint(x: 0, y: -btn0Label.frame.height / 2)
        btn0Label.fontColor = SKColor.black
        btnAtk0.addChild(btn0Label)
        
        let btnAtk1 = SKShapeNode(rectOf: CGSize(width: (atkNode.frame.width / 2) - 10, height: 50), cornerRadius: 5)
        btnAtk1.strokeColor = SKColor.white
        btnAtk1.fillColor = SKColor.white
        btnAtk1.name = "btnAtk1"
        btnAtk1.position = CGPoint(x: btnAtk1.frame.width / 2, y: 0)
        let btn1Label = SKLabelNode(text: "Atack 2")
        btn1Label.position = CGPoint(x: 0, y: -btn1Label.frame.height / 2)
        btn1Label.fontColor = SKColor.black
        btnAtk1.addChild(btn1Label)
        
        atkNode.addChild(btnAtk0)
        atkNode.addChild(btnAtk1)
        
        self.addChild(atkNode)
        
        myPetNode = SKSpriteNode(imageNamed: PetManager.sharedInstance.petChoosed.backImageName)
        myPetNode.position = CGPoint.init(x: 100, y: 250)//(x: myPetNode.size.width / 2, y: myPetNode.size.height)
        myPetNode.size = CGSize(width: 150, height: 150)
        self.addChild(myPetNode)
        myHpBar = SKSpriteNode.init(color: SKColor.red, size: CGSize.init(width: self.frame.midX - 40, height: self.frame.size.height / 20))
        myHpBar.anchorPoint = CGPoint.init(x: 0, y: 0.5)
        //let goodHeight = self.frame.size.height - (myHpBar.size.height * 2 / 3)
        //let goodWidth = self.frame.size.width - (10 + myHpBar.frame.size.width)
        //myHpBar.position = CGPoint(x: goodWidth, y: goodHeight)
        myHpBar.position = CGPoint(x: myPetNode.position.x + (myPetNode.size.width / 2) + 10, y: myPetNode.position.y)
        self.labelHp = SKLabelNode.init(text: "HP: \(self.hp)")
        self.labelHp.position = CGPoint.init(x: self.myHpBar.frame.size.width / 2, y: -self.labelHp.frame.size.height / 2)
        self.labelHp.fontColor = SKColor.white
        myHpBar.addChild(self.labelHp)
        
        
        self.addChild(myHpBar)
        let edges = SKShapeNode.init(rect: myHpBar.frame, cornerRadius: 10)
        edges.fillColor = SKColor.clear
        edges.strokeColor = SKColor.black
        self.addChild(edges)
        
        
        opponentPetNode = SKSpriteNode.init(imageNamed: self.opponentPetImageName)
        opponentPetNode.size.width = self.frame.size.width * 0.3
        opponentPetNode.size.height = self.frame.size.height * 0.2
        opponentPetNode.position = CGPoint.init(x: self.frame.width - (opponentPetNode.size.width / 2), y: self.frame.height - opponentPetNode.size.height)
        self.addChild(opponentPetNode)
        
        opponentHpBar = SKSpriteNode.init(color: SKColor.green, size: CGSize.init(width: self.frame.midX - 40, height: self.frame.size.height / 25))
        opponentHpBar.anchorPoint = CGPoint.init(x: 1, y: 0.5)
        opponentHpBar.position = CGPoint(x: opponentPetNode.position.x - opponentHpBar.frame.width / 2, y: opponentPetNode.position.y)
        self.addChild(opponentHpBar)
        let opEdges = SKShapeNode.init(rect: opponentHpBar.frame, cornerRadius: 10)
        opEdges.fillColor = SKColor.clear
        opEdges.strokeColor = SKColor.black
        self.addChild(opEdges)
        
        
        let button1 = SKShapeNode.init(rect: CGRect.init(x: 100, y: 100, width: 50, height: 50))
        button1.fillColor = SKColor.black
        button1.name = "btn1"
        //self.addChild(button1)
        
        
        self.labelAtk = SKLabelNode.init(text: "Atk: 0000")
        self.labelAtk.position = CGPoint.init(x: self.labelAtk.frame.width, y: 0)
        self.labelAtk.fontColor = SKColor.white
        self.addChild(self.labelAtk)
        
        popUp = SKSpriteNode.init()
        popUp.size.width = self.frame.size.width * 0.8
        popUp.size.height = self.frame.size.height * 0.5
        popUp.color = SKColor.white
        popUp.position = CGPoint.init(x: self.frame.width / 2, y: self.frame.height / 2)
        popUp.zPosition = 2
        let label = SKLabelNode.init(text: "Would you like give up?")
        label.fontColor = SKColor.black
        popUp.addChild(label)
        label.position = CGPoint.init(x: 0, y: label.frame.size.height - 10)
        
        
        let btnYes = SKLabelNode.init(text: "YES")
        btnYes.fontColor = SKColor.black
        let btnNo  = SKLabelNode.init(text: "No")
        btnNo.fontColor = SKColor.black
        popUp.addChild(btnYes)
        popUp.addChild(btnNo)
        //self.addChild(popUp)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMPCReceivedDataWithNotification(notification:)), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "backButton"{
                self.addChild(popUp)//show popup
                //gameDelegate?.onPlayerGiveUP()//talves substituir
                //enviar menssagem de desistencia..
            }
            
            if node.name == "btnAtk0" || node.parent?.name == "btnAtk0"{
                if appDelegate.gameTurn! {
                    //send atack
                    let atk = (arc4random() % 5) + 1
                    self.labelAtk.text = "ATK: \(atk)"
                    let dictAtk = [ "atk": String(atk), "message": ""]
                    appDelegate.multipeerManager.sendData(dictionaryWithData: dictAtk, toPeer: appDelegate.multipeerManager.session.connectedPeers[0])
                    appDelegate.gameTurn = false
                    //sendTappedField()
                    print("\(appDelegate.multipeerManager.localPeer.displayName) tocou")
                    
                    if appDelegate.gameUser == 1 {
                        //xisPositions.append(sender.tag)
                    } else {
                        //circlePositions.append(sender.tag)
                    }
                    //checkResult()
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
            print("Enviou saporra")
        } else {
            print("Não consegue enviar um dick com array int")
        }
    }
    
    func endBattle() {
        let messageDictionary: [String: String] = ["message": "_end_chat_"]
        
        if appDelegate.multipeerManager.sendData(dictionaryWithData: messageDictionary, toPeer: appDelegate.multipeerManager.session.connectedPeers[0]) {
            //self.appDelegate.multipeerManager.session.disconnect()
        }
        
    }
    
    func handleMPCReceivedDataWithNotification(notification: NSNotification) {
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        let data = receivedDataDictionary["data"] as? Data
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data!) as! NSDictionary
        
        if dataDictionary.allKeys.contains(where: {(elemt) in elemt as! String == "res"}){
            //atualiza a opponentHpBar
            let res = dataDictionary["res"] as! String
            let ratio = Double( Int(res)! ) / 20.0
            let newWidth = Double(opponentHpBar.frame.size.width) * ratio
            opponentHpBar.run(SKAction.resize(toWidth: CGFloat(newWidth), duration: 1))
            if Int(res)! < 0{
                let alert = UIAlertController(title: "Spirit Pets", message: "You Won!", preferredStyle: UIAlertControllerStyle.alert)
                let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                    self.appDelegate.multipeerManager.session.disconnect()
                    self.parentVC.dismiss(animated: true, completion: nil)
                    //self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okAction)
                self.parentVC.present(alert, animated: true, completion: nil)
                print("Eu ganhei")
            }
        }
        
        if dataDictionary.allKeys.first as! String == "message" {
            if let message = dataDictionary["message"] {
                if message as! String != "_end_chat_" {
                    /// A ATUALIZAÇÃO DO JOGO FICA AQUI. REGRAS DE NEGÓCIO PROVAVELMENTE FICARÃO AQUI.
                    //self.user01.text = self.appDelegate.multipeerManager.peer.displayName
                    //self.user02.text = fromPeer.displayName
                    
                    //recebeu um ataque
                    if dataDictionary.allKeys.contains(where: {(elemt) in elemt as! String == "atk"}){
                        self.opponentName = fromPeer.displayName
                        let atkStr = dataDictionary["atk"] as! String
                        let atk = Int(atkStr)
                        self.hp -= atk!
                        
                        let dictAtk = ["res": String( self.hp ), "message": ""]
                        appDelegate.multipeerManager.sendData(dictionaryWithData: dictAtk, toPeer: fromPeer)
                        
                        self.labelHp.text = "HP: \(self.hp)"
                        //atualiza a myHpBar
                        let ratio = Double( self.hp ) / 20.0
                        let newWidth = Double(myHpBar.frame.size.width) * ratio
                        myHpBar.run(SKAction.resize(toWidth: CGFloat(newWidth), duration: 1))
                        
                        if self.hp < 1 {
                            print("Eu perdi")
                            self.endBattle()
                            //mostra alert
                            let alert = UIAlertController(title: "Spirit Pets", message: "You Lose!", preferredStyle: UIAlertControllerStyle.alert)
                            
                            let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                                self.appDelegate.multipeerManager.session.disconnect()
                                self.parentVC.dismiss(animated: true, completion: nil)
                                //self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
                            })
                            alert.addAction(okAction)
                            self.parentVC.present(alert, animated: true, completion: nil)
                        }
                        appDelegate.gameTurn = true
                    }
                    
                    
                } else {
                    
                    let alert = UIAlertController(title: "Spirit Pets", message: "You Won!", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        self.appDelegate.multipeerManager.session.disconnect()
                        self.parentVC.dismiss(animated: true, completion: nil)
                        //self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(okAction)
                    self.parentVC.present(alert, animated: true, completion: nil)
                    print("Eu ganhei")
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
