//
//  CustomTabBarController.swift
//  CallMe
//
//  Created by Luca Lancellotti on 26/07/22.
//

import UIKit

@IBDesignable
class CustomTabBar: UITabBar {
    static let increasedHeight = 47.0

    private var viewBorder: UIView?
    private var viewCircle: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        shadowImage = UIImage()
        backgroundImage = UIImage()
        tintColor = .textWhite
        barTintColor = .background
        backgroundColor = .background
        unselectedItemTintColor = UIColor(red: 179 / 255, green: 179 / 255, blue: 179 / 255, alpha: 1)
    }

    override var selectedItem: UITabBarItem? {
        didSet {
            updateTabBarItems()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if viewBorder == nil {
            let view = UIView()
            view.backgroundColor = UIColor(red: 235 / 255, green: 239 / 255, blue: 255 / 255, alpha: 0.3)
            insertSubview(view, at: 0)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true

            viewBorder = view
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = sizeThatFits.height + CustomTabBar.increasedHeight
        return sizeThatFits
    }

    func updateTabBarItems() {
        DispatchQueue.main.async {
            if let tabBarItems = self.items {
                for tabBar in tabBarItems {
                    if tabBar == self.selectedItem {
                        tabBar.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Bariol-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.kern: 0.6], for: .normal)

                        let numberOfItems = CGFloat(tabBarItems.count)
                        let itemWidth = self.frame.width / numberOfItems
                        let tabBarItemFrame = CGRect(origin: CGPoint(x: CGFloat(tabBarItems.firstIndex(of: tabBar) ?? 0) * itemWidth, y: 0), size: CGSize(width: itemWidth, height: self.frame.height))

                        let viewCircleFrame = CGRect(origin: CGPoint(x: tabBarItemFrame.origin.x + tabBarItemFrame.width / 2 - 3, y: 74), size: CGSize(width: 6, height: 6))
                        if self.viewCircle == nil {
                            self.viewCircle = UIView(frame: viewCircleFrame)
                            self.viewCircle?.backgroundColor = .white
                            self.viewCircle?.layer.cornerRadius = 3
                            self.insertSubview(self.viewCircle!, at: 0)
                        } else {
                            self.viewCircle?.frame = viewCircleFrame
                        }

                    } else {
                        tabBar.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Bariol-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15), NSAttributedString.Key.kern: 0.6], for: .normal)
                    }
                    tabBar.imageInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
                    tabBar.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -28)
                }
            }
        }
    }
}
