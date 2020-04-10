
import UIKit

class CategoryPickerCell: UITableViewCell {
    @IBOutlet var category: UILabel!
    
    func setData(data: Category) {
        category.text = "\(data.type)"
    }
}
