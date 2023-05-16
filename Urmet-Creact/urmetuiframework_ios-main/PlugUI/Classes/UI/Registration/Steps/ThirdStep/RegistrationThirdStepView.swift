//
//  RegistrationThirdStepView.swift
//  CallMe
//
//  Created by Luca Lancellotti on 19/07/22.
//

import UIKit
import UserSdk

class RegistrationThirdStepView: RegistrationStep {
    
    var viewModel: [UserSdk.GDPRModel]? = []
    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelDescription: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet private var labelPrivacyInfo: UILabel!

    var didTapCondition: ((UserSdk.GDPRModel) -> Void)?
    var conditionDidChange: ((UserSdk.GDPRModel) -> Void)?
    let bundle = Bundle(for: RegistrationThirdStepView.self)
    
    override func commonInit() {
        super.commonInit()
        setUI()
        localize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }

    private func setUI() {
        collectionView.register(UINib(nibName: String(describing: LegalConditionCollectionViewCell.self), bundle: bundle), forCellWithReuseIdentifier: LegalConditionCollectionViewCell.reuseIdentifier)
    }
    
    private func localize() {
        labelTitle.attributedText = NSLocalizedString("Registration.AlmostDone", tableName: Options.localizable, comment: "").toStyle(.HeaderH1Regular, color: .textWhite)
        labelDescription.attributedText = NSLocalizedString("Registration.ThirdStep.Description", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .textWhite70)
        labelPrivacyInfo.attributedText = NSLocalizedString("Registration.PrivacyInfo", tableName: Options.localizable, comment: "").toStyle(.ItemCronoLightSub, color: .textWhite70)
    }

    public func updateViewModel(model: [UserSdk.GDPRModel]){
        DispatchQueue.main.async {
            self.viewModel = model
            self.collectionView.reloadData()
        }
    }

    private func checkContinue() {
        canContinue = true
        guard let viewModel = viewModel else { return }
        for condition in viewModel {
            if condition.mandatory.isMandatory && condition.status == .noChoice {
                canContinue = false
            }
        }
    }
}

extension RegistrationThirdStepView: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel?.count ?? 0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 32
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let condition = viewModel?[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LegalConditionCollectionViewCell.reuseIdentifier, for: indexPath) as! LegalConditionCollectionViewCell
        guard let condition = condition else {return cell}
        cell.configure(condition)
        cell.stateChanged = { state in
            self.viewModel?[indexPath.row].status = state
            self.conditionDidChange?((self.viewModel?[indexPath.row])!)
            self.checkContinue()
        }
        cell.didTapCondition = { condition in
            guard let condition = condition else { return }
            self.didTapCondition?(condition)
        }
        cell.configure(condition)
        return cell
    }
}

extension RegistrationThirdStepView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = bundle.loadNibNamed(String(describing: LegalConditionCollectionViewCell.self), owner: self, options: nil)?.first as! LegalConditionCollectionViewCell
        guard let viewModel = viewModel else { return CGSize(width: 0, height: 0) }
        cell.configure(viewModel[indexPath.row])

        // Get cell size
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let width = collectionView.frame.width
        let height: CGFloat = 0

        let targetSize = CGSize(width: width, height: height)

        // get size with width that you want and automatic height
        let size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
        return size
    }
}
