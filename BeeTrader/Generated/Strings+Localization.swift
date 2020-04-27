// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Alert {
    /// Are you sure? 
    internal static let confirm = L10n.tr("Localizable", "Alert.Confirm")
    /// Cannot send email from this device.
    internal static let emailMissing = L10n.tr("Localizable", "Alert.EmailMissing")
    /// Fill all fields and upload image!
    internal static let fill = L10n.tr("Localizable", "Alert.Fill")
    /// This action will affext usage of this app in future.
    internal static let futureEfect = L10n.tr("Localizable", "Alert.FutureEfect")
    /// No camera detected!
    internal static let noCamera = L10n.tr("Localizable", "Alert.NoCamera")
    /// Check your internet conection.
    internal static let noConnection = L10n.tr("Localizable", "Alert.NoConnection")
    /// Try again later.
    internal static let tryAgain = L10n.tr("Localizable", "Alert.TryAgain")
    /// Something went wrong.
    internal static let unknownFail = L10n.tr("Localizable", "Alert.UnknownFail")
  }

  internal enum Common {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "Common.Cancel")
    /// Ok
    internal static let ok = L10n.tr("Localizable", "Common.Ok")
    /// Submit
    internal static let submit = L10n.tr("Localizable", "Common.Submit")
    /// Yes
    internal static let yes = L10n.tr("Localizable", "Common.Yes")
  }

  internal enum Email {
    /// at Beetrader!
    internal static let subject = L10n.tr("Localizable", "Email.Subject")
    /// Your listing!
    internal static let subjectPlaceholder = L10n.tr("Localizable", "Email.SubjectPlaceholder")
  }

  internal enum Listing {
    /// You cannot edit this listing.
    internal static let cannotEdit = L10n.tr("Localizable", "Listing.CannotEdit")
    /// Category
    internal static let category = L10n.tr("Localizable", "Listing.Category")
    internal enum Add {
      /// Change your listing image.
      internal static let changeImage = L10n.tr("Localizable", "Listing.Add.ChangeImage")
      /// Type some aditional info to describe what you are selling.
      internal static let description = L10n.tr("Localizable", "Listing.Add.Description")
      /// Price in €
      internal static let price = L10n.tr("Localizable", "Listing.Add.Price")
      /// Title
      internal static let title = L10n.tr("Localizable", "Listing.Add.Title")
      internal enum Category {
        /// Choose your category
        internal static let title = L10n.tr("Localizable", "Listing.Add.Category.Title")
      }
    }
    internal enum Edit {
      /// You are about to delete this listing.
      internal static let removeDialogTitle = L10n.tr("Localizable", "Listing.Edit.RemoveDialogTitle")
    }
    internal enum Filter {
      /// Distance
      internal static let distance = L10n.tr("Localizable", "Listing.Filter.Distance")
    }
  }

  internal enum User {
    /// Type your postal code or city name.
    internal static let addressHint = L10n.tr("Localizable", "User.AddressHint")
    /// Change me!
    internal static let changeAvatar = L10n.tr("Localizable", "User.ChangeAvatar")
    /// Log out
    internal static let logOut = L10n.tr("Localizable", "User.LogOut")
  }

  internal enum Welcome {
    /// Confirm your password
    internal static let confimrPassword = L10n.tr("Localizable", "Welcome.ConfimrPassword")
    /// I have existing account
    internal static let existingButton = L10n.tr("Localizable", "Welcome.ExistingButton")
    /// First name
    internal static let firstName = L10n.tr("Localizable", "Welcome.FirstName")
    /// Your first time ?
    internal static let firstTime = L10n.tr("Localizable", "Welcome.FirstTime")
    /// Last name
    internal static let lastName = L10n.tr("Localizable", "Welcome.LastName")
    /// Password
    internal static let password = L10n.tr("Localizable", "Welcome.Password")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
