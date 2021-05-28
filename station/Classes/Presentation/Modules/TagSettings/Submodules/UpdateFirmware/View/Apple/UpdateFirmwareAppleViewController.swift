import Foundation
import UIKit

class UpdateFirmwareAppleViewController: UIViewController, UpdateFirmwareViewInput {
    var output: UpdateFirmwareViewOutput!
    var viewModel = UpdateFirmwareViewModel()

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalization()
    }

    func localize() {
        self.title = self.viewModel.title
        configDescriptionContent()
    }

    private func configDescriptionContent() {
        let text = "OffsetCorrection.CalibrationDescription.text".localized()

        let attrString = NSMutableAttributedString(string: text)
        let muliRegular = UIFont.systemFont(ofSize: 16)
        let range = NSString(string: attrString.string).range(of: attrString.string)
        attrString.addAttribute(NSAttributedString.Key.font, value: muliRegular, range: range)
        // make text color gray
        attrString.addAttribute(.foregroundColor,
            value: UIColor.darkGray,
            range: NSRange(location: 0, length: attrString.length))

        descriptionTextView.attributedText = attrString
    }
}

// MARK: - IBOutlet
extension UpdateFirmwareAppleViewController {
    @IBAction func nextButtonAction(_ sender: Any) {
        output.viewDidOpenFlashFirmware()
    }
}
