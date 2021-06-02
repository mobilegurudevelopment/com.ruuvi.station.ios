import Foundation
import UIKit
import CoreBluetooth

class DfuScanner: NSObject {
    private let queue = DispatchQueue(label: "DfuScanner", qos: .userInteractive)
    private lazy var manager: CBCentralManager = {
        return CBCentralManager(delegate: self, queue: queue)
    }()

    private var observations = (
        device: [UUID: (DfuDevice) -> Void](),
        list: [UUID: (DfuDevice) -> Void]()
    )

    private let scanServices = [
        CBUUID(string: "00001530-1212-EFDE-1523-785FEABCD123"),
        CBUUID(string: "FE59"),
        CBUUID(string: "180A")
    ]

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.willResignActiveNotification(_:)),
                                               name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didBecomeActiveNotification(_:)),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        queue.async { [weak self] in
            self?.startIfNeeded()
        }
    }

    @objc func willResignActiveNotification(_ notification: Notification) {
        queue.async { [weak self] in
            self?.manager.stopScan()
        }
    }

    @objc func didBecomeActiveNotification(_ notification: Notification) {
        queue.async { [weak self] in
            self?.startIfNeeded()
        }
    }

    private func startIfNeeded() {
        if manager.state == .poweredOn && !manager.isScanning {
            manager.scanForPeripherals(withServices: scanServices,
                                       options: [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: true)])
        }
    }

    @discardableResult
    func scan<T: AnyObject>(_ observer: T, closure: @escaping (T, DfuDevice) -> Void) -> RUObservationToken {
        let id = UUID()
        queue.async { [weak self] in
            self?.observations.device[id] = { [weak self, weak observer] device in
                guard let observer = observer else {
                    self?.observations.device.removeValue(forKey: id)
                    self?.manager.stopScan()
                    return
                }

                closure(observer, device)
            }

            self?.startIfNeeded()
        }

        return RUObservationToken { [weak self] in
            self?.queue.async { [weak self] in
                self?.observations.device.removeValue(forKey: id)
                self?.manager.stopScan()
            }
        }
    }
    
    func connect(uuid: String) {
        
    }
}

extension DfuScanner: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        queue.async { [weak self] in
            self?.startIfNeeded()
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        guard RSSI.intValue != 127 else { return }
        let uuid = peripheral.identifier.uuidString
        let isConnectable = (advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber)?.boolValue ?? false
        let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        let dfuDevice = DfuDevice(uuid: uuid, rssi: RSSI.intValue, isConnectable: isConnectable, name: name)
        observations.device.values.forEach { (closure) in
            closure(dfuDevice)
        }
    }
}
