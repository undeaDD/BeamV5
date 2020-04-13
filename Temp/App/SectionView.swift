import UIKit

class SectionView: UICollectionReusableView {

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    static let identifier = "sectionHeaderView"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(label)
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
}

struct Section: Hashable {
    let id: String
    init(title: String = UUID().uuidString) { id = title }
}

extension UICollectionView {
    func registerSection() {
        self.register(SectionView.self, forSupplementaryViewOfKind: SectionView.identifier, withReuseIdentifier: SectionView.identifier)
    }
    
    func dequeueReusableSupplementaryView(_ identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        dequeueReusableSupplementaryView(ofKind: identifier, withReuseIdentifier: identifier, for: indexPath)
    }
}
