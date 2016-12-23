import SpriteKit
import GameplayKit

class MiniGame01Scene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    var actualTime: TimeInterval = 0
    var counter: SKLabelNode?
    
    var blocked = false
    
    let displaySize = UIScreen.main.bounds.size
    
    var typePet: PetType?
    var lightPets: Int?
    var darkPets: Int?
    
    var score: Int?
    var gameOver = false
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
        
        self.isUserInteractionEnabled = false
        
        self.isPaused = false
        
        self.score = 0
        
        self.resetPets()
        self.createGrid()
        self.createCounter()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if (gameOver) {
            self.backToMenu()
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func randomTypeNumber() -> PetType {
        let number = arc4random() % 2
        var type: PetType = .light
        switch number {
        case 0:
            type = .light
            lightPets = lightPets! + 1
            break
        case 1:
            type = .dark
            darkPets = darkPets! + 1
            break
        default:
            break
        }
        return type
    }
    
    func resetPets() {
        lightPets = 0
        darkPets = 0
    }
    
    func createGrid() {
        var i = 0
        while(i < 4) {
            
            let a = Double((i % 4) + 1)
            let c = a / 5.0
            let x = CGFloat(Double(self.displaySize.width) * c)
            
            var j = 0
            while(j < 6) {
                let side = self.displaySize.width * 0.22
                let pet = PetNodeMiniGame.randomPetOfType(type: self.randomTypeNumber())
                pet.sprite.size = CGSize(width: side, height: side)
                pet.delegate = self
                
                let b = Double((j % 6) + 1)
                let d = b / 8.0
                let y = CGFloat(Double(self.displaySize.height) * d)
                let position = CGPoint(x: x, y: y)
                
                pet.position = position
                self.addChild(pet)
                
                j += 1
            }
            
            i += 1
        }
        self.isUserInteractionEnabled = true
    }
    
    func createCounter() {
        self.counter = SKLabelNode(text: "0.00")
        self.counter!.name = "congrats"
        self.counter!.fontColor = SKColor.white
        self.counter!.fontSize = 40
        self.counter!.position = CGPoint(x: self.displaySize.width * 0.5, y: self.displaySize.height * 0.9)
        self.addChild(self.counter!)
    }
    
    
    func increaseScore() {
        self.score = self.score! + 1
        
        var max = 0
        
        if self.typePet == PetType.light {
            max = lightPets!
        }
        
        if self.typePet == PetType.dark {
            max = self.darkPets!
        }
        
        if self.score! >= max - 1 {
            self.finishVictory()
        }
    }
    
    func finishLose() {
        self.removeAllChildren()
        
        typePet = nil
        
        let congrats = SKLabelNode(text: "Errou!")
        congrats.name = "congrats"
        congrats.fontColor = SKColor.white
        congrats.fontSize = 40
        congrats.position = CGPoint(x: self.displaySize.width * 0.5, y: self.displaySize.height * 0.5)
        self.addChild(congrats)
        
        gameOver = true
    }
    
    func finishVictory() {
        self.removeAllChildren()
        
        typePet = nil
        
        let seconds = lround(self.actualTime)
        let str = String(format: "%.2d", seconds)
        
        let congrats = SKLabelNode(text: "Voce ganhou em \(str)s!")
        congrats.name = "congrats"
        congrats.fontColor = SKColor.white
        congrats.fontSize = 40
        congrats.position = CGPoint(x: self.displaySize.width * 0.5, y: self.displaySize.height * 0.5)
        self.addChild(congrats)
        
        guard var previousTime: Int? = UserDefaults.standard.integer(forKey: "time") else {return}
        
        if previousTime == 0 {
            previousTime = 666
        }
        
        if seconds < previousTime! {
            UserDefaults.standard.set(seconds, forKey: "time")
        }
        
        gameOver = true
    }
    
    func backToMenu() {
        
//        print("ACABOU")
        self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }
        
        self.actualTime = currentTime - self.lastUpdateTime
        let str = String(format: "%.2d", lround(self.actualTime))
        self.counter?.text = str
    }
}

extension MiniGame01Scene: PetNodeMiniGameDelegate {
    func didTapPetNode(petNode: PetNodeMiniGame) {
        if self.blocked == false {
            if self.typePet == nil {
                self.typePet = petNode.type
            }
            else if petNode.type == self.typePet {
                self.increaseScore()
            }
            else {
                self.finishLose()
            }
            petNode.removeFromParent()
        }
        else {
            self.blocked = false
        }
    }
}
