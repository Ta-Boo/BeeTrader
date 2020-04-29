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

protocol SignInDelegate: Delegate {
    func okRegistrationHandler(email: String)
}

extension RegistrationViewController: SignInDelegate {

    func okRegistrationHandler(email: String) {
        swapForms(from: registrationForm, to: loginForm)
        emailLabel.text = email
        passwordLabel.text = ""
    }
}

class RegistrationViewController: UIViewController {
    let viewModel = RegistrationViewModel()

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
    
    @IBOutlet weak var loginPasswordTitle: UILabel!
    @IBOutlet weak var firstNameTitle: UILabel!
    @IBOutlet weak var lastNameTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var passwordConfirmTitle: UILabel!
    @IBOutlet weak var existingAccountButton: UIButton!
    @IBOutlet weak var firstTimeButton: UIButton!
        
    var registrationFilled: Bool {
           get {
               return registrationFirstNameLabel.isNotEmpty() &&
               registrationFirstNameLabel.isNotEmpty() &&
               registrationLastNameLabel.isNotEmpty() &&
               registrationEmailLabel.isNotEmpty() &&
               registrationPasswordLabel.isNotEmpty() &&
               registrationConfirmEmailLabel.isNotEmpty()
           }
    }
    
    var loginParameters: Parameters {
           return RequestParameters.login(withEmail: emailLabel.text!, password: passwordLabel.text!)
    }
    
    var registerParameters: Parameters {
          return RequestParameters.register(firstName: registrationFirstNameLabel.text!,
          lastName: registrationLastNameLabel.text!,
          email: registrationEmailLabel.text!,
          password: registrationConfirmEmailLabel.text!)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
        localize()
        #if DEBUG
            emailLabel.text = "tobias@hladek.com"
            passwordLabel.text = "1"
            enableLoginIfPossible()
        #endif
    }
    
    func localize() {
        loginPasswordTitle.text = L10n.Welcome.password
        firstNameTitle.text = L10n.Welcome.firstName
        lastNameTitle.text = L10n.Welcome.lastName
        passwordTitle.text = L10n.Welcome.password
        passwordConfirmTitle.text = L10n.Welcome.confimrPassword
        firstTimeButton.setTitle(L10n.Welcome.firstTime, for: .normal)
        existingAccountButton.setTitle(L10n.Welcome.existingButton, for: .normal)
    }

    func enableLoginIfPossible() {
        if (passwordLabel.text?.isEmpty ?? true) || (emailLabel.text?.isEmpty ?? true) {
            hideLoginButton()
        } else  {
            showLoginButton()
        }
    }
    
    func hideLoginButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.submitButton.alpha = 0

        }, completion: { _ in
            self.submitButton.isEnabled = false
            self.submitButton.isHidden = true
            })
        animatePasswordLabelWidth(withSpace: 8) { _ in }
    }
    
    func showLoginButton() {
        animatePasswordLabelWidth(withSpace: 64) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.submitButton.isHidden = false
                self.submitButton.alpha = 1

            }, completion: { _ in
                self.submitButton.isEnabled = true
            })
        }
    }
    
    func animatePasswordLabelWidth(withSpace space: CGFloat, _ completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.6, animations: {
            self.passwordRightOffset.constant = space
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
    

    func swapForms(from: UIView, to: UIView) {
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

    func updateRegistrationView() {
        if registrationFilled {
            submitRegistrationButton.isHidden = false
        } else {
            submitRegistrationButton.isHidden = true
        }
    }



    @IBAction func onSentButtonClicked(_: Any) {
        viewModel.login(withParameters: loginParameters)
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
        viewModel.register(withParameters: registerParameters)
    }

    @IBAction func registrationFormTapped(_: Any) {
        swapForms(from: loginForm, to: registrationForm)
    }

    @IBAction func onShowLoginFormTapped(_: Any) {
        swapForms(from: registrationForm, to: loginForm)
    }

    @IBAction func onRegistrationFirstnameChanged(_: Any) {
        updateRegistrationView()
    }

    @IBAction func onRegistrationLastNameChanged(_: Any) {
        updateRegistrationView()
    }

    @IBAction func onRegistrationEmailChanged(_: Any) {
        updateRegistrationView()
    }

    @IBAction func onRegistrationPasswordChanged(_: Any) {
        updateRegistrationView()
    }

    @IBAction func onRegistrationConfirmPasswordChanged(_: Any) {
        updateRegistrationView()
    }
}
