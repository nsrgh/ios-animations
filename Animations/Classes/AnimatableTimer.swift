import UIKit

public class AnimatableTimer {
    public init() {
    }
    
    public init(unitsPerSecond: Double) {
        self.unitsPerSecond = unitsPerSecond
    }
    
    public init(unitDuration: Double) {
        self.unitsPerSecond = 1.0 / unitDuration
    }
    
    public var currentValueChanged: (()->Void)? = nil
    
    private (set) public var currentValue: CGFloat = 0 {
        didSet {
            currentValueChanged?()
        }
    }
    
    private(set) public var animating: Bool = false
    
    private var unitsPerSecond = 1.0;
    
    public func animate() {
        cancel()
        animating = true
        displayLink.paused = false
    }
    
    
    public func cancel() {
        displayLink.paused = true
        animating = false
    }
    
    private lazy var displayLink: DisplayLink = {
        let link = DisplayLink()
        link.callback = { [unowned self] (frame) in
            self.tick(frame: frame)
        }
        return link
    }()
    
    private func tick(frame: DisplayLink.Frame) {
        let newUnits = CGFloat(frame.duration * unitsPerSecond)
        var newValue = currentValue + newUnits
        while newValue >= 1.0 {
            // TODO: call listener
            newValue -= newValue
        }
        self.currentValue = newValue
    }
}
