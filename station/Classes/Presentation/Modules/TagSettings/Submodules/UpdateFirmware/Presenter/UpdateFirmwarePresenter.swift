import Foundation

class UpdateFirmwarePresenter: UpdateFirmwareModuleInput {
    weak var view: UpdateFirmwareViewInput!
    var router: UpdateFirmwareRouter!

    private var ruuviTag: RuuviTagSensor!

    func configure(ruuviTag: RuuviTagSensor) {
        self.ruuviTag = ruuviTag
    }
}

extension UpdateFirmwarePresenter: UpdateFirmwareViewOutput {
    func viewDidOpenFlashFirmware() {
        router.openFlashFirmware(ruuviTag)
    }
}
