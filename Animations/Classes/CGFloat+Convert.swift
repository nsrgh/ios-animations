import UIKit

extension CGFloat {
    
    func toRadians() -> CGFloat {
        return self * CGFloat.pi / 180
    }
    
    func toDegrees() -> CGFloat {
        return self * 180 / CGFloat.pi
    }
    
    func normalizeDegrees360() -> CGFloat {
        var degrees = self
        while(degrees < 0) {
            degrees += 360
        }
        
        while(degrees >= 360) {
            degrees -= 360
        }
        
        return degrees
    }
    
}
