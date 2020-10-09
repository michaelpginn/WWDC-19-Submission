import Foundation
import SpriteKit

public class TutorialScene:SKScene{
    var okayButton:SKLabelNode?
    public var challenge : Challenge?
    
    public override func didMove(to view: SKView) {
        okayButton = self.childNode(withName: "okayButton") as? SKLabelNode
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        if okayButton?.contains(touch.location(in: self)) ?? false{
            okayButton?.alpha = 0.7
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        okayButton?.alpha = 1.0
        guard let touch = touches.first else{return}
        if okayButton?.contains(touch.location(in: self)) ?? false{
            if let scene = SequencerScene(fileNamed: "Sequencer.sks"){
                scene.scaleMode = .resizeFill
                scene.level = 0
                scene.challenge = challenge
                self.view!.presentScene(scene)
            }
        }
    }
}
