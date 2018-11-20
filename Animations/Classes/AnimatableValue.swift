import UIKit

public class AnimatableValue {
    
    public init() {
    }
    
    public init(value: CGFloat) {
        self.value = value
    }
    
    public var viewForInvalidate: UIView? = nil
    public var actionForInvalidate: (()->Void)? = nil
    
    private (set) public var currentValue: CGFloat = 0 {
        didSet {
            if let viewForInvalidate = self.viewForInvalidate {
                viewForInvalidate.setNeedsDisplay()
            }
            
            actionForInvalidate?()
        }
    }
    
    private var targetValue: CGFloat = 0
    
    public var value: CGFloat {
        get {
            return targetValue
        }
        set {
            cancel()
            self.targetValue = newValue
            self.currentValue = newValue
        }
    }
    
    public var animating: Bool {
        get {
            return self.animator != nil
        }
    }
    
    public func animate(to value: CGFloat, duration: Double = 0.3, easing: @escaping EasingFunction = CubicEaseInOut, completion: (()->Void)? = nil) {
        self.animate(to: value, timing: .duration(duration: duration), easing: easing, completion: completion)
    }
    
    public func animate(to value: CGFloat, timing: Timing, easing: @escaping EasingFunction, completion: (()->Void)? = nil) {
        cancel()
        
        self.targetValue = value
        
        let duration: Double
        switch timing {
        case .duration(duration: let d):
            duration = d
            break
        case .speed(unitDuration: let unitDuration):
            let units = Double(abs(self.targetValue - self.currentValue))
            duration = units * unitDuration
            break
        }
        
        self.animator = Animator(
            from: currentValue,
            to: targetValue,
            duration: duration,
            easing: easing,
            onTick: { [unowned self] value in
                self.currentValue = value
            },
            onCompleted: { [unowned self] ok in
                self.animator = nil
                if ok {
                    completion?()
                }
            }
        )
        self.animator?.start()
    }
    
    public func change(value: CGFloat, animated: Bool, completion: (()->Void)? = nil) {
        if animated {
            animate(to: value, completion: completion)
        } else {
            self.value = value
            completion?()
        }
    }
    
    public func cancel() {
        animator?.cancel()
        animator = nil
    }
    
    private var animator: Animator? = nil
}
