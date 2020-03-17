//
//  RegistrationViewController.swift
//  Bakalarka
//
//  Created by hladek on 04/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Alamofire
import Foundation
import UIKit

public class RegistrationViewController: UIViewController {
    public var viewModel: RegistrationViewModel?

    @IBOutlet var emailLabel: UITextField!
    @IBOutlet var passwordLabel: UITextField!
    @IBOutlet var passwordRightOffset: NSLayoutConstraint!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var loginForm: UIView!
    @IBOutlet var registrationForm: UIView!

    @IBOutlet var registrationFirstNameLabel: UITextField!
    @IBOutlet var registrationLastNameLabel: UITextField!
    @IBOutlet var registrationEmailLabel: UITextField!
    @IBOutlet var registrationPasswordLabel: UITextField!
    @IBOutlet var registrationConfirmEmailLabel: UITextField!
    @IBOutlet var submitRegistrationButton: UIButton!

    var successfulLoginHandler: EmptyClosure?

    private var loginEnabled = false
    private let shrinkedOffset: CGFloat = 64
    private let stretchedOffset: CGFloat = 8

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegistrationViewModel()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if DEBUG
            emailLabel.text = "tobias@hladek.com"
            passwordLabel.text = "1"
            enableLoginIfPossible()
        #endif
    }

    private func animatePasswordLabelWidth(withSpace space: CGFloat, _ completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.6, animations: {
            self.passwordRightOffset.constant = space
            self.view.layoutIfNeeded()
        }, completion: completion)
    }

    private func enableLoginIfPossible() {
        if (passwordLabel.text?.isEmpty ?? true) || (emailLabel.text?.isEmpty ?? true) {
            loginEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                self.submitButton.alpha = 0

            }, completion: { _ in
                self.submitButton.isEnabled = false
                self.submitButton.isHidden = true
                })
            animatePasswordLabelWidth(withSpace: stretchedOffset) { _ in }
        } else if !loginEnabled {
            loginEnabled = true
            animatePasswordLabelWidth(withSpace: shrinkedOffset) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.submitButton.isHidden = false
                    self.submitButton.alpha = 1

                }, completion: { _ in
                    self.submitButton.isEnabled = true
                })
            }
        }
    }

    private func swapForms(from: UIView, to: UIView) {
        to.alpha = 0
        to.isHidden = false

        UIView.animate(withDuration: 0.5, animations: {
            from.alpha = 0
        }, completion: { _ in
            from.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                to.alpha = 1
            }, completion: { _ in
            })
        })
    }

    private func checkRegistrationFormFill() {
        if isRegistrationFormFilled() {
            submitRegistrationButton.isHidden = false
        } else {
            submitRegistrationButton.isHidden = true
        }
    }

    private func isRegistrationFormFilled() -> Bool {
        return registrationFirstNameLabel.isNotEmpty() &&
            registrationFirstNameLabel.isNotEmpty() &&
            registrationLastNameLabel.isNotEmpty() &&
            registrationEmailLabel.isNotEmpty() &&
            registrationPasswordLabel.isNotEmpty() &&
            registrationConfirmEmailLabel.isNotEmpty()
    }

    private func saveUserData(user: LoginResponse) {
        if let encoded = try? JSONEncoder().encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: StorageKeys.user)
        }
    }

    private func sucessfulLogin(_ value: DataWrapper<LoginResponse>) {
        if let data = value.data {
            saveUserData(user: data)
            successfulLoginHandler?()
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Check your email or password", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    }

    func failedLogin() {
        let alert = UIAlertController(title: "Check your internet conection", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    func login(parameters: Parameters? = nil) {
        let workingParams = parameters ?? RequestParameters.login(withEmail: emailLabel.text!, password: passwordLabel.text!)
        showHUD()
        viewModel?.login(parameters: workingParams) { [weak self] result in
            self?.hideHUD()
            switch result {
            case let .success(value):
                self?.sucessfulLogin(value)
            case .failure:
                self?.failedLogin()
            }
        }
    }

    @IBAction func onSentButtonClicked(_: Any) {
        login()
    }

    // MARK: LOGIN

    @IBAction func onEmailChanged(_: Any) {
        enableLoginIfPossible()
    }

    @IBAction func onPasswordChange(_: UITextField) {
        enableLoginIfPossible()
    }

    // MARK: REGISTRATION

    @IBAction func onsubmitRegistrationTapped(_: Any) {
        let email = registrationEmailLabel.text!
        let password = registrationConfirmEmailLabel.text!
        let parameters = RequestParameters.register(firstName: registrationFirstNameLabel.text!,
                                                    lastName: registrationLastNameLabel.text!,
                                                    email: email,
                                                    password: password)
        showHUD()
        viewModel?.register(parameters: parameters) { [weak self] result in
            switch result {
            case .success:
                self?.login(parameters: RequestParameters.login(withEmail: email, password: password))
            case let .failure(error):
                print(error)
                self?.hideHUD()
            }
        }
    }

    @IBAction func registrationFormTapped(_: Any) {
        swapForms(from: loginForm, to: registrationForm)
    }

    @IBAction func onShowLoginFormTapped(_: Any) {
        swapForms(from: registrationForm, to: loginForm)
    }

    @IBAction func onRegistrationFirstnameChanged(_: Any) {
        checkRegistrationFormFill()
    }

    @IBAction func onRegistrationLastNameChanged(_: Any) {
        checkRegistrationFormFill()
    }

    @IBAction func onRegistrationEmailChanged(_: Any) {
        checkRegistrationFormFill()
    }

    @IBAction func onRegistrationPasswordChanged(_: Any) {
        checkRegistrationFormFill()
    }

    @IBAction func onRegistrationConfirmPasswordChanged(_: Any) {
        checkRegistrationFormFill()
    }
}
