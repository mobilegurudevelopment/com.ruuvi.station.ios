import Foundation

protocol DfuDevicesScannerModuleInput: AnyObject {
    func configure(ruuviTag: RuuviTagSensor)
}
