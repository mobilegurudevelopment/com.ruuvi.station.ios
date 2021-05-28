import Foundation
import LightRoute

class UpdateFirmwareRouter: UpdateFirmwareRouterInput {
    weak var transitionHandler: TransitionHandler!

    func dismiss() {
        try! transitionHandler.closeCurrentModule().perform()
    }

    func openFlashFirmware(_ ruuviTag: RuuviTagSensor) {

    }
}
