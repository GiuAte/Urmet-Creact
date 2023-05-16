//
//  DefaultPageControl.swift
//  CallMe
//
//  Created by Luca Lancellotti on 14/09/22.
//

import Foundation
import UIKit

class DefaultPageControl: UIControl {
    private class Dot: UIView {
        override func layoutSubviews() {
            super.layoutSubviews()

            layer.cornerRadius = frame.height / 2
        }
    }

    private var numberOfDots = [UIView]() {
        didSet {
            if numberOfDots.count == numberOfPages {
                setupViews()
            }
        }
    }

    private var dotsWidth = [NSLayoutConstraint]()

    @IBInspectable var numberOfPages: Int = 0 {
        didSet {
            numberOfDots = []
            dotsWidth = []
            for tag in 0 ..< numberOfPages {
                let dot = getDotView()
                dot.tag = tag
                dot.backgroundColor = pageIndicatorTintColor
                numberOfDots.append(dot)
            }
        }
    }

    var currentPage: Int = 0 {
        didSet {
            updateDots()
        }
    }

    @IBInspectable var pageIndicatorTintColor: UIColor? = .textWhite70
    @IBInspectable var currentPageIndicatorTintColor: UIColor? = .textWhite

    private lazy var stackView = UIStackView(frame: self.bounds)

    convenience init() {
        self.init(frame: .zero)
        setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }

        stackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }

        numberOfDots.forEach { dot in
            self.stackView.addArrangedSubview(dot)
        }

        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        addConstraints([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
        ])

        numberOfDots.forEach { dot in
            let width = dot.widthAnchor.constraint(equalTo: dot.heightAnchor, multiplier: 1, constant: 0)
            dotsWidth.append(width)

            self.addConstraints([
                dot.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
                width,
                dot.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 1, constant: 0),
            ])
        }
    }

    func updateDots() {
        numberOfDots.forEach { dot in
            if dot.tag == currentPage {
                UIView.animate(withDuration: 0.2, animations: {
                    dot.layer.cornerRadius = dot.bounds.height / 2
                    var constraint = self.dotsWidth[dot.tag]
                    constraint.isActive = false
                    constraint = dot.widthAnchor.constraint(equalToConstant: 32)
                    constraint.isActive = true
                    self.dotsWidth[dot.tag] = constraint
                    dot.backgroundColor = self.currentPageIndicatorTintColor

                    self.layoutIfNeeded()
                })
            } else {
                var constraint = self.dotsWidth[dot.tag]
                constraint.isActive = false
                constraint = dot.widthAnchor.constraint(equalTo: dot.heightAnchor, multiplier: 1, constant: 0)
                constraint.isActive = true
                self.dotsWidth[dot.tag] = constraint
                dot.backgroundColor = self.pageIndicatorTintColor
            }
        }
    }

    private func getDotView() -> UIView {
        let dot = Dot()
        dot.backgroundColor = pageIndicatorTintColor
        dot.translatesAutoresizingMaskIntoConstraints = false
        return dot
    }
}
