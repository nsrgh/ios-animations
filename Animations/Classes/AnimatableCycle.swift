import UIKit

class AnimatableCycle {
    
    private var animatableValue : AnimatableValue
    private var states : [CGFloat]
    private var index = 0
    private var isAnimating : Bool = false
    
    public var currentValueChanged: (()->Void)? = nil {
        didSet {
            animatableValue.actionForInvalidate = currentValueChanged
        }
    }
    
    public var currentValue: CGFloat {
        return animatableValue.currentValue
    }
    
    init(states : CGFloat...) {
        self.states = states
        self.animatableValue = AnimatableValue(value: states[0])
    }
    
    
    public func animate(stepDuration: Double = 0.3,  needRepeat: Bool = true, easing: @escaping EasingFunction = CubicEaseInOut) {
        self.animate(timing: .duration(duration: stepDuration), needRepeat: needRepeat, easing: easing)
    }
    
    public func animate(timing: Timing, needRepeat: Bool = true, easing: @escaping EasingFunction) {
        cancel()
        
        isAnimating = true
        
        next(timing: timing, needRepeat: needRepeat, easing: easing)
    }
    
    private func next(timing: Timing, needRepeat: Bool = true, easing: @escaping EasingFunction) {
        
        if (!isAnimating) {
            return
        }
        
        if (index == states.count - 1) {
            if (!needRepeat) {
                cancel()
                return
            }
            index = 0
        } else {
            index += 1
        }
        
        animatableValue.animate(to: states[index], timing: timing, easing: easing, completion: {
            self.next(timing: timing, needRepeat: needRepeat, easing: easing)
        })
    }
    
    public func cancel() {
        isAnimating = false
        animatableValue.cancel()
        index = 0
        animatableValue.change(value: states[index], animated: false)
    }
    
}
