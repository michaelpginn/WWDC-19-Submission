import Foundation

public class Challenge{
    public var loop:Loop?
    public var instructions:String
    public var postText:String
    
    init(loop:Loop?, instructions: String, post: String){
        self.loop = loop
        self.instructions = instructions
        self.postText = post
    }
}

extension Challenge{
    class public func generateChallenges()->[Challenge]{
        var c:[Challenge] = []
        
        let tutorialLoop = Loop(kicks: 0x0000, hats: 0xAAAA, snares: 0x0000)
        let tutorial = Challenge(loop: tutorialLoop, instructions: "Match the demo beat you hear! Click boxes to turn them on, and again to turn them off. Click the play button to test.", post: "The hi-hats played were quarter notes, which are the basic building block of a beat.")
        c.append(tutorial)
        
        let c1 = Challenge(loop: Loop(kicks: 0x8080, hats: 0x2A2A, snares: 0x0000), instructions: "Now there's two drums going on! This one builds on the tutorial beat.", post: "Kicks are often on the first beat in a four-quarter-note phrase, known as a bar.")
        c.append(c1)
        
        let c2 = Challenge(loop: Loop(kicks: 0x8080, hats: 0x2222, snares: 0x0808), instructions: "This is a very famous pattern known as \"Boots and Cats\". For it, you'll have to use all three drums.", post: "Now you've used all three drums!")
        c.append(c2)
        
        let c3 = Challenge(loop: Loop(kicks: 0x8280, hats: 0x2022, snares: 0x0808), instructions: "Here's a slight variation on the last one.", post: "It's pretty easy to build off a basic pattern like Boots and Cats.")
        c.append(c3)
        
        let c4 = Challenge(loop: Loop(kicks: 0x80C0, hats: 0x2233, snares: 0x080C), instructions: "This one has faster notes (called eighth notes), but don't worry. You got this!", post: "Eighth notes are twice as fast as quarter notes and let you make more complex rhythms.")
        c.append(c4)
        
        let c5 = Challenge(loop: Loop(kicks: 0x8000, hats: 0x3325, snares: 0x0892), instructions: "Here's a tricky one (but I won't put two drums at the same time, for simplicity).", post: "If you've gotten this far, you're pretty good at this.")
        c.append(c5)
        
        let c6 = Challenge(loop: Loop(kicks: 0x8302, hats: 0x5050, snares: 0x2828), instructions: "Final challenge!", post: "Time to start making some music! ")
        c.append(c6)
        
        let free = Challenge(loop: nil, instructions: "Create to your heart's content!", post: "")
        c.append(free)
        return c
    }
}
