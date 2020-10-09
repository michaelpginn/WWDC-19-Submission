import Foundation
import SpriteKit

public class ChallengeButtonSpriteNode : SKSpriteNode {
    enum ActionType{
        case TouchUpInside
        case TouchDownInside
        case TouchUpOutside
    }
    
    private var titleLabel:SKLabelNode?
    private var borderShape:SKShapeNode?
    var title:String?
    public var action:(()->Void)?
    public var completed = false
    
    private let GREY_COL = UIColor(displayP3Red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 0.80)
    
    public func setTitle(_ title:String){
        self.title = title
        if title.count > 2{
            titleLabel?.fontSize = 35
        }else{
            titleLabel?.fontSize = 50
        }
        titleLabel?.text = title
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public init(title:String) {
        super.init(texture: nil, color: GREY_COL, size: CGSize(width: 100, height: 100))
        setup()
        setTitle(title)
    }
    
    public init(title:String, completed:Bool, action:@escaping ()->Void){
        super.init(texture: nil, color: GREY_COL, size: CGSize(width: 100, height: 100))
        self.completed = completed
        setup()
        setTitle(title)
        self.action = action
        
    }
    
    private func setup(){
        //add label
        let label = SKLabelNode(fontNamed: "SF UI Text Light")
        label.fontSize = 50.0
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        addChild(label)
        self.titleLabel = label
        
        //add border
        let shapeNode = SKShapeNode(rect: frame, cornerRadius: 2.0)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = .white
        shapeNode.lineWidth = 2.0
        addChild(shapeNode)
        self.borderShape = shapeNode
        
        let blueCol = UIColor(displayP3Red: 52/255.0, green: 52/255.0, blue: 72/255.0, alpha: 1.0)
        let greyCol = UIColor(displayP3Red: 152/255.0, green: 152/255.0, blue: 157/255.0, alpha: 1.0)
        if !completed{
            label.fontColor = blueCol
            shapeNode.strokeColor = blueCol
        }else{
            
            label.fontColor = greyCol
            shapeNode.strokeColor = greyCol
        }
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        borderShape?.xScale = 0.95
        borderShape?.yScale = 0.95
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        borderShape?.xScale = 1.0
        borderShape?.yScale = 1.0
        
        let touch = touches.first!
        if self.contains(touch.location(in: self.scene!)){
            //run method
            action?()
        }
    }
}
