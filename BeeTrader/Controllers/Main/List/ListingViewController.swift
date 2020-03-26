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
    
    var viewModel = ListingViewModel()


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
        viewModel.loadListings(parameters: viewModel.parameters) { [weak self] result in
            switch result {
            case let .success(dbListings):
                self?.successfullyLoaded(dbListings: dbListings.data!, completion: completion)
            case .failure:
                completion()
            }
        }
    }

    func successfullyLoaded(dbListings: [Listing], completion: @escaping EmptyClosure) {
        viewModel.listings = dbListings
        collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.collectionView.alpha = 1
            }) { _ in
                completion()
            }
        }
    }

    @IBAction func onAddlistingClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddListing", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.addListing)
        
        present(controller, animated: true)
    }
    @IBAction func onFilterClicked(_ sender: Any) {
    let storyboard = UIStoryboard(name: "ListingFilter", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: ViewControllers.listingFilter) as! ListingFilterViewController
        controller.viewModel.submitCompletion = { [weak self] parameters in
            self?.viewModel.changeFilter(parameters: parameters)
            self?.showHUD()
            self?.loadListings { [weak self] in
                self?.hideHUD()
            }
        }
        present(controller, animated: true)
    }
    
    func setupCollectionView() {
        collectionView.refreshControl = viewModel.refreshControl
        viewModel.refreshControl.addTarget(self, action: #selector(refreshListings(_:)), for: .valueChanged)
    }

    @objc private func refreshListings(_: Any) {
        loadListings { [weak self] in
            self?.viewModel.refreshControl.endRefreshing()
        }
    }
}

extension ListingViewController {
    var spacing: CGFloat {
        get { return 16 }
    }
    
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

