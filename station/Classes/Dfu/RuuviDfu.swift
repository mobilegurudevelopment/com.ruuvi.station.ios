import Foundation

struct RuuviDfu {
    static let shared = RuuviDfu()

    private let scanner = DfuScanner()

    @discardableResult
    func scan<T: AnyObject>(_ observer: T,
                            closure: @escaping (T, DfuDevice) -> Void) -> RUObservationToken {
        return scanner.scan(observer, closure: closure)
    }
}
