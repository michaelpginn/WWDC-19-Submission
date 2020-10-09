import Foundation
import SpriteKit
import AVFoundation

public protocol StepDelegate{
    func stepTurnedOn(sound:Drum)
}

public enum Drum{
    case Kick
    case Snare
    case Hat
}

public class SequencerScene : SKScene, StepDelegate, PopupNodeDelegate{
    
    private var timer:Timer?
    private var timerTick = 0
    private let TIMER_DELTA = 0.2
    
    private var backButton:SKSpriteNode?
    private var playButton:SKSpriteNode?
    private var demoButton:SKSpriteNode?
    private var titleLabel:SKLabelNode?
    private var instructionsLabel:SKLabelNode?
    private var steps:[DrumStepNode] = []
    private var playhead:SKSpriteNode?
    
    private var touchedNode:SKSpriteNode?
    
    public var level:Int = -1
    public var challenge:Challenge? //holds the demo loop, instructions, etc
    
    let kickAction = SKAction.playSoundFileNamed("RD_K_2.wav", waitForCompletion: false)
    let hatAction = SKAction.playSoundFileNamed("RD_C_HH_7.wav", waitForCompletion: false)
    let snareAction = SKAction.playSoundFileNamed("RD_S_4.wav", waitForCompletion: false)
    
    //MARK: Setup
    
    public override func didMove(to view: SKView) {
        setupSeq()
        setupControls()
        //play loop
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            if let loop = self.challenge?.loop{
                self.playLoop(loop)
            }
            timer.invalidate()
        }
        
    }
    
    private func setupSeq(){
        var drum:Drum
        for i in 0...48{
            var y:CGFloat = 0
            if(i/16 == 0){
                y = 77.5
                drum = .Kick
            }else if(i/16 == 1){
                y = -63.5
                drum = .Hat
            }else{
                y = -204.5
                drum = .Snare
            }
            
            let x:CGFloat = -225.5 + (CGFloat(i%16) * 36.0)
            let color:BarColor = ((i/4) % 2 ) == 0 ? .Grey : .Blue
            let step = DrumStepNode(color: color)
            step.drum = drum
            step.position = CGPoint(x: x, y: y);
            step.isUserInteractionEnabled = true
            step.delegate = self
            addChild(step)
            steps.append(step)
        }

        //draw playhead
        
        let texture = SKTexture(imageNamed: "playhead.png")
        let playhead = SKSpriteNode(texture: texture)
        playhead.position = CGPoint(x: -247, y: -63.5)
        playhead.zPosition = 50
        addChild(playhead)
        self.playhead = playhead
        
    }
    
    private func setupControls(){
    
        backButton = childNode(withName: "backButton") as? SKSpriteNode
        playButton = childNode(withName: "playButton") as? SKSpriteNode
        demoButton = childNode(withName: "demoButton") as? SKSpriteNode
        titleLabel = childNode(withName: "titleLabel") as? SKLabelNode
        instructionsLabel = childNode(withName: "instructionsLabel") as? SKLabelNode
        instructionsLabel?.horizontalAlignmentMode = .left
        instructionsLabel?.verticalAlignmentMode = .top
        instructionsLabel?.position = CGPoint(x: -320, y: 206)
        instructionsLabel?.text = challenge?.instructions ?? ""
        if self.level == 0{
            titleLabel?.text = "Tutorial"
        }else if self.level == 7{
            titleLabel?.text = "Free play"
            demoButton?.alpha = 0
            demoButton?.isUserInteractionEnabled = false
        }else{
            titleLabel?.text = "Challenge \(self.level)"
        }
    }
    
    func showCompletion(){
        
        //mark to defaults
        let defaults = UserDefaults.standard
        var compLevels = defaults.integer(forKey: "completedLevels")
        if level >= 0 && (((compLevels >> (7-level)) & 1) <= 0){
            //level not already completed
            compLevels += (1 << (7-level))
        }
        defaults.set(compLevels, forKey:"completedLevels")
        
        //show alert view
        let popup = PopupNode(description: self.challenge?.postText ?? "")
        popup.delegate = self
        addChild(popup)
    }
    
    //For PopupNodeDelegate
    public func homeButtonTouched() {
        if let scene = MainMenuScene(fileNamed: "MainMenu.sks"){
            scene.scaleMode = .resizeFill
            self.view!.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.5))
        }
    }
    
    //MARK: Sound playing
    private func playSound(sound:Drum){
        switch(sound){
        case .Kick:
            self.run(kickAction)
        case .Snare:
            self.run(snareAction)
        case .Hat:
            self.run(hatAction)
        }
    }
    
    public func stepTurnedOn(sound: Drum) {
        playSound(sound: sound)
    }
    
    private func playLoop(_ loop:Loop, shouldFinish:Bool = false){
        timerTick = 0
        timer?.invalidate()
        demoButton?.texture = SKTexture(imageNamed: "playingButton.png")
        
        timer = Timer.scheduledTimer(withTimeInterval: TIMER_DELTA, repeats: true) { (timer) in
            //play sounds for this tick
            let sounds = loop.getSounds(at: self.timerTick)
            if sounds.kick{
                self.run(SKAction.playSoundFileNamed("RD_K_2.wav", waitForCompletion: false))
            }
            if sounds.hat{
                self.run(SKAction.playSoundFileNamed("RD_C_HH_7.wav", waitForCompletion: false))
            }
            if sounds.snare{
                self.run(SKAction.playSoundFileNamed("RD_S_4.wav", waitForCompletion: false))
            }
            self.timerTick += 1
            if self.timerTick >= 16{
                self.timerTick = 0
                self.timer?.invalidate()
                self.demoButton?.texture = SKTexture(imageNamed: "playsoundbutton.png")

                if shouldFinish{
                    self.showCompletion()
                }
                            }
        }
    }
    
    private func runCurrentLoop(){
        var kicks:[Bool] = []
        var hats:[Bool] = []
        var snares:[Bool] = []
        for i in 0..<steps.count{
            let on = steps[i].enabled
            if i/16 == 0{
                kicks.append(on)
            }else if i/16 == 1{
                hats.append(on)
            }else{
                snares.append(on)
            }
        }
        let loop = Loop(kicks: kicks, hats: hats, snares: snares)
        let correct = challenge?.loop != nil && loop == challenge!.loop!
        
        //animate playhead
        let moveAction = SKAction.sequence([
            SKAction.moveTo(x: 345, duration: TIMER_DELTA * 16),
            SKAction.run {
                self.playhead?.position = CGPoint(x: -247, y: -63.5)
            }
            ])
        playhead?.run(moveAction)
        
        playLoop(loop, shouldFinish: correct)
    }
    
    
    //MARK: Touch management
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let loc = touch.location(in: self)
        for node in [backButton, playButton, demoButton]{
            if node?.contains(loc) ?? false{
                node?.alpha = 0.6
                touchedNode = node
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for node in [backButton, playButton, demoButton]{
            node?.alpha = 1.0
        }
        guard let touch = touches.first else{return}
        let loc = touch.location(in: self)
        
        //actions for buttons
        guard touchedNode != nil else{return}
        if touchedNode == backButton && backButton!.contains(loc){
            if let scene = MainMenuScene(fileNamed: "MainMenu.sks"){
                scene.scaleMode = .resizeFill
                self.view!.presentScene(scene, transition: SKTransition.crossFade(withDuration: 0.5))
            }
        }else if touchedNode == playButton && playButton!.contains(loc){
            runCurrentLoop()
        }else if touchedNode == demoButton && demoButton!.contains(loc){
            print("playing demo")
            if let loop = challenge?.loop{
                playLoop(loop)
            }
        }
        
        touchedNode = nil
    }
}
