//
//  LegalConditionCollectionViewCell.swift
//  CallMe
//
//  Created by Luca Lancellotti on 30/08/22.
//

import UIKit
import UserSdk

public class LegalConditionCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier = String(describing: LegalConditionCollectionViewCell.self)

    var legalCondition: UserSdk.GDPRModel!
    public var stateChanged: ((GDPRStatementSelectionStatus) -> Void)?
    public var didTapCondition: ((GDPRModel?) -> Void)?

    @IBOutlet var button: UIButton!
    @IBOutlet var labelAccept: UILabel!
    @IBOutlet var buttonAccept: UIButton!
    @IBOutlet var labelDeny: UILabel!
    @IBOutlet var buttonDeny: UIButton!
    let bundle = Bundle(for: LegalConditionCollectionViewCell.self)
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        labelAccept.attributedText = NSLocalizedString("Registration.Accept", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .textWhite70)
        labelDeny.attributedText = NSLocalizedString("Registration.Deny", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .textWhite70)
    }

    public func configure(_ legalCondition: UserSdk.GDPRModel) {
        self.legalCondition = legalCondition

        let conditionString = legalCondition.title.toStyle(.Link1RegularU, color: .textWhite)
        if legalCondition.mandatory.isMandatory {
            conditionString.append(" *".toStyle(.Body1Regular, color: .textWhite))
        }
        button.setAttributedTitle(conditionString, for: .normal)

        switch legalCondition.status {
        case .noChoice:
            buttonAccept.isSelected = false
            buttonDeny.isSelected = false
        case .rejected:
            buttonAccept.isSelected = false
            buttonDeny.isSelected = true
        case .accepted:
            buttonAccept.isSelected = true
            buttonDeny.isSelected = false
        }
    }

    @IBAction func conditionTapped(_: Any) {
        didTapCondition?(legalCondition)
    }

    @IBAction func toggleConditionsButton(_ sender: UIButton) {
        if sender == buttonAccept {
            buttonAccept.isSelected = !buttonAccept.isSelected
            legalCondition.status = buttonAccept.isSelected ? .accepted : .noChoice
            buttonDeny.isSelected = false
        } else if sender == buttonDeny {
            buttonDeny.isSelected = !buttonDeny.isSelected
            legalCondition.status = buttonDeny.isSelected ? .rejected : .noChoice
            buttonAccept.isSelected = false
        }
        print(legalCondition.status)
        stateChanged?(legalCondition.status)
    }
}
