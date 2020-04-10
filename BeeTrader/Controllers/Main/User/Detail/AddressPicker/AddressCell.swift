
import UIKit

class AddressCell: UITableViewCell {
    @IBOutlet var address: UILabel!

    func setData(data: Address) {
        address.text = "\(data.postalCode), \(data.name)"
    }
}
