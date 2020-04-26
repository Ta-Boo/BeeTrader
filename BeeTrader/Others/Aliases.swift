//
//  Aliases.swift
//  BeeTrader
//
//  Created by hladek on 12/03/2020.
//  Copyright © 2020 hladek. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias EmptyClosure = () -> Void
typealias ErrorClosure = (Error) -> Void
typealias OptionalErrorClosure = (Error?) -> Void
typealias BoolClosure = (Bool) -> Void
typealias StringClosure = (String) -> Void
typealias DoubleClosure = (Double) -> Void
typealias IntegerClosure = (Int?) -> Void
typealias OptionalStringClosure = (String?) -> Void

typealias KeyboardLayoutManager = UITableViewController & UITextFieldDelegate
typealias ImagePickerManager = UIImagePickerControllerDelegate & UINavigationControllerDelegate

typealias DataResult<Type: Codable> = Result<DataWrapper<Type>>
typealias ListingManager = UITableViewDataSource & UITableViewDelegate
typealias CollectionManager = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
