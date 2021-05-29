import Foundation

protocol UpdateFirmwareRouterInput: AnyObject {
    func dismiss()
    func openDfuDevicesScanner(_ ruuviTag: RuuviTagSensor)
}
