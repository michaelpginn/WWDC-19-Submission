import Foundation

public class Loop: Equatable{
    public var kicks:[Bool]
    public var hats:[Bool]
    public var snares:[Bool]
    
    public func getSounds(at i:Int)->(kick:Bool, hat:Bool, snare:Bool){
        return (kicks[i], hats[i], snares[i])
    }
    
    public init(kicks:[Bool], hats:[Bool], snares:[Bool]){
        self.kicks = kicks
        self.hats = hats
        self.snares = snares
    }
    
    public convenience init(kicks: UInt16, hats: UInt16, snares:UInt16) {
        self.init(kicks: [], hats: [], snares: [])
        self.kicks = convertToBoolArray(kicks)
        self.hats = convertToBoolArray(hats)
        self.snares = convertToBoolArray(snares)
    }
    
    /**
     Takes a 16 bit number which represents the 2 bar section for a single loop. Each bit in the number is 1 if there is a beat there and 0 if there is not.
     */
    private func convertToBoolArray(_ num : UInt16) -> [Bool]{
        var returnAry:[Bool] = []
        for i in 0..<16{
            returnAry.append(((num >> (15-i)) & 1) > 0)
        }
        return returnAry
    }
    
    public static func == (lhs: Loop, rhs: Loop) -> Bool{
        for i in 0..<16{
            if lhs.kicks[i] != rhs.kicks[i] || lhs.snares[i] != rhs.snares[i] || lhs.hats[i] != rhs.hats[i]{
                return false
            }
        }
        return true
    }
}
