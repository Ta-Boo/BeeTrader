
import UIKit

class AddressCell: UITableViewCell {
    @IBOutlet weak var address: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(data: Address) {
        address.text = "\(data.postalCode), \(data.name)"
    }
}
