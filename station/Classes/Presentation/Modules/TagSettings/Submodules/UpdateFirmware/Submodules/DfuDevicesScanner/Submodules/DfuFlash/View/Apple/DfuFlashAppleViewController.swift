import Foundation
import UIKit

class DfuFlashAppleViewController: UIViewController, DfuFlashViewInput {
    var output: DfuFlashViewOutput!
    var viewModel = DfuFlashViewModel()
    var dfuFlashState: DfuFlashState = .packageSelection {
        didSet {
            DispatchQueue.main.async {
                self.syncUIs()
            }
        }
    }
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var documentPickerButton: UIButton!

    @IBOutlet weak var flashView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var logTableView: UITableView!

    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    private var flashLogs: [DfuLog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logTableView.tableFooterView = UIView()
        logTableView.rowHeight = UITableView.automaticDimension
        setupLocalization()
        bindViewModel()
        output.viewDidLoad()
    }

    func localize() {
        self.title = "DfuFlash.Title.text".localized()
        
    }
}

// MARK: - IBOutlet
extension DfuFlashAppleViewController {
    @IBAction func documentPickerButtonAction(_ sender: UIButton) {
        output.viewDidOpenDocumentPicker(sourceView: sender)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        output.viewDidCancelFlash()
    }

    @IBAction func startButtonAction(_ sender: Any) {
        output.viewDidStartFlash()
    }
    
    @IBAction func startOverButtonAction(_ sender: Any) {
        output.viewDidStartOver()
    }
    
    @IBAction func finishButtonAction(_ sender: Any) {
        output.viewDidFinishFlash()
    }
}

// MARK: - UITableViewDataSource
extension DfuFlashAppleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashLogs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: DfuLogTableViewCell.self, for: indexPath)
        let flashLog = flashLogs[indexPath.row]
        cell.messageLabel.text = flashLog.message
        cell.messageLabel.backgroundColor = indexPath.row % 2 == 0
            ? UIColor.lightGray.withAlphaComponent(0.5)
            : .clear
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DfuFlashAppleViewController: UITableViewDelegate {
}

// MARK: - UI
extension DfuFlashAppleViewController {
    private func syncUIs() {
        guard isViewLoaded else {
            return
        }
        switch dfuFlashState {
        case .completed:
            selectionView.isHidden = true
            flashView.isHidden = true
            successView.isHidden = false
        case .uploading,
             .readyForUpload:
            selectionView.isHidden = true
            flashView.isHidden = false
            successView.isHidden = true
        default:
            selectionView.isHidden = false
            flashView.isHidden = true
            successView.isHidden = true
        }
        if let index = DfuFlashState.allCases.firstIndex(of: dfuFlashState) {
            stepLabel.text = "Step \(index + 1)/\(DfuFlashState.allCases.count): \(dfuFlashState.rawValue)"
        }
    }
    
    private func bindViewModel() {
        progressView.bind(viewModel.flashProgress) { v, progress in
            v.setProgress(progress ?? 0, animated: progress != nil)
        }
        
        logTableView.bind(viewModel.flashLogs) {[weak self] tableView, logs in
            self?.flashLogs = logs ?? []
            tableView.reloadData()
            if let logs = logs {
                tableView.scrollToRow(at: IndexPath(row: logs.count - 1, section: 0),
                                      at: .bottom,
                                      animated: true)
            }
        }
    }
}
