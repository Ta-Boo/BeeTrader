// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum AddListing: StoryboardType {
    internal static let storyboardName = "AddListing"

    internal static let initialScene = InitialSceneType<AddListingViewController>(storyboard: AddListing.self)

    internal static let addListingViewController = SceneType<AddListingViewController>(storyboard: AddListing.self, identifier: "AddListingViewController")
  }
  internal enum AddressPicker: StoryboardType {
    internal static let storyboardName = "AddressPicker"

    internal static let initialScene = InitialSceneType<AddressPickerViewController>(storyboard: AddressPicker.self)

    internal static let addressPickerViewController = SceneType<AddressPickerViewController>(storyboard: AddressPicker.self, identifier: "AddressPickerViewController")
  }
  internal enum CategoryPicker: StoryboardType {
    internal static let storyboardName = "CategoryPicker"

    internal static let initialScene = InitialSceneType<CategoryPickerViewController>(storyboard: CategoryPicker.self)
  }
  internal enum EditListing: StoryboardType {
    internal static let storyboardName = "EditListing"

    internal static let initialScene = InitialSceneType<EditListingViewController>(storyboard: EditListing.self)

    internal static let addListingViewController = SceneType<EditListingViewController>(storyboard: EditListing.self, identifier: "AddListingViewController")
  }
  internal enum ListingDetail: StoryboardType {
    internal static let storyboardName = "ListingDetail"

    internal static let initialScene = InitialSceneType<ListingDetailViewController>(storyboard: ListingDetail.self)

    internal static let listingDetailViewController = SceneType<ListingDetailViewController>(storyboard: ListingDetail.self, identifier: "ListingDetailViewController")
  }
  internal enum ListingFilter: StoryboardType {
    internal static let storyboardName = "ListingFilter"

    internal static let initialScene = InitialSceneType<ListingFilterViewController>(storyboard: ListingFilter.self)

    internal static let listingFilterViewController = SceneType<ListingFilterViewController>(storyboard: ListingFilter.self, identifier: "ListingFilterViewController")
  }
  internal enum MainTabBar: StoryboardType {
    internal static let storyboardName = "MainTabBar"

    internal static let mainTabBarController = SceneType<MainTabBarController>(storyboard: MainTabBar.self, identifier: "MainTabBarController")
  }
  internal enum Registration: StoryboardType {
    internal static let storyboardName = "Registration"

    internal static let initialScene = InitialSceneType<RegistrationViewController>(storyboard: Registration.self)

    internal static let registrationviewController = SceneType<RegistrationViewController>(storyboard: Registration.self, identifier: "RegistrationviewController")
  }
  internal enum User: StoryboardType {
    internal static let storyboardName = "User"

    internal static let initialScene = InitialSceneType<UserViewController>(storyboard: User.self)

    internal static let userviewController = SceneType<UserViewController>(storyboard: User.self, identifier: "UserviewController")
  }
  internal enum UserDetail: StoryboardType {
    internal static let storyboardName = "UserDetail"

    internal static let initialScene = InitialSceneType<UserDetailViewController>(storyboard: UserDetail.self)

    internal static let userDetailTableViewController = SceneType<UserDetailViewController>(storyboard: UserDetail.self, identifier: "UserDetailTableViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
