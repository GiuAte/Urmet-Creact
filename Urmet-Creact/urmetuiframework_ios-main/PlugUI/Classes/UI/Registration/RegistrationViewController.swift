//
//  RegistrationViewController.swift
//  CallMe
//
//  Created by Luca Lancellotti on 19/07/22.
//

import UIKit
import UserSdk

class RegistrationViewController: UIViewController, IRegistration {
    
    func success(isSucceded _: Bool) {
        DispatchQueue.main.async {
            self.loader.dismiss(animated: false) {
                self.showPopup()
            }
        }
    }

    func error(error value: Error) {
        DispatchQueue.main.async {
            self.loader.dismiss(animated: false) {
                self.showPopup(error: value)
            }
        }
    }

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewContainer: UIScrollView!
    @IBOutlet var scrollViewContainerHeight: NSLayoutConstraint!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var buttonNext: UIButton!

    private var currentView = 0
    private var loader = LoaderViewController()
    private var firstStepRegistration: RegistrationFirstStepView!
    private var secondStepRegistration: RegistrationSecondStepView!
    private var thirdStepRegistration: RegistrationThirdStepView!
    private var collectionViewCountry: UICollectionView!
    private var collectionViewCountryHeight: NSLayoutConstraint!
    private let countries: [Country] = [
        Country(name: "Italia", flag: "ItalyFlag"),
        Country(name: "Albania", flag: "FlagAl"),
        Country(name: "Andorre", flag: "FlagAd"),
        Country(name: "Azzorre", flag: "FlagSv"),
        Country(name: "Belgio", flag: "FlagTd"),
        Country(name: "USA", flag: "FlagUs"),
    ]
    let bundle = Bundle(for: RegistrationViewController.self)
    var collectionItems: [Country] = []
    let registration = Registration()
    let gdpr = GDPRServiceUtility()
    var registrationViewModel = RegistrationViewModel(name: "", surname: "", country: "", email: "", password: "")
    var gdprCopy: [GDPRModel]?
    var gdprModel: [GDPRModel]? {
        didSet {
            thirdStepRegistration.updateViewModel(model: gdprModel ?? [])
        }
    }
    // private var user = UserActive()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registration.delegate = self
        buttonNext.isEnabled = false
        gdpr.delegate = self
        gdpr.getGDPR()
        localize()
        loadViews()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if collectionViewCountry != nil {
            collectionViewCountry.cornerRadius = min(32, collectionViewCountry.frame.height / 2)
            if collectionViewCountry.frame.height > collectionViewCountry.collectionViewLayout.collectionViewContentSize.height {
                collectionViewCountryHeight.constant = collectionViewCountry.collectionViewLayout.collectionViewContentSize.height
                collectionViewCountryHeight.isActive = true
            }
        }
    }

    func loadViews() {
        DispatchQueue.main.async {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()

            for view in self.scrollViewContainer.subviews {
                view.removeFromSuperview()
            }

            let firstStep = RegistrationFirstStepView()
            firstStep.nameDidChange = { name in
                print("Name: \(name)")
                self.registrationViewModel.name = name
            }
            firstStep.surnameDidChange = { surame in
                print("Surame: \(surame)")
                self.registrationViewModel.surname = surame
            }
            firstStep.countryDidChange = { country in
                print("Country: \(country)")
                self.registrationViewModel.country = country
            }
            firstStep.backgroundColor = .clear
            firstStep.continueChanged = { self.buttonNext.isEnabled = $0 }
            self.scrollViewContainer.addSubview(firstStep)
            firstStep.translatesAutoresizingMaskIntoConstraints = false
            firstStep.topAnchor.constraint(equalTo: self.scrollViewContainer.topAnchor).isActive = true
            firstStep.leadingAnchor.constraint(equalTo: self.scrollViewContainer.leadingAnchor).isActive = true
            firstStep.widthAnchor.constraint(equalTo: self.scrollViewContainer.widthAnchor).isActive = true
            firstStep.textFieldCountry.addTarget(self, action: #selector(self.countryEditingDidBegin), for: .editingDidBegin)
            firstStep.textFieldCountry.addTarget(self, action: #selector(self.countryEditingDidEnd), for: .editingDidEnd)
            firstStep.textFieldCountry.addTarget(self, action: #selector(self.countryValueChanged), for: .editingChanged)
            self.firstStepRegistration = firstStep

            let secondStep = RegistrationSecondStepView()
            secondStep.emailDidChange = { email in
                print("Email: \(email)")
                self.registrationViewModel.email = email
            }
            secondStep.passwordDidChange = { password in
                print("Password: \(password)")
                self.registrationViewModel.password = password
            }
            secondStep.repeatPasswordDidChange = { password in
                print("Repeat password: \(password)")
            }
            secondStep.rememberMeDidChange = { rememberMe in
                print("Remember me: \(rememberMe)")
            }
            secondStep.backgroundColor = .clear
            secondStep.continueChanged = { self.buttonNext.isEnabled = $0 }
            self.scrollViewContainer.addSubview(secondStep)
            secondStep.translatesAutoresizingMaskIntoConstraints = false
            secondStep.topAnchor.constraint(equalTo: self.scrollViewContainer.topAnchor).isActive = true
            secondStep.leadingAnchor.constraint(equalTo: firstStep.trailingAnchor).isActive = true
            secondStep.widthAnchor.constraint(equalTo: self.scrollViewContainer.widthAnchor).isActive = true
            self.secondStepRegistration = secondStep

            let thirdStep = RegistrationThirdStepView()
            thirdStep.conditionDidChange = { condition in
                print("\(condition.title): \(condition.status)")
                let index = self.gdprModel?.firstIndex(where: { $0.id == condition.id })
                self.gdprModel?[index ?? 0].status = condition.status
            }
            thirdStep.backgroundColor = .clear
            thirdStep.continueChanged = { self.buttonNext.isEnabled = $0 }
            thirdStep.didTapCondition = { condition in
                // TODO: OPEN LINK OF LEGAL CONDITION
                let popup: WebView = self.storyboard?.instantiateViewController(withIdentifier: "WebView") as! WebView
                popup.url = condition.url
                let navigationController = UINavigationController(rootViewController: popup)

                self.present(navigationController, animated: true, completion: nil)
                print(condition.url)
            }
            self.scrollViewContainer.addSubview(thirdStep)
            thirdStep.translatesAutoresizingMaskIntoConstraints = false
            thirdStep.topAnchor.constraint(equalTo: self.scrollViewContainer.topAnchor).isActive = true
            thirdStep.leadingAnchor.constraint(equalTo: secondStep.trailingAnchor).isActive = true
            thirdStep.widthAnchor.constraint(equalTo: self.scrollViewContainer.widthAnchor).isActive = true
            self.thirdStepRegistration = thirdStep

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.register(UINib(nibName: String(describing: RegistrationCountryCollectionViewCell.self), bundle: Bundle(for: RegistrationViewController.self)), forCellWithReuseIdentifier: RegistrationCountryCollectionViewCell.reuseIdentifier)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .white
            collectionView.isHidden = true
            self.view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            let constraint = collectionView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16)
            constraint.priority = UILayoutPriority(rawValue: 500)
            constraint.isActive = true
            let top = collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16)
            top.priority = UILayoutPriority(rawValue: 100)
            top.isActive = true
            let height = collectionView.heightAnchor.constraint(equalToConstant: 64)
            height.priority = UILayoutPriority(rawValue: 250)
            height.isActive = false
            collectionView.leadingAnchor.constraint(equalTo: firstStep.textFieldCountry.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: firstStep.textFieldCountry.trailingAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: firstStep.textFieldCountry.topAnchor, constant: -16).isActive = true
            self.collectionViewCountry = collectionView
            self.collectionViewCountryHeight = height

            self.scrollViewContainer.contentSize = CGSize(width: self.scrollViewContainer.frame.size.width * 3, height: firstStep.frame.height)
            self.scrollViewContainerHeight = self.scrollViewContainer.heightAnchor.constraint(equalTo: firstStep.heightAnchor)
            self.scrollViewContainerHeight.isActive = true

            self.checkNavigation()
        }
    }

    func localize() {
        buttonNext.setAttributedTitle(NSLocalizedString("Registration.Continue", tableName: Options.localizable, comment: "").toStyle(.Body1Regular, color: .textBlack), for: .normal)
    }

    @IBAction func backTapped(_: Any) {
        if currentView == 0 {
            navigationController?.popViewController(animated: true)
        } else {
            navigate(to: currentView - 1)
        }
    }

    @IBAction func nextTapped(_: Any) {
        if currentView < scrollViewContainer.subviews.count - 1 {
            navigate(to: currentView + 1)
        } else {
            didEndRegistration()
        }
    }

    func navigate(to index: Int) {
        self.view.layoutIfNeeded()

        let view = scrollViewContainer.subviews[index]
        DispatchQueue.main.async {
            self.scrollViewContainer.setContentOffset(view.frame.origin, animated: true)
            UIView.animate(withDuration: 0.3) {
                self.scrollViewContainerHeight.isActive = false
                self.scrollViewContainerHeight = self.scrollViewContainer.heightAnchor.constraint(equalTo: view.heightAnchor)
                self.scrollViewContainerHeight.isActive = true

                self.view.layoutIfNeeded()
            }
            self.currentView = index
            self.checkNavigation()
        }
    }

    func checkNavigation() {
        let view = scrollViewContainer.subviews[currentView]
        if view == firstStepRegistration || view == secondStepRegistration {
            buttonNext.setTitle(NSLocalizedString("Registration.Continue", tableName: Options.localizable, comment: ""), for: .normal)
            buttonNext.setImage(UIImage(named: "ArrowRight", in: bundle, compatibleWith: nil), for: .normal)
            buttonNext.setImage(UIImage(named: "ArrowRight", in: bundle, compatibleWith: nil), for: .disabled)
        } else if view == thirdStepRegistration {
            UIResponder.currentFirstResponder?.resignFirstResponder()
            buttonNext.setTitle(NSLocalizedString("Registration.EndRegistration", tableName: Options.localizable, comment: ""), for: .normal)
            buttonNext.setImage(nil, for: .normal)
            buttonNext.setImage(nil, for: .disabled)
            self.gdprModel = self.gdprCopy
        }
        buttonNext.isEnabled = (view as! RegistrationStep).canContinue
        if !buttonNext.isEnabled {
            DispatchQueue.main.async {
                self.scrollView.setContentOffset(.zero, animated: true)
            }
        } else {
            DispatchQueue.main.async {
                let maxY = max(0, self.scrollView.contentSize.height - self.scrollView.bounds.height)
                let bottomOffset = CGPoint(x: 0, y: maxY)
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
        }
    }

    func showPopup(error: Error? = nil) {
        let hasError = error == nil ? false : true
        
        let alert = AlertViewController(title: NSLocalizedString(hasError ? convertError(error: error ?? NSError()).0 : "Registration.Link", tableName: Options.localizable, comment: ""), message: NSLocalizedString(hasError ? convertError(error: error ?? NSError()).1 : "Registration.Activation", tableName: Options.localizable, comment: ""), style: hasError ? .error : .success)
        alert.closeHidden = true
        alert.addAction(AlertAction(title: NSLocalizedString("OK", tableName: Options.localizable, comment: ""), handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    func didEndRegistration() {
        guard let gd = self.gdprModel else { return }
        loader = LoaderViewController()
        present(loader, animated: false)
        let language = LanguageUtility.getLanguage().rawValue
        registration.register(name: registrationViewModel.name,
                              surname: registrationViewModel.surname,
                              email: registrationViewModel.email,
                              password: registrationViewModel.password,
                              country: registrationViewModel.country,
                              language: language,
                              statements: gd)
    }

    @objc func countryEditingDidBegin() {
        collectionViewCountry.isHidden = false
    }

    @objc func countryValueChanged() {
        firstStepRegistration.country = nil
        collectionViewCountryHeight.isActive = false
        collectionViewCountry.reloadData()
    }

    @objc func countryEditingDidEnd() {
        collectionViewCountry.isHidden = true
    }
}

extension RegistrationViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == scrollViewContainer {
            let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
            currentView = Int(pageNumber)
            checkNavigation()
        }
    }
}

extension RegistrationViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if firstStepRegistration.country == nil && !(firstStepRegistration.textFieldCountry.text ?? "").isEmpty {
            collectionItems = countries.filter { country in
                country.name.lowercased().starts(with: (firstStepRegistration.textFieldCountry.text ?? "").lowercased())
            }
            return collectionItems.count
        }
        collectionItems = countries
        return countries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let country = collectionItems[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegistrationCountryCollectionViewCell.reuseIdentifier, for: indexPath) as! RegistrationCountryCollectionViewCell
        cell.configure(name: country.name, flag: country.flag)

        return cell
    }
}

extension RegistrationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let country = collectionItems[indexPath.row]

        let cell = Bundle(for: RegistrationViewController.self).loadNibNamed(String(describing: RegistrationCountryCollectionViewCell.self), owner: self, options: nil)?.first as! RegistrationCountryCollectionViewCell
        cell.configure(name: country.name, flag: country.flag)

        // Get cell size
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let width = collectionView.frame.width - 16
        let height: CGFloat = 0

        let targetSize = CGSize(width: width, height: height)

        // get size with width that you want and automatic height
        let size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
        return size
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
}

extension RegistrationViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = collectionItems[indexPath.row]

        firstStepRegistration.textFieldCountry.endEditing(true)
        firstStepRegistration.country = country
    }
}

extension RegistrationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        if currentView == 0 {
            return true
        } else {
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
            navigate(to: currentView - 1)
        }
        return false
    }
}

extension RegistrationViewController {
    public struct RegistrationViewModel {
        var name: String
        var surname: String
        var country: String
        var email: String
        var password: String
    }
}

extension RegistrationViewController {
    public func convertError(error: Error) -> (String, String) {
        guard let error = error as? GDPRService.Error else {
            return ("Generic.Error.Title", error.localizedDescription)
        }
        switch error {
        case .connectivity:
            return ("Generic.Error.Title", "Generic.Error.Description")
        default:
            return ("", "")
        }
    }
}
extension RegistrationViewController: IGDPRProtocol {
    func success(gdprList: [UserSdk.GDPRModel]) {
        DispatchQueue.main.async {
        self.gdprCopy = gdprList
        self.loader.dismiss(animated: true)
            
        }
    }
}
