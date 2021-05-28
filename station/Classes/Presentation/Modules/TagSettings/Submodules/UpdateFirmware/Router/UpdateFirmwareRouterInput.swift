import Foundation

protocol UpdateFirmwareRouterInput: AnyObject {
    func dismiss()
    func openFlashFirmware(_ ruuviTag: RuuviTagSensor)
}
