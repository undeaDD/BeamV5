import UIKit

class ListCell: UICollectionViewCell {
    static let identifier: String = "listCell"
}

struct ListModel: Hashable {
    let id = UUID().uuidString
    let color: UIColor
}


