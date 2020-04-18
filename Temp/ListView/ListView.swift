import UIKit
import FloatingPanel

class ListView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Section, ListModel>?
    private lazy var dataSource = createDataSource()
    var detailPanel: FloatingPanelController?
    
    override func viewDidLoad() {
        collectionView.registerSection()
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        // Update Data with update function
        DispatchQueue.main.async { [weak self] in
            self?.update(with: StaticDummyData.getListViewData())
        }
    }
    
    func update(with data: [(Section, [ListModel])]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListModel>()
        snapshot.appendSections(data.map{ $0.0 })
        data.forEach { snapshot.appendItems($1, toSection: $0) }
        currentSnapshot = snapshot
        dataSource.apply(snapshot)
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, ListModel> {
        let temp = UICollectionViewDiffableDataSource<Section, ListModel>(collectionView: collectionView) { (collectionView, indexPath, listModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as! ListCell
            
            // Populate ListCell here
            cell.backgroundColor = listModel.color
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3.15), heightDimension: .fractionalWidth(1/3.15))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SectionView.identifier, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension ListView: UICollectionViewDelegate, FloatingPanelControllerDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if detailPanel != nil {
            detailPanel?.hide(animated: true)
            detailPanel = nil
        } else {
            
            if let contentView = UIStoryboard(name: "DetailView", bundle: .main).instantiateInitialViewController() as? DetailView,
                let navController = UIApplication.shared.windows.first?.rootViewController as? NavigationController,
                let cameraView = navController.topViewController as? CameraView {
                    cameraView.listPanel?.move(to: .full, animated: true)
                    
                    detailPanel = FloatingPanelController()
                    detailPanel?.surfaceView.cornerRadius = 16.0
                    detailPanel?.isRemovalInteractionEnabled = true
                    detailPanel?.backdropView.dismissalTapGestureRecognizer.isEnabled = true
                    detailPanel?.set(contentViewController: contentView)
                    detailPanel?.track(scrollView: contentView.collectionView)
                    detailPanel?.delegate = self
                    detailPanel?.addPanel(toParent: cameraView)
            }
        }
    }

    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        HalfLayout()
    }
    
}

class HalfLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition = .half
    var supportedPositions: Set<FloatingPanelPosition> = [.half]
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        return position == .half ? 400 : nil
    }
}
