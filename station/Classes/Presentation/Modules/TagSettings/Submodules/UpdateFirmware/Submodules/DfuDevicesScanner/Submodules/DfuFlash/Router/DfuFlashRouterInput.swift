import Foundation
import RuuviOntology

protocol DfuFlashRouterInput: AnyObject {
    func dismiss()
    func openDfuDevicesScanner(_ ruuviTag: RuuviTagSensor)
}
