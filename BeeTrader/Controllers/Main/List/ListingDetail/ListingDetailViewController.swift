//
//  ListingDetailViewController.swift
//  BeeTrader
//
//  Created by hladek on 21/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

class ListingDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet var image: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var viewsLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var viewsImage: UIImageView!
    let viewModel = ListingDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
        setupGestureRecognizers()
    }

    func setupGestureRecognizers() {
        let sendEmailGesture = UITapGestureRecognizer(target: self, action: #selector(ListingDetailViewController.sendEmail))
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(sendEmailGesture)
        
        let callGesture = UITapGestureRecognizer(target: self, action: #selector(ListingDetailViewController.makeCall))
        phoneLabel.isUserInteractionEnabled = true
        phoneLabel.addGestureRecognizer(callGesture)
    }

    @IBAction func sendEmail(sender: UITapGestureRecognizer) {
        guard let email = viewModel.listing?.email else {
            presentFailure()
            return
        }
        let mailVC = MFMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([email])
            mailVC.setSubject("\(emailLabel.text ?? L10n.Email.subjectPlaceholder) \(L10n.Email.subject)")
            present(mailVC, animated: true)
        } else {
            presentFailAlert(title: L10n.Alert.emailMissing)
        }
    }
    
    @IBAction func makeCall(sender: UITapGestureRecognizer) {
        guard let phone  = phoneLabel.text,
            let url = URL(string: "tel://\(phone)")  else {
            presentFailAlert()
            return
        }
        UIApplication.shared.open(url)
    }
}

// MARK: Delegate
protocol ListingDetailDelegate: Delegate {
    func listingLoaded(listing: ListingDetail)
}

extension ListingDetailViewController: ListingDetailDelegate {

    func listingLoaded(listing: ListingDetail) {
        if let listingImage = listing.image {
            image.imageFromUrl(ApiConstants.getImage(postFix: listingImage), useCached: true, true)
        }
        viewsLabel.text = "\(listing.views)"
        addressLabel.text = listing.location
        emailLabel.text = listing.email
        phoneLabel.text = listing.phone
        titleLabel.text = listing.title
        priceLabel.text = listing.price.toPrice()
        descriptionLabel.text = listing.description
        userNameLabel.text = listing.userName
        viewsImage.isHidden = false
    }
}
