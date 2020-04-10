//
//  ListingController.swift
//  BeeTrader
//
//  Created by hladek on 14/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

protocol ListingViewDelegate: Delegate {
//    func loadListings(completion: @escaping EmptyClosure)
//    func listingLoadFailure()
//    func listingLoadSuccess(listings: [Listing], completionHandler: @escaping EmptyClosure)
//    func filterChangedHandler()
    
    func showListings()
}

class ListingViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UITextField!

    var viewModel = ListingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewModelDidLoad()
        setupViews()
    }

    private func setupViews() {
        setupCollectionView()
        searchBar.underline(UIColor.Common.secondary!)
    }


    func setupCollectionView() {
        collectionView.refreshControl = viewModel.refreshControl
        viewModel.refreshControl.addTarget(self, action: #selector(refreshListings(_:)), for: .valueChanged)
    }
    
    func revealCollectionView() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.35, animations: { [weak self] in
                self?.collectionView.alpha = 1
                   })
        }
    }


    @IBAction func onAddlistingClicked(_: Any) {
        present(viewModel.addListingController, animated: true)
    }

    @IBAction func onFilterClicked(_: Any) {
        present(viewModel.filterListingController, animated: true)
    }

    @objc private func refreshListings(_: Any) {
        viewModel.loadListings { [weak self] in
            self?.viewModel.refreshControl.endRefreshing()
        }
    }
}

// MARK: DELEGATE

extension ListingViewController: ListingViewDelegate {
    func showListings() {
        collectionView.reloadData()
        revealCollectionView()
    }
    

}

// MARK: COLLECTION MANAGER

typealias CollectionManager = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

extension ListingViewController: CollectionManager {
    var spacing: CGFloat { return 16 }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.listings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListingCell", for: indexPath) as! ListingCell
        cell.setData(data: viewModel.listings[indexPath.row])
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ListingDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.listingDetail) as! ListingDetailViewController
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
