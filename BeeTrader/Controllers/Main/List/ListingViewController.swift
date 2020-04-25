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
    func showListings(at indexPath: [IndexPath])
}

class ListingViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UITextField!
    let refreshControl = UIRefreshControl()
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
        collectionView.refreshControl = refreshControl
        refreshControl.alpha = 0
        refreshControl.addTarget(self, action: #selector(refreshListings(_:)), for: .valueChanged)
    }

    @IBAction func onAddlistingClicked(_: Any) {
        let controller = UIStoryboard(name: "AddListing", bundle: nil).instantiateInitialViewController() as! AddListingViewController
        controller.viewModel.completionHandler = { [weak self] in
            self?.viewModel.resetData()
            self?.viewModel.loadListings()
        }
        present(controller, animated: true)
    }

    @IBAction func onFilterClicked(_: Any) {
        let controller = UIStoryboard(name: "ListingFilter", bundle: nil).instantiateInitialViewController() as! ListingFilterViewController
        controller.viewModel.submitCompletion = { [weak self] parameters in
            self?.viewModel.changeFilter(parameters: parameters)
        }
        present(controller, animated: true)
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

// MARK: COLLECTION MANAGER

typealias CollectionManager = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

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
