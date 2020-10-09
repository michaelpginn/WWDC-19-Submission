import Foundation
import SpriteKit

public enum BarColor{
    case Grey
    case Blue
}

public class DrumStepNode : SKSpriteNode{
    private var step_off:SKTexture?
    private let step_on:SKTexture = SKTexture(imageNamed: "step_on")
    public var drum:Drum?
    
    public var delegate:StepDelegate?
    
    public var enabled:Bool = false{
        didSet{
            if enabled{
                self.texture = step_on
            }else{
                self.texture = step_off
            }
        }
    }
    public var col:BarColor = .Grey
    
    
    public init(color:BarColor){
        col = color
        let texture = SKTexture(imageNamed: color == .Grey ? "stepA_off" : "stepB_off")
        step_off = texture
        super.init(texture: texture, color: .clear, size: CGSize(width: 29, height: 71))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if self.contains(touch.location(in: self.scene!)){
            enabled = !enabled
            //play sound when turned on
            if enabled, let del = delegate, let drum = drum{
                del.stepTurnedOn(sound: drum)
            }
        }
    }
}
