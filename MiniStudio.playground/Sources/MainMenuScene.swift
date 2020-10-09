import Foundation
import SpriteKit
import AVFoundation

public class MainMenuScene : SKScene{
    let COMP_LEVELS_KEY = "completedLevels"
    var compLevels:Int = 0
    
    let bg1 = SKSpriteNode(texture: SKTexture(imageNamed: "bg.png"))
    let bg2 = SKSpriteNode(texture: SKTexture(imageNamed: "bg.png"))
    
    var musicPlayer: AVAudioPlayer?
    
    public override func didMove(to view: SKView) {
        setupDefaults()
        createChallengeButtons()
        
        playMusic()
        
        bg1.position = CGPoint(x: 0, y: 0)
        bg1.zPosition = -10
        addChild(bg1)
        
        bg2.position = CGPoint(x: -770, y: 0)
        bg2.zPosition = -10
        addChild(bg2)
    }
    
    private func createChallengeButtons(){
        let titles = ["Tut.", "1", "2", "3", "4", "5", "6", "Free"]
        let xPos:[CGFloat] = [-240, -80, 80, 240]
        let yPos:[CGFloat] = [-52.7, -187.3]
        
        let challenges = Challenge.generateChallenges()
        
        for i in 0..<titles.count{
            //create node
            var action:()->Void
            if i == 0{
                //tutorial
                action = {
                    if let scene = TutorialScene(fileNamed: "Tutorial.sks"){
                        scene.scaleMode = .resizeFill
                        scene.challenge = challenges[0]
                        self.musicPlayer?.stop()
                        self.view!.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.5))
                    }
                }
            }else{
                action = {
                    if let scene = SequencerScene(fileNamed: "Sequencer.sks"){
                        scene.scaleMode = .resizeFill
                        if i<challenges.count{
                            scene.challenge = challenges[i]
                        }
                        scene.level = i
                        self.musicPlayer?.stop()
                        self.view!.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.5))
                    }
                }
            }
            
            let completed = (((compLevels >> (7-i)) & 1) > 0) && i<7
            let node = ChallengeButtonSpriteNode(title:titles[i], completed: completed, action: action)
            node.position = CGPoint(x: xPos[i % 4], y: yPos[i / 4])
            node.isUserInteractionEnabled = true
            
            addChild(node)
        }
    }
    
    private func setupDefaults(){
        let defaults = UserDefaults.standard
        let comp = defaults.integer(forKey: COMP_LEVELS_KEY)
        
        if comp == 0{
            //create
            //completedLevels has the format of an 8 bit integer, where each bit represents a level (0 for not completed, 1 for completed)
            //the last bit is 1 to denote that the int has been initialized
            defaults.set(1, forKey: COMP_LEVELS_KEY)
            compLevels = 1
        }else{
            compLevels = comp
        }
        
    }
    
    //loop bg
    override public func update(_ currentTime: TimeInterval) {
        self.bg1.position = CGPoint(x: bg1.position.x + 2, y: bg1.position.y)
        self.bg2.position = CGPoint(x: bg2.position.x + 2, y: bg2.position.y)
        
        if(bg1.position.x >= 770){
            bg1.position = CGPoint(x: -770, y: bg1.position.y)
        }
        if(bg2.position.x >= 770){
            bg2.position = CGPoint(x: -770, y: bg2.position.y)
        }
    }
    
    private func playMusic(){
        if let path = Bundle.main.path(forResource: "wwdc19", ofType: "mp3") {
            let filePath = NSURL(fileURLWithPath:path)
            musicPlayer = try? AVAudioPlayer.init(contentsOf: filePath as URL)
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.prepareToPlay()
            musicPlayer?.volume = 0.3
            musicPlayer?.play()
        }
    }
}


