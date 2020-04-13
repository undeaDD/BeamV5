import UIKit

final class DetailView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Section, DetailModel>?
    private lazy var dataSource = createDataSource()
    
    override func viewDidLoad() {
        collectionView.registerSection()
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = dataSource
        
        // Update Data with update function
        DispatchQueue.main.async { [weak self] in
            self?.update(with: StaticDummyData.getDetailViewData())
        }
    }
    
    func update(with data: [(Section, [DetailModel])]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DetailModel>()
        snapshot.appendSections(data.map{ $0.0 })
        data.forEach { snapshot.appendItems($1, toSection: $0) }
        currentSnapshot = snapshot
        dataSource.apply(snapshot)
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, DetailModel> {
        let temp = UICollectionViewDiffableDataSource<Section, DetailModel>(collectionView: collectionView) { (collectionView, indexPath, detailModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.identifier, for: indexPath) as! DetailCell
            
            // Populate DetailCell here
            cell.backgroundColor = detailModel.color
            cell.layer.cornerRadius = 8
            
            return cell
        }

        temp.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let cell = collectionView.dequeueReusableSupplementaryView(SectionView.identifier, for: indexPath) as! SectionView

            // Populate SectionHeader here
            cell.label.text = self.currentSnapshot?.sectionIdentifiers[indexPath.section].id ?? ""
            
            return cell
        }

        return temp
    }

    func createLayout() -> UICollectionViewLayout {
        // Header
        let itemSizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let itemHeader = NSCollectionLayoutItem(layoutSize: itemSizeHeader)

        let groupSizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let groupHeader = NSCollectionLayoutGroup.vertical(layoutSize: groupSizeHeader, subitem: itemHeader, count: 1)
        groupHeader.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        // Body
        let itemSizeBody = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let itemBody = NSCollectionLayoutItem(layoutSize: itemSizeBody)
        itemBody.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSizeBody = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3.15))
        let groupBody = NSCollectionLayoutGroup.horizontal(layoutSize: groupSizeBody, subitem: itemBody, count: 3)
        groupBody.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SectionView.identifier, alignment: .top)
        
        
        return UICollectionViewCompositionalLayout { (sectionIndex, layout) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
               let section = NSCollectionLayoutSection(group: groupHeader)
               return section
            } else {
                let section = NSCollectionLayoutSection(group: groupBody)
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0)
                return section
            }
        }
    }

}
