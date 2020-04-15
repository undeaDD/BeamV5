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
        itemHeader.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.9))
        let groupHeader = NSCollectionLayoutGroup.vertical(layoutSize: groupSizeHeader, subitem: itemHeader, count: 1)
        
        // Body
        let itemSizeBody = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let itemBody = NSCollectionLayoutItem(layoutSize: itemSizeBody)
        itemBody.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let groupSizeBody = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3.15), heightDimension: .fractionalWidth(1/3.15))
        let groupBody = NSCollectionLayoutGroup.vertical(layoutSize: groupSizeBody, subitem: itemBody, count: 1)
        
        let headerSizeBody = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let sectionHeaderBody = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSizeBody, elementKind: SectionView.identifier, alignment: .top)

        return UICollectionViewCompositionalLayout { (sectionIndex, layout) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                let section = NSCollectionLayoutSection(group: groupHeader)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                return section
            } else {
                let section = NSCollectionLayoutSection(group: groupBody)
                section.boundarySupplementaryItems = [sectionHeaderBody]
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                return section
            }
        }
    }

}
