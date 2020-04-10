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
        loadListing()
        setupGestureRecognizers()
    }

    func setupViews() {
        setupViewsHandler()
    }

    func setupGestureRecognizers() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ListingDetailViewController.sendEmail))
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(gesture)
    }

    @IBAction func sendEmail(sender: UITapGestureRecognizer) {
        sendEmailHandler(sender: sender)
    }
}

// MARK: Delegate

extension ListingDetailViewController: ListingDetailDelegate {
    func loadListing() {
        guard let id = viewModel.listingId else { return }
        let parameters = RequestParameters.listing(id: id)
        showHUD()
        viewModel.loadData(parameters: parameters)
    }

    func listingLoadedSuccess(listing: ListingDetail) {
        viewModel.listing = listing
        setupViews()
        hideHUD()
    }

    func listingLoadedFailure() {
        hideHUD()
        presentFailedRequestAlert()
    }

    func sendEmailHandler(sender _: UITapGestureRecognizer) {
        guard let email = viewModel.listing?.email else { return }
        let mailVC = MFMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["\(email)"])
            mailVC.setSubject("\(viewModel.listing?.title ?? "Your listing") at BeeTrader")
            present(mailVC, animated: true, completion: nil)
        } else { presentFailAlert(title: "Cannot send email from this device") }
    }

    func setupViewsHandler() {
        guard let listing = viewModel.listing else { return }
        if let listingImage = listing.image {
            image.loadImage(url: "\(ApiConstants.baseUrl)\(listingImage)", true)
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
