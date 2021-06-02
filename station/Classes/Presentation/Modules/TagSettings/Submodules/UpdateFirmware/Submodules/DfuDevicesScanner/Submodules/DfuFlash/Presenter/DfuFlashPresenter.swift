import Foundation
import RuuviOntology
import iOSDFULibrary

class DfuFlashPresenter: DfuFlashModuleInput {
    weak var view: DfuFlashViewInput!
    var router: DfuFlashRouter!
    
    var ruuviDfu: RuuviDfu!
    var filePresener: DfuFilePickerPresenter!
    var errorPresenter: ErrorPresenter!

    private var dfuDevice: DfuDevice!
    private var dfuFlashState: DfuFlashState! {
        didSet {
            view.dfuFlashState = dfuFlashState
        }
    }
    private var selectedFirmware: DFUFirmware?

    func configure(dfuDevice: DfuDevice) {
        self.dfuDevice = dfuDevice
    }
}

// MARK: - DfuFlashViewOutput
extension DfuFlashPresenter: DfuFlashViewOutput {
    func viewDidLoad() {
        dfuFlashState = .packageSelection
    }
    
    func viewDidOpenDocumentPicker(sourceView: UIView) {
        filePresener.delegate = self
        filePresener.pick(sourceView: sourceView)
    }
    
    func viewDidCancelFlash() {}

    func viewDidStartFlash() {
        guard let firmware = selectedFirmware else {
            return
        }
        dfuFlashState = .uploading
        ruuviDfu.flashFirmware(device: dfuDevice, with: firmware, output: self)
    }
    
    func viewDidStartOver() {}
    func viewDidFinishFlash() {}
}

// MARK: - DfuFilePickerPresenterDelegate
extension DfuFlashPresenter: DfuFilePickerPresenterDelegate {
    func dfuFilePicker(presenter: DfuFilePickerPresenter, didPick fileUrl: URL) {
        guard let firmware = ruuviDfu.firmwareFromUrl(url: fileUrl) else {
            errorPresenter.present(error: RuuviDfuError.invalidFirmwareFile)
            return
        }
        
        dfuFlashState = .readyForUpload
        selectedFirmware = firmware
        addNewLog(log: firmware.log)
    }
    
    private func addNewLog(log: DfuLog) {
        var logs = view.viewModel.flashLogs.value ?? []
        logs.append(log)
        view.viewModel.flashLogs.value = logs
    }
}

extension DfuFlashPresenter: DfuFlasherOutputProtocol {
    func ruuviDfuDidUpdateProgress(percentage: Float) {
        view.viewModel.flashProgress.value = percentage
    }

    func ruuviDfuDidUpdateLog(log: DfuLog) {
        addNewLog(log: log)
    }

    func ruuviDfuDidFinish() {
        dfuFlashState = .completed
    }
    
    func ruuviDfuError(error: Error) {
        errorPresenter.present(error: error)
    }
}
