import Foundation
import RuuviOntology

protocol DfuDevicesScannerRouterInput: AnyObject {
    func dismiss()
    func openFlashFirmware(_ ruuviTag: RuuviTagSensor)
}
