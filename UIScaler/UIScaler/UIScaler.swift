import Foundation

public class UIScaler: NSObject {

    public var samples: Samples
    public var extrapBoth: ExtrapolationStyle
    public var extrapLeft: ExtrapolationStyle?
    public var extrapRight: ExtrapolationStyle?
    public var minValue: Double?
    public var maxValue: Double?
    public var shouldRound: Bool

    convenience override init() {
        self.init([:])
    }

    public init(_ samples: Samples,
                extrapBoth: ExtrapolationStyle = .plateau,
                extrapLeft: ExtrapolationStyle? = nil,
                extrapRight: ExtrapolationStyle? = nil,
                minValue: Double? = nil,
                maxValue: Double? = nil,
                shouldRound: Bool = true) {

        self.samples = samples
        self.extrapBoth = extrapBoth
        self.extrapLeft = extrapLeft
        self.extrapRight = extrapRight
        self.minValue = minValue
        self.maxValue = maxValue
        self.shouldRound = shouldRound

        super.init()
    }
}

public extension UIScaler {

    func valueFor(_ queryRefVal: RefVal) -> CGFloat {
        guard !samples.isEmpty else { return 0 }

        let pointSamples = pointsforSamples(samples)
        let f = PiecewiseLinearFunction(samples: pointSamples,
                                        extrapolateLeft: extrapLeft,
                                        extrapolateRight: extrapRight,
                                        extrapolate: extrapBoth,
                                        minY: minValue,
                                        maxY: maxValue)
        let y = CGFloat(f.y(forX: queryRefVal.value))
        return shouldRound ? round(y) : y
    }
}

#if os(iOS)
public extension UIScaler {
    
    var x: CGFloat { valueFor(.val(screenWidth())) }
    var y: CGFloat { valueFor(.val(screenHeight())) }

    func screenWidth() -> Double { UIScaler.screenWidth() }
    func screenHeight() -> Double { UIScaler.screenHeight() }

    static func screenWidth() -> Double { Double(UIScreen.main.bounds.width) }
    static func screenHeight() -> Double { Double(UIScreen.main.bounds.height) }

    static func x(_ samples: Samples,
                  extrapBoth: ExtrapolationStyle,
                  extrapLeft: ExtrapolationStyle?,
                  extrapRight: ExtrapolationStyle?,
                  minValue: Double?,
                  maxValue: Double?,
                  shouldRound: Bool) -> CGFloat {

        UIScaler(samples,
                 extrapBoth: extrapBoth,
                 extrapLeft: extrapLeft,
                 extrapRight: extrapRight,
                 minValue: minValue,
                 maxValue: maxValue,
                 shouldRound: shouldRound).x
    }
}
#endif

public extension UIScaler {

    typealias SampleVal = Double
    typealias Samples = [RefVal: SampleVal]
    typealias ExtrapolationStyle = PiecewiseLinearFunction.ExtrapolationStyle

    enum RefVal: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Hashable {

        public init(floatLiteral value: Double) { self = .val(value) }
        public init(integerLiteral value: Int) { self = .val(Double(value)) }

        case w320 // iPhone 5/s/c, SE
        case w375 // iPhone 6/s, 7, 8, X, XS, 11
        case w414 // iPhone 6+/s+, 7+, 8+, Xr, Xs Max, 11/Pro Max
        case w768 // iPad 7.9", 9.7"
        case w834 // iPad 10.5"
        case w1024 // iPad 12.9"

        case h568 // iPhone 5/s/c, SE
        case h667 // iPhone 6/s, 7, 8
        case h736 // iPhone 6+/s+, 7+, 8+
        case h812 // iPhone X/s, 11 Pro
        case h896 // iPhone Xr, Xs Max, 11, 11 Pro Max
        case h1024 // iPad 7.9", 9.7"
        case h1112 // iPad 10.5"
        case h1366 // iPad 12.9"

        case val(Double)

        public var value: Double {
            switch self {
            case .w320: return 320
            case .w375: return 375
            case .w414: return 414
            case .w768: return 768
            case .w834: return 834
            case .w1024: return 1024

            case .h568: return 568
            case .h667: return 667
            case .h736: return 736
            case .h812: return 812
            case .h896: return 896
            case .h1024: return 1024
            case .h1112: return 1112
            case .h1366: return 1366

            case .val(let x): return x
            }
        }
    }
}

private extension UIScaler {

    typealias Point = PiecewiseLinearFunction.Point

    func value(queryRefVal: RefVal,
               samples: Samples,
               extrapLeft: ExtrapolationStyle?,
               extrapRight: ExtrapolationStyle?,
               extrap: ExtrapolationStyle,
               min: Double?,
               max: Double?,
               shouldRound: Bool) -> CGFloat {

        guard !samples.isEmpty else { return 0 }
        guard samples.count > 1 else { return CGFloat(samples.first!.1) }

        let pointSamples = pointsforSamples(samples)
        let f = PiecewiseLinearFunction(samples: pointSamples,
                                        extrapolateLeft: extrapLeft,
                                        extrapolateRight: extrapRight,
                                        extrapolate: extrap,
                                        minY: min,
                                        maxY: max)
        let y = CGFloat(f.y(forX: queryRefVal.value))
        return shouldRound ? round(y) : y
    }

    func pointsforSamples(_ samples: Samples) -> [Point] {
        samples.map { ($0.value, $1) }
    }
}
