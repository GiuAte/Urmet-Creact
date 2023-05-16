//
//  OnboardingViewController.swift
//  CallMe
//
//  Created by Luca Lancellotti on 14/09/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet var pageControl: DefaultPageControl!
    @IBOutlet var buttonStart: PrimaryButton!
    
    let bundle = Bundle(for: OnboardingViewController.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        Options.getResource(resource: .OnBoarding)
        buttonStart.isHidden = true
        scrollView.isHidden = true
        localize()

        loadSteps()
    }

    func localize() {
        labelTitle.attributedText = NSLocalizedString("Onboarding.Title", tableName: Options.localizable, comment: "").toStyle(.HeaderH1Regular, color: .textWhite, alignment: .center)

        buttonStart.setAttributedTitle(NSLocalizedString("Onboarding.Start", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .black), for: .normal)
    }

    func loadSteps() {
        DispatchQueue.main.async {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()

            var previousView: UIView?

            for step in Options.boardingStep.steps {
                let stepView = OnboardingStepView(image: UIImage(named: step.image)!, title: step.title, description: step.description)
                stepView.backgroundColor = .clear
                stepView.translatesAutoresizingMaskIntoConstraints = false

                let sv = UIScrollView()
                sv.translatesAutoresizingMaskIntoConstraints = false
                sv.showsVerticalScrollIndicator = false
                sv.addSubview(stepView)
                stepView.topAnchor.constraint(equalTo: sv.topAnchor).isActive = true
                stepView.leadingAnchor.constraint(equalTo: sv.leadingAnchor).isActive = true
                stepView.trailingAnchor.constraint(equalTo: sv.trailingAnchor).isActive = true
                stepView.bottomAnchor.constraint(equalTo: sv.bottomAnchor).isActive = true
                stepView.widthAnchor.constraint(equalTo: sv.widthAnchor).isActive = true

                self.scrollView.addSubview(sv)
                sv.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
                sv.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
                sv.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
                if previousView == nil {
                    sv.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
                } else {
                    sv.leadingAnchor.constraint(equalTo: previousView!.trailingAnchor).isActive = true
                }
                previousView = sv
            }
            self.buttonStart.isHidden = Options.boardingStep.steps.count > 1 ? true : false
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(Options.boardingStep.steps.count), height: 1)

            self.pageControl.numberOfPages = Options.boardingStep.steps.count
            self.pageControl.currentPage = 0
            self.scrollView.isHidden = false
        }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        if pageControl.currentPage != pageNumber {
            pageControl.currentPage = pageNumber
            if pageNumber == Options.boardingStep.steps.count - 1 {
                buttonStart.isHidden = false
            } else {
                buttonStart.isHidden = true
            }
        }
    }
}
