import Foundation
import LightRoute

class DfuDevicesScannerRouter: DfuDevicesScannerRouterInput {
    weak var transitionHandler: TransitionHandler!

    func dismiss() {
        try! transitionHandler.closeCurrentModule().perform()
    }

    func openFlashFirmware(_ ruuviTag: RuuviTagSensor) {

    }
}
