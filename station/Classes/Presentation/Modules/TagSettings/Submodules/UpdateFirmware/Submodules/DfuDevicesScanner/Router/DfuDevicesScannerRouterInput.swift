import Foundation

protocol DfuDevicesScannerRouterInput: AnyObject {
    func dismiss()
    func openFlashFirmware(_ ruuviTag: RuuviTagSensor)
}
