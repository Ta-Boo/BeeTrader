//
//  ListingController.swift
//  BeeTrader
//
//  Created by hladek on 14/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

protocol ListingViewDelegate: Delegate {
    func showListings(at indexPath: [IndexPath])
}

class ListingViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UITextField!
    let refreshControl = UIRefreshControl()
    let viewModel = ListingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
        setupViews()
    }

    private func setupViews() {
        setupCollectionView()
        searchBar.underline(UIColor.secondaryColor)
        setupUiHandlers()
    }

    func setupCollectionView() {
        collectionView.refreshControl = refreshControl
        refreshControl.alpha = 0
        refreshControl.addTarget(self, action: #selector(refreshListings(_:)), for: .valueChanged)
    }

    @IBAction func onAddlistingClicked(_: Any) {
        let controller = StoryboardScene.AddListing.addListingViewController.instantiate()
        controller.viewModel.completionHandler = { [weak self] in
            self?.viewModel.resetData()
            self?.viewModel.loadListings()
        }
        present(controller, animated: true)
    }

    @IBAction func onFilterClicked(_: Any) {
        let controller = StoryboardScene.ListingFilter.listingFilterViewController.instantiate()
        controller.viewModel.submitCompletion = { [weak self] parameters in
            self?.viewModel.changeFilter(parameters: parameters)
        }
        present(controller, animated: true)
    }
    @IBAction func onSearchChanged(_ sender: UITextField) {
        viewModel.onFilterChangedHandler(search: sender.text)
    }
    
    @objc private func refreshListings(_: Any) {
        viewModel.resetData()
        collectionView.reloadData()
        viewModel.loadListings { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
}

// MARK: DELEGATE

extension ListingViewController: ListingViewDelegate {
    func showListings(at indexPath: [IndexPath]) {
        collectionView.insertItems(at: indexPath)
    }
}

extension ListingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ListingViewController: UIGestureRecognizerDelegate {
    func setupUiHandlers() {
        let longTapHandler = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longTapHandler.minimumPressDuration = 0.5
        longTapHandler.numberOfTouchesRequired = 1
        longTapHandler.delaysTouchesBegan = true
        longTapHandler.delegate = self
        collectionView.addGestureRecognizer(longTapHandler)
    }
    
    @objc func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
        if let time = viewModel.longTapTimer  {
            if time > Date() {
                return
            }
            viewModel.longTapTimer = nil
                
            let indexPath = self.collectionView.indexPathForItem(at: gestureReconizer.location(in: self.collectionView))
            if let index = indexPath?.row {
                if GlobalUser.shared.user?.email == viewModel.listings[index].email {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    let controller = StoryboardScene.EditListing.addListingViewController.instantiate()
                    controller.viewModel.listingId = viewModel.listings[index].id
                    controller.viewModel.completionHandler = { [weak self] in
                        self?.viewModel.resetData()
                        self?.viewModel.loadListings()
                    }
                    present(controller, animated: true)
                }
                else {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    presentFailAlert(L10n.Listing.cannotEdit)
                }
            }
            
        } else {
            viewModel.longTapTimer = Date(timeIntervalSinceNow: TimeInterval(0.5))
        }
    }
}

// MARK: COLLECTION MANAGER

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
}


extension ListingViewController: CollectionManager {
    var spacing: CGFloat { return 16 }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.listings.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) && scrollView.contentSize.height > 100) {
            viewModel.loadMoreListings {
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y + 64), animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListingCell", for: indexPath) as! ListingCell
        let cell = collectionView.dequeueReusableCell(type: ListingCell.self, indexPath: indexPath)
        cell.setData(data: viewModel.listings[indexPath.row])
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = StoryboardScene.ListingDetail.listingDetailViewController.instantiate()
        controller.viewModel.listingId = viewModel.listings[indexPath.row].id
        present(controller, animated: true)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = (view.frame.width / 2) * 0.87
        let cellSize = CGSize(width: width, height: width * 1.4)
        return cellSize
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return spacing
    }
}
