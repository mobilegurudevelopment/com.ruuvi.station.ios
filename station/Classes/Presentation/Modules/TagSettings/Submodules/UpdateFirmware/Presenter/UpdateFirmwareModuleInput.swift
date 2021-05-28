import Foundation

protocol UpdateFirmwareModuleInput: AnyObject {
    func configure(ruuviTag: RuuviTagSensor)
}
