//
//  InfoBoxView.swift
//  CallMe
//
//  Created by Luca Lancellotti on 03/08/22.
//

import UIKit

@IBDesignable
class InfoBoxView: UIView {
    @IBInspectable var style: Int = 0 {
        didSet {
            _style = Style(rawValue: style)!
        }
    }

    private var _style: Style = .Info {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 48, bottom: 16, trailing: 16)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = 6
        clipsToBounds = true

        let aRect = UIBezierPath()
        aRect.move(to: CGPoint(x: 0.0, y: 0.0))
        aRect.addLine(to: CGPoint(x: 0.0, y: rect.height))
        aRect.addLine(to: CGPoint(x: rect.width, y: rect.height))
        aRect.addLine(to: CGPoint(x: rect.width, y: 0.0))
        aRect.close()
        UIColor.backgroundWhite12.set()
        aRect.fill()

        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: 0, y: 0))
        aPath.addLine(to: CGPoint(x: 0, y: rect.height))
        aPath.addLine(to: CGPoint(x: 8, y: rect.height))
        aPath.addLine(to: CGPoint(x: 8, y: 0.0))
        // Keep using the method addLine until you get to the one where about to close the path
        aPath.close()
        switch _style {
        case .Info:
            UIColor.blue500.set()
        case .Warning:
            UIColor.orange200.set()
        }
        aPath.fill()

        var imageName = ""
        switch _style {
        case .Info:
            imageName = "IconInfo"
        case .Warning:
            imageName = "IconWarning"
        }
        let imageRect = CGRect(x: 18, y: 23, width: 20, height: 20)
        UIImage(named: imageName, in: Bundle(for: InfoBoxView.self), compatibleWith: nil)?.draw(in: imageRect)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setNeedsDisplay()
    }

    enum Style: Int {
        case Info = 0
        case Warning = 1
    }
}
