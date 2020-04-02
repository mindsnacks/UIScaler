public class PiecewiseLinearFunction {

    public init(samples: [Point],
                extrapolateLeft: ExtrapolationStyle? = nil,
                extrapolateRight: ExtrapolationStyle? = nil,
                extrapolate: ExtrapolationStyle = .tangent,
                minY: Double? = nil,
                maxY: Double? = nil) {
        self.sections = PiecewiseLinearFunction.createSections(withSamplePoints: samples)
        self.extrapolationLeft = extrapolateLeft ?? extrapolate
        self.extrapolationRight = extrapolateRight ?? extrapolate
        self.minY = minY
        self.maxY = maxY
    }

    public func y(forX x: Double) -> Double { return _y(forX: x) }

    public typealias Point = (Double, Double)

    public enum ExtrapolationStyle {
        case tangent
        case plateau
        case slope(Double)
        case slopeFromOrigin
        case value(Double)
    }

    private let sections: [PiecewiseLinearFunctionSection]
    private let extrapolationLeft: ExtrapolationStyle
    private let extrapolationRight: ExtrapolationStyle
    private let minY: Double?
    private let maxY: Double?
}

private extension PiecewiseLinearFunction {
    static func assertIntegrity(ofSamplePoints samplePoints: [Point]) {
        guard samplePoints.count >= 2 else { fatalError("Must have at least 2 sample points") }
        let set = Set(samplePoints.map { $0.0 })
        guard set.count == samplePoints.count else { fatalError("Given sample points with duplicate x values") }
    }

    static func sortedPoints(forPoints points: [Point]) -> [Point] {
        return points.sorted(by: { $0.0 < $1.0 })
    }

    static func createSections(withSamplePoints samplePoints: [Point]) -> [PiecewiseLinearFunctionSection] {
        PiecewiseLinearFunction.assertIntegrity(ofSamplePoints: samplePoints)
        let sortedPoints = PiecewiseLinearFunction.sortedPoints(forPoints: samplePoints)
        let initialValue: ([PiecewiseLinearFunctionSection], Point?) = ([], nil)

        let (sections, _) = sortedPoints.reduce(initialValue, { arrayAndNullablePreviousPoint, currentPoint in
            let (array, nullablePreviousPoint) = arrayAndNullablePreviousPoint
            guard let previousPoint = nullablePreviousPoint else { return (array, currentPoint) }

            let section = PiecewiseLinearFunctionSection(startingPoint: previousPoint, endingPoint: currentPoint)
            return (array + [section], currentPoint)
        })

        return sections
    }

    func section(forX x: Double) -> PiecewiseLinearFunctionSection? {
        guard let section = sections.first(where: { $0.contains(x: x) }) else { return nil }
        return section
    }

    func _y(forX x: Double) -> Double {
        if let section = self.section(forX: x) {
            guard let y = section.y(forX: x) else { fatalError("section with edge points: \(section.startingPoint), "
                                                             + "\(section.endingPoint) doesn't contain x value: \(x)") }
            return limitedYValue(forYValue: y)
        }

        let firstSection = self.firstSection()
        let lastSection = self.lastSection()
        let isExtrapolatingLeft = (x < firstSection.startingX)
        let boundarySection = (isExtrapolatingLeft ? firstSection : lastSection)
        let initialPoint = (isExtrapolatingLeft ? firstSection.startingPoint : lastSection.endingPoint)
        let extrapolationStyle = (isExtrapolatingLeft ? extrapolationLeft : extrapolationRight)

        var slope: Double!
        switch extrapolationStyle {
        case .tangent:
            slope = boundarySection.slope
        case .plateau:
            slope = 0
        case .slope(let customSlope):
            slope = customSlope
        case .slopeFromOrigin:
            slope = initialPoint.1 / initialPoint.0
        case .value(let value):
            return limitedYValue(forYValue: value)
        }

        return extrapolateY(targetX: x, slope: slope, initialPoint: initialPoint)
    }

    func firstSection() -> PiecewiseLinearFunctionSection {
        guard let section = sections.first else { fatalError("sections is empty") }
        return section
    }

    func lastSection() -> PiecewiseLinearFunctionSection {
        guard let section = sections.last else { fatalError("sections is empty") }
        return section
    }

    func extrapolateY(targetX: Double,
                      slope: Double,
                      initialPoint: Point) -> Double {
        let y = initialPoint.1 + slope * (targetX - initialPoint.0)
        return limitedYValue(forYValue: y)
    }

    func limitedYValue(forYValue y: Double) -> Double {
        return yValueLimitedBy(y: y, minY: minY, maxY: maxY)
    }

    func yValueLimitedBy(y: Double, minY: Double?, maxY: Double?) -> Double {
        guard maxY == nil || minY == nil || minY! <= maxY! else { fatalError() }
        var limitedY = y
        if let maxY = maxY { limitedY = min(limitedY, maxY) }
        if let minY = minY { limitedY = max(limitedY, minY) }
        return limitedY
    }
}

private class PiecewiseLinearFunctionSection {
    typealias Point = PiecewiseLinearFunction.Point

    init(startingPoint: Point, endingPoint: Point) {
        self.startingPoint = startingPoint
        self.endingPoint = endingPoint
        assertIntegrityOfPoints()
    }

    func contains(x: Double) -> Bool {
        return x >= startingX && x <= endingX
    }

    func y(forX x: Double) -> Double? {
        guard contains(x: x) else { return nil }
        let deltaX = x - startingPoint.0
        let deltaY = slope * deltaX
        return startingPoint.1 + deltaY
    }

    func assertIntegrityOfPoints() {
        let errorMessage = "PiecewiseLinearFunctionSection failed check `startingPoint.x < endingPoint.x` "
        guard startingPoint.0 < endingPoint.0 else { fatalError(errorMessage) }
    }

    var slope: Double { return (endingPoint.1 - startingPoint.1) / (endingPoint.0 - startingPoint.0) }
    var startingX: Double { return startingPoint.0 }
    var endingX: Double { return endingPoint.0 }
    let startingPoint: Point
    let endingPoint: Point
}
