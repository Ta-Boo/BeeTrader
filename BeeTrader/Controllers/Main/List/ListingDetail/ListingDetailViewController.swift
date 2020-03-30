//
//  ListingDetailViewController.swift
//  BeeTrader
//
//  Created by hladek on 21/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ListingDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var viewsImage: UIImageView!
    
    let viewModel = ListingDetailViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupGestureRecognizers()
    }
    
    func loadData() {
        guard let id = viewModel.listingId else {
            return
        }
        let parameters = RequestParameters.listing(id:id )
        showHUD()
        viewModel.loadData(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                self?.viewModel.listing = response.data
                self?.setupViews()
                self?.hideHUD()
            case .failure:
                self?.hideHUD()
                self?.presentFailedRequestAlert()
            }
        }
    }
    
    func setupViews() {
        guard let listing = viewModel.listing  else {
            return
        }
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
    
    func setupGestureRecognizers() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ListingDetailViewController.sendEmail))
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(gesture)
    }
    
    @IBAction func sendEmail(sender: UITapGestureRecognizer) {
        guard let email = viewModel.listing?.email else {
            return
        }
        let mailVC = MFMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["\(email)"])
            mailVC.setSubject("\(viewModel.listing?.title ?? "Your listing") at BeeTrader")
            present(mailVC, animated: true, completion: nil)
        } else { presentFailAlert(title: "Cannot send email from this device") }

    }
    

}
