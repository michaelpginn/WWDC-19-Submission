import Foundation
import SpriteKit

public protocol PopupNodeDelegate {
    func homeButtonTouched()
}

public class PopupNode : SKSpriteNode{
    let BLUE_COL = UIColor(displayP3Red: 52/255.0, green: 52/255.0, blue: 72/255.0, alpha: 1.0)
    
    var title: String?
    var desc: String?
    
    var homeButton:SKSpriteNode?
    var homeButtonTouched = false
    
    var delegate:PopupNodeDelegate?
    
    public init(title: String = "Nice beat!", description:String) {
        super.init(texture: nil, color: .clear, size: CGSize(width: 700, height: 550))
        setup()
        self.title = title
        self.desc = description
        createTextNodes()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup(){
        isUserInteractionEnabled = true
        
        let overlay = SKShapeNode(rectOf: self.size)
        overlay.position = CGPoint(x: 0, y: 0)
        overlay.zPosition = 1
        overlay.fillColor = UIColor.white.withAlphaComponent(0.4)
        overlay.isUserInteractionEnabled = true
        addChild(overlay)
        
        let bgNode = SKShapeNode(rectOf: CGSize(width: 400, height: 300), cornerRadius: 10)
        bgNode.position = CGPoint(x: 0, y: 0)
        bgNode.zPosition = 50
        bgNode.strokeColor = BLUE_COL
        bgNode.glowWidth = 1.0
        bgNode.fillColor = UIColor.white.withAlphaComponent(0.97)
        addChild(bgNode)
    }
    
    private func createTextNodes(){
        let titleNode = SKLabelNode(fontNamed: "SF UI Text Light")
        titleNode.text = title
        titleNode.fontSize = 30.0
        titleNode.fontColor = BLUE_COL
        titleNode.horizontalAlignmentMode = .center
        titleNode.verticalAlignmentMode = .center
        titleNode.position = CGPoint(x: 0, y: 80)
        titleNode.zPosition = 60
        addChild(titleNode)
        
        let descNode = SKLabelNode(fontNamed: "SF UI Text Light")
        descNode.text = desc
        descNode.fontSize = 20.0
        descNode.fontColor = UIColor(white: 0.4, alpha: 1.0)
        descNode.horizontalAlignmentMode = .center
        descNode.verticalAlignmentMode = .top
        descNode.position = CGPoint(x: 0, y: 60)
        descNode.numberOfLines = 3
        descNode.preferredMaxLayoutWidth = 350
        descNode.zPosition = 60
        addChild(descNode)
        
        let homeButton = SKSpriteNode(imageNamed: "home_icon.png")
        homeButton.position = CGPoint(x: 0, y: -100)
        homeButton.isUserInteractionEnabled = false
        homeButton.zPosition = 60
        addChild(homeButton)
        self.homeButton = homeButton
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let loc = touch.location(in: self)
        if homeButton?.contains(loc) ?? false{
            homeButton?.alpha = 0.6
            homeButtonTouched = true
        }else{
            homeButtonTouched = false
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        homeButton?.alpha = 1.0
        
        guard homeButtonTouched else{return}
        
        guard let touch = touches.first else{return}
        let loc = touch.location(in: self)
        if homeButton?.contains(loc) ?? false, let del = delegate{
            del.homeButtonTouched()
        }
    }
}
