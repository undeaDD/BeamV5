import UIKit

class DetailCell: UICollectionViewCell {
    static let identifier: String = "detailCell"
}

struct DetailModel: Hashable {
    let id = UUID().uuidString
    let color: UIColor
}


