//
//  ListingController.swift
//  BeeTrader
//
//  Created by hladek on 14/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit

typealias CollectionManager = UIViewController & UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

class ListingViewController: CollectionManager {
    @IBOutlet var collectionView: UICollectionView!

    @IBOutlet var searchBar: UITextField!
    private let refreshControl = UIRefreshControl()
    var listings: [Listing] = []
    var viewModel: ListingViewModel?

    private let reuseIdentifier = "ListingCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ListingViewModel()
        setupViews()
    }

    private func setupViews() {
        setupCollectionView()
        searchBar.underline(UIColor.Common.secondary!)
        showHUD()
        loadListings { [weak self] in
            self?.hideHUD()
        }
    }

    func loadListings(completion: @escaping EmptyClosure) {
        let parameters = RequestParameters.listingInRadius(radius: 500, latitude: 49.214524, longitude: 19.295317)
        viewModel?.loadListings(parameters: parameters) { [weak self] result in
            switch result {
            case let .success(dbListings):
                self?.successfullyLoaded(dbListings: dbListings.data!, completion: completion)
            case .failure:
                completion()
            }
        }
    }

    func successfullyLoaded(dbListings: [Listing], completion: @escaping EmptyClosure) {
        listings = dbListings
        collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.collectionView.alpha = 1
            }) { _ in
                completion()
            }
        }
    }

    func setupCollectionView() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshListings(_:)), for: .valueChanged)
    }

    @objc private func refreshListings(_: Any) {
        loadListings { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

extension ListingViewController {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return listings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListingCell", for: indexPath) as! ListingCell
        cell.setData(data: listings[indexPath.row])
        return cell
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ListingDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.listingDetailViewController) as! ListingDetailViewController
        controller.viewModel.listingId = listings[indexPath.row].id
        print(listings[indexPath.row].id)
        present(controller, animated: true)
        print(listings[indexPath.row])
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = (view.frame.width / 2) * 0.87
        let cellSize = CGSize(width: width, height: width * 1.4)
        return cellSize
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 16
    }

}
