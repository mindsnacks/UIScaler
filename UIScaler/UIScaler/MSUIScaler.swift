import Foundation

// MARK: - MSUIScaler Class Definition

@objc public class MSUIScaler: NSObject {

    private let scaler = UIScaler()

    @objc public override init() {
        super.init()
    }
}

// MARK: - Public Methods

@objc public extension MSUIScaler {

    func valueFor(x: CGFloat) -> CGFloat {
        scaler.valueFor(.val(Double(x)))
    }
}

#if os(iOS)
@objc public extension MSUIScaler {

    func x() -> CGFloat { scaler.x }
    func y() -> CGFloat { scaler.y }
}
#endif

// MARK: - Public Modifiers

@objc public extension MSUIScaler {

    func addSample(_ sample: MSUIScalerPoint) -> MSUIScaler {
        let refVal: UIScaler.RefVal = .val(Double(sample.reference))
        let sampleVal: Double = Double(sample.sample)
        scaler.samples[refVal] = sampleVal
        return self
    }

    func addSamples(_ samples: [MSUIScalerPoint]) -> MSUIScaler {
        for sample in samples {
            _ = addSample(sample)
        }
        return self
    }

    func setSamples(_ samples: [MSUIScalerPoint]) -> MSUIScaler {
        return clearSamples().addSamples(samples)
    }

    func addMinVal(_ minVal: CGFloat) -> MSUIScaler {
        scaler.minValue = Double(minVal)
        return self
    }

    func addMaxVal(_ maxVal: CGFloat) -> MSUIScaler {
        scaler.maxValue = Double(maxVal)
        return self
    }

    func addShouldRound(_ shouldRound: Bool) -> MSUIScaler {
        scaler.shouldRound = shouldRound
        return self
    }
}

// MARK: - Public Clearing Methods

@objc public extension MSUIScaler {

    func clearSamples() -> MSUIScaler {
        scaler.samples = [:]
        return self
    }

    func clearMinVal() -> MSUIScaler {
        scaler.minValue = nil
        return self;
    }

    func clearMaxVal() -> MSUIScaler {
        scaler.maxValue = nil
        return self;
    }
}

// MARK: - Public Properties

@objc public extension MSUIScaler {

    var minValue: NSNumber? {
         get { scaler.minValue as NSNumber? }
         set { scaler.minValue = newValue?.doubleValue }
     }

     var maxValue: NSNumber? {
         get { scaler.maxValue as NSNumber? }
         set { scaler.maxValue = newValue?.doubleValue }
     }

     var shouldRound: Bool {
         get { scaler.shouldRound }
         set { scaler.shouldRound = newValue }
     }
}

#if os(iOS)
@objc public extension MSUIScaler {

    var screenWidth: CGFloat { CGFloat(scaler.screenWidth()) }
    var screenHeight: CGFloat { CGFloat(scaler.screenHeight()) }
}
#endif

// MARK: - Static Methods

@objc public extension MSUIScaler {

    static func samples(_ samples: [MSUIScalerPoint]) -> MSUIScaler {
        return MSUIScaler().addSamples(samples)
    }
}

#if os(iOS)
@objc public extension MSUIScaler {

    static var screenWidth: CGFloat { CGFloat(UIScaler.screenWidth()) }
    static var screenHeight: CGFloat { CGFloat(UIScaler.screenHeight()) }
}
#endif

// MARK: - MSUIScalerPoint

@objc public class MSUIScalerPoint: NSObject {

    @objc public var reference: CGFloat
    @objc public var sample: CGFloat

    @objc public init(reference: CGFloat,
                      sample: CGFloat) {

        self.reference = reference
        self.sample = sample
        super.init()
    }
}

// MARK: - MSUIScalerConstants

@objc public class MSUIScalerConstants: NSObject {

    @objc public override init() {
        super.init()
    }
}

@objc public extension MSUIScalerConstants {

    var w320: CGFloat { Self.w320 } // iPhone 5/s/c, SE
    var w375: CGFloat { Self.w375 } // iPhone 6/s, 7, 8, X, XS, 11
    var w414: CGFloat { Self.w414 } // iPhone 6+/s+, 7+, 8+, Xr, Xs Max, 11/Pro Max
    var w768: CGFloat { Self.w768 } // iPad 7.9", 9.7"
    var w834: CGFloat { Self.w834 } // iPad 10.5"
    var w1024: CGFloat { Self.w1024 } // iPad 12.9"

    var h568: CGFloat { Self.h568 } // case h568 // iPhone 5/s/c, SE
    var h667: CGFloat { Self.h667 } // case h667 // iPhone 6/s, 7, 8
    var h736: CGFloat { Self.h736 } // case h736 // iPhone 6+/s+, 7+, 8+
    var h812: CGFloat { Self.h812 } // case h812 // iPhone X/s, 11 Pro
    var h896: CGFloat { Self.h896 } // iPhone Xr, Xs Max, 11, 11 Pro Max
    var h1024: CGFloat { Self.h1024 } // iPad 7.9", 9.7"
    var h1112: CGFloat { Self.h1112 } // iPad 10.5"
    var h1366: CGFloat { Self.h1366 } // iPad 12.9"

    static var w320: CGFloat { 320 } // iPhone 5/s/c, SE
    static var w375: CGFloat { 375 } // iPhone 6/s, 7, 8, X, XS, 11
    static var w414: CGFloat { 414 } // iPhone 6+/s+, 7+, 8+, Xr, Xs Max, 11/Pro Max
    static var w768: CGFloat { 768 } // iPad 7.9", 9.7"
    static var w834: CGFloat { 834 } // iPad 10.5"
    static var w1024: CGFloat { 1024 } // iPad 12.9"

    static var h568: CGFloat { 568 } // case h568 // iPhone 5/s/c, SE
    static var h667: CGFloat { 667 } // case h667 // iPhone 6/s, 7, 8
    static var h736: CGFloat { 736 } // case h736 // iPhone 6+/s+, 7+, 8+
    static var h812: CGFloat { 812 } // case h812 // iPhone X/s, 11 Pro
    static var h896: CGFloat { 896 } // iPhone Xr, Xs Max, 11, 11 Pro Max
    static var h1024: CGFloat { 1024 } // iPad 7.9", 9.7"
    static var h1112: CGFloat { 1112 } // iPad 10.5"
    static var h1366: CGFloat { 1366 } // iPad 12.9"
}
