//: ## Welcome to mini_studio
//: The goal of this playground is to introduce the user to basic drum sequencing and loop making.
//: 
//: There are seven challenges and a free play mode, where each challenge consists of a drum loop being played and the player using the simple sequencer to match it.

import UIKit
import SpriteKit
import PlaygroundSupport


let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 700, height: 550))
if let scene = MainMenuScene(fileNamed: "MainMenu.sks"){
    scene.scaleMode = .resizeFill
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true

//: ## Sequencer Instructions
//: Click on a box in the sequencer to turn it on, placing a drum beat at that point.
//:
//: There are four quarter notes in a single bar (phrase). Each quarter note can be broken into two eigth notes, giving a total of 8 eight notes in a bar.
//:
//: The three main drums are kicks, hi hats (cymbals), and snares.
//:
//: Click on "Test" to try your drum loop. Click on "Hear goal" to replay the target drum loop.

//: ### Sources
//: [icons8.com](https://icons8.com) for icons
//:
//: [u/Geo747 on Reddit](https://www.reddit.com/r/edmproduction/comments/4ew9ut/free_sample_pack_of_my_acoustic_drum_kit_real/) for drums
