import Foundation
import UIKit
import CoreBluetooth

class DfuDevicesScannerTableViewController: UITableViewController {
    var output: DfuDevicesScannerViewOutput!

    var isBluetoothEnabled: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.reloadTable()
            }
        }
    }

    var viewModels: [DfuDeviceViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadTable()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()
        output.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillDisappear()
    }

    func localize() {
        self.title = "Devices"
    }

    private func reloadTable() {
        if isViewLoaded {
            tableView.reloadData()
        }
    }
}

// MARK: - DfuDevicesScannerViewInput
extension DfuDevicesScannerTableViewController: DfuDevicesScannerViewInput {
    func showBluetoothDisabled() {
        let title = "DiscoverTable.BluetoothDisabledAlert.title".localized()
        let message = "DiscoverTable.BluetoothDisabledAlert.message".localized()
        showAlert(title: title, message: message)
    }
}

// MARK: - UITableViewDataSource
extension DfuDevicesScannerTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.isEmpty ? 1 : viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModels.isEmpty {
            let cell = tableView.dequeueReusableCell(with: DfuNoDeviceTableViewCell.self, for: indexPath)
            cell.descriptionLabel.text = isBluetoothEnabled
                ? "DiscoverTable.NoDevicesSection.NotFound.text".localized()
                : "DiscoverTable.NoDevicesSection.BluetoothDisabled.text".localized()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(with: DfuDeviceTableViewCell.self, for: indexPath)
            configure(cell: cell, with: viewModels[indexPath.row])
            return cell
        }
    }

    private func configure(cell: DfuDeviceTableViewCell, with viewModel: DfuDeviceViewModel) {
        cell.identifierLabel.text = viewModel.name
        cell.isConnectableImageView.isHidden = !viewModel.isConnectable
        if let rssi = viewModel.rssi {
            cell.rssiLabel.text = "\(rssi)" + " " + "dBm".localized()
            cell.rssiImageView.image = viewModel.rssiImage
        } else {
            cell.rssiImageView.image = nil
            cell.rssiLabel.text = nil
        }
    }
}

// MARK: - UITableViewDelegate
extension DfuDevicesScannerTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !viewModels.isEmpty {
            // TODO: open item
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
