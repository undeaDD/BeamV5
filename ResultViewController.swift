//
//  ResultViewController.swift
//  BeamV5
//
//  Created by Us on 06/03/2020.
//  Copyright © 2020 David Arebuwa. All rights reserved.
//

import UIKit
import Gifu

class ResultViewController: UIViewController{
    
    //MVCComponents -- we might need to move this to our view controller
    //JSON File containing the result list (Model)
    let results = Bundle.main.decode(_type: [ResultController.ResultData].self, from: "resultlist 2.json")
    
    //Controller for our result data
    var resultController = ResultController()
    
    //Number of Results
    var resultCount: Int = 0
    
    //prediction result retrieved
    var prediction : String = ""
    
    
    //Result CollectionView Related Components
    var resultCollectionView : UICollectionView!
    //DiffableDataSource for CollectionView
    //   var resultDataSource: UICollectionViewDiffableDataSource<ResultController.ResultData,ResultController.ResultItemData>! = nil
    var resultDataSource: UICollectionViewDiffableDataSource<ResultController.SupplementCollection,ResultController.ResultItemData>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<ResultController.SupplementCollection,ResultController.ResultItemData>! = nil
    static let titleElementKind = "title-element-kind"
    
    
    //ResultInfo CollectionView Related Components
    var resultInfoCollectionView: UICollectionView!
    var resultInfoDataSource: UICollectionViewDiffableDataSource<ResultController.ResultItemData,ResultController.ResultItemDetails>! = nil
    var resultInfoSnapshot: NSDiffableDataSourceSnapshot<ResultController.ResultItemData,ResultController.ResultItemDetails>! = nil
    
    
    //View Heights
    let fullView: CGFloat = 100
    let inset : CGFloat = 300
    var partialView: CGFloat  {
        return UIScreen.main.bounds.height - (closeButton.frame.maxY + inset + UIApplication.shared.statusBarFrame.height)
    }
    
    //Handle bar
    var handleAreaView : UIView!
    
    //close view button in result view
    var closeButton = UIButton(type: .custom)
    var closeBtnImage : UIImage!
    
    
    //Blurred background
    var bluredView : UIVisualEffectView!
    
    //Result Info View Properties (kept in this view controller but will be moved to a different one later on)
    var resultTitle : UILabel = {
        
        let text = UILabel()
        text.text = " "
        text.font = UIFont.boldSystemFont(ofSize: 26.0)
        text.textColor = UIColor.white
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.textAlignment = .left
        return text
        
    }()
    
    var resultSubtitle : UILabel = {
        
        let text = UILabel()
        text.text = "Instructions:"
        text.font = UIFont.systemFont(ofSize: 16)
        text.textColor = UIColor.lightGray
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.textAlignment = .left
        return text
        
    }()
    
    //Gif used to display instructions
    var instructionGif : GIFImageView = {
        let view = GIFImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.animate(withGIFNamed: "gymball") //Hard-coded we need to change this
        return view
    }()
    
    //back view button in result view
    var backButton = UIButton(type: .custom)
    var backBtnImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPanGesture()
        roundViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
        
        configureFilter(prediction: prediction)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPanGesture(){
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ResultViewController.panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    func roundViews() {
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
    
    
    func prepareBackgroundView(){
        
        //blur view
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
       // bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView = visualEffect
       // bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        //bluredView.frame = UIScreen.main.bounds
        view.insertSubview(visualEffect, at: 0)
        
        
        visualEffect.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        visualEffect.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        visualEffect.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        visualEffect.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        
        //handle area
        handleAreaView = UIView()
        handleAreaView.backgroundColor = .white
        handleAreaView.layer.cornerRadius = 2.5
        handleAreaView.frame = CGRect(origin: CGPoint(x: (self.view.frame.width / 2) - 15 , y: 5 ), size: CGSize(width: 36, height: 5
        ))
        visualEffect.contentView.addSubview(handleAreaView)
        
        //close button
        setupResultCloseButton(background: bluredView)
        setupTitle(background: visualEffect)
        setupResultCollectionView(background: visualEffect)
        setupBackButton()
        backButton.isHidden = true
        
    }
    
    func setupTitle(background: UIVisualEffectView){
        
        for result in results{
            let tag = result.tag
            let title = result.result
            if tag == prediction{
                resultTitle.text = title
            }
        }
        
        background.contentView.addSubview(resultTitle)
        resultTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        resultTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        resultTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10).isActive = true
        // resultTitle.bottomAnchor.constraint(equalTo: resultCollectionView.topAnchor, constant: 10).isActive = true
        
        
    }
    
    func setupResultCollectionView(background: UIVisualEffectView){
        
        resultCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createCompositionalLayout())
        resultCollectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        resultCollectionView.backgroundColor = .clear
        resultCollectionView.delegate = self
        resultCollectionView.isScrollEnabled = true
        background.contentView.addSubview(resultCollectionView)
        
        pin(selectedView: resultCollectionView)
        
        resultCollectionView.register(SectionHeader.self,forSupplementaryViewOfKind: ResultViewController.titleElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        resultCollectionView.register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.reuseIdentifier)
        
        
        
        createDataSource()
        //reloadData()
        
        
    }
    
    //MARK: View Controller Controls Handlers
    func setupResultCloseButton(background: UIVisualEffectView){
        
        //set the button size & image
        let btnsizeConfig = UIImage.SymbolConfiguration(scale: .large)
        closeBtnImage = UIImage(systemName: "xmark.circle.fill",withConfiguration: btnsizeConfig)
        let clearBtnImage = closeBtnImage.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        //set up button
        //closeButton.setTitle("Close Button", for: .normal)
        closeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        closeButton.setImage(clearBtnImage, for: .normal)
        closeButton.contentHorizontalAlignment = .right
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(handleCloseView), for: .touchUpInside)
        
        background.contentView.addSubview(closeButton)
        
        
        //constraints
        closeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -12.5).isActive = true
        closeButton.topAnchor.constraint(equalTo: background.topAnchor, constant: 5).isActive = true
        
    }
    
    //Bubble Tap Function Call
    @objc func handleCloseView(sender: UIButton!){
        
        print("Tapped close!")
        
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: 800, width: frame.width, height: frame.height)
            self.view.alpha = 0
        })
        
        
    }
    
    //TODO: We would need to create a boiler plate method for creating buttons in our app, these funtions are getting too repetitive
    func setupBackButton(){
        
        //Button Image Config
        let btnSizeConfig = UIImage.SymbolConfiguration(scale: .large)
        backBtnImage = UIImage(systemName: "arrow.left", withConfiguration: btnSizeConfig)
        let clearBtnImage = backBtnImage.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        //setup button
        backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backButton.setImage(clearBtnImage, for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        bluredView.contentView.addSubview(backButton)
        
        
    }
    
    @objc func handleBackButton(sender: UIButton!){
        print("Back button tapped!")
        
        
    }
    
    //Pan Gesture Handler
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: nil)
        }
    }
    
    func pin(selectedView: UIView){
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.topAnchor.constraint(equalTo: resultTitle.bottomAnchor, constant: 5).isActive = true
        selectedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        selectedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        selectedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

//MARK: Result CollectionView Manager Functions
extension ResultViewController {
    
    //Configure any kind of cell belonging to the protocol "SelfConfiguringCell"
    func createDataSource(){
        print("createDataSource() called")
        resultDataSource = UICollectionViewDiffableDataSource<ResultController.SupplementCollection,ResultController.ResultItemData>(collectionView: resultCollectionView){(collectionView: UICollectionView,indexPath: IndexPath,item: ResultController.ResultItemData) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  ResultCell.reuseIdentifier, for: indexPath) as? ResultCell else {
                fatalError("Error occured while creating a new cell")
            }
            // cell.titleLabel.text = supplement
            
            
            return cell
        }
        
        resultDataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }
            
            // Get a supplementary view of the desired kind.
            if let titleSupplementary = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseIdentifier,
                for: indexPath) as? SectionHeader {
                
                // Populate the view with our section's description.
                let resultData = snapshot.sectionIdentifiers[indexPath.section]
                titleSupplementary.resultSubtitle.text = resultData.title
                
                // Return the view.
                return titleSupplementary
            } else {
                fatalError("Cannot create new supplementary")
            }
            
        }
        currentSnapshot = NSDiffableDataSourceSnapshot
            <ResultController.SupplementCollection,ResultController.ResultItemData>()
        
        resultController.collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.supplements)
            
        }
        resultDataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    func reloadData(){
        
        var resultSnapshot = NSDiffableDataSourceSnapshot<ResultController.SupplementCollection,ResultController.ResultItemData>()
        
        resultController.collections.forEach {
            let collection = $0
            resultSnapshot.appendSections([collection])
            resultSnapshot.appendItems(collection.supplements)
        }
        
        resultDataSource?.apply(resultSnapshot)
        
    }
    
    //Filter through tag function used for filtering our model
    func configureFilter(prediction: String?){
        print("configureFilter() called")
        let resultData = resultController.filteredResults(with: prediction).sorted { $0.tag < $1.tag }
        var snapshot = NSDiffableDataSourceSnapshot<ResultController.SupplementCollection,ResultController.ResultItemData>()
        
        resultController.collections.forEach {
            let collection = $0
            
            snapshot.appendSections([collection])
            snapshot.appendItems(collection.supplements)
        }
        
        resultCount = resultData.count
        
        print("prediction: \(prediction) , results assembled: \(resultData)")
        
        
        resultDataSource?.apply(snapshot, animatingDifferences: true)
        
    }
    
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { index, layoutEnvironment in
            let result = self.results[index]
            
            switch result.tag{
            default:
                return self.createResultSection(using: result)
                // return self.createSecondRowSection(using: result)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createResultSection(using result: ResultController.ResultData) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(210))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: ResultViewController.titleElementKind, alignment: .top)
        
        
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        return layoutSection
        
    }
    
    //Filter through tag function used for filtering our model
    //TODO: We would need to use a tableview to hold the collectionview
    //    func configureFilter(prediction: String?){
    //
    //        let resultData = resultController.filteredResults(with: prediction).sorted { $0.tag < $1.tag }
    //        var snapshot = NSDiffableDataSourceSnapshot<ResultController.ResultData, ResultController.ResultItemData>()
    //
    //        resultData.forEach {
    //            let collection = $0
    //            snapshot.appendSections([collection])
    //            snapshot.appendItems(collection.info)
    //
    //            configureCustomFilter(query: $0)
    //        }
    //
    //        resultCount = resultData.count
    //
    //        print("prediction: \(prediction) , results assembled: \(resultData)")
    //
    //
    //        resultDataSource?.apply(snapshot, animatingDifferences: true)
    //
    //    }
    
    //TODO: Implement this method for when result is selected/tapped on
    //Filter through data for the query provided
    func configureCustomFilter(query: ResultController.ResultData){
        
        //Retrieve data from controller based on what components are found in the list
        
        
        //break down all possible components in the result item
        
        
        //look for a match based on each element
        
        //        let resultData = resultController.filteredResultItems(with: query).sorted {
        //            $0.info.first!.components < $1.info.first!.components
        // }
        
        var snapshot = NSDiffableDataSourceSnapshot<ResultController.ResultData, ResultController.ResultItemData>()
        
        //        resultData.forEach {
        //            let collection = $0
        //            snapshot.appendSections([collection])
        //            snapshot.appendItems(collection.info)
        //        }
        //
        //        resultCount = resultData.count
        
        //   print("prediction: \(prediction) , results assembled: \(resultData)")
        
        //   dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    
}

//MARK: CollectionView Delegate Functions
extension ResultViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("did select item")
        
        if let cell = collectionView.cellForItem(at: indexPath) as?  ResultCell{
            
            for result in results{
                
                if result.tag == prediction{
                    cell.data = result.info[indexPath.row]
                }
                
            }
            
            print("Selected cell: \(String(describing: cell.data?.name))")
            
            let resultData = cell.data
            
            //remove the collectionview for results and display info
            displayInfo(data: resultData!)
            resultCollectionView.removeFromSuperview()
        }
        
    }
    
}

//MARK: Display Result Info Functions
extension ResultViewController{
    
    //Show result info when tapped
    //display info from the cell retrieved
    func displayInfo(data: ResultController.ResultItemData){
        
        //TODO: Implement back button
        backButton.isHidden = false
        //constraints
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 10).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive = true
        
        //change title name
        resultTitle.text = data.name
        
        //Setup CollectionView
        setupResultInfoCollectionView()
      //  resultInfoCollectionView.isHidden = false
        createResultInfoDataSource(info: data)
        
    }
    
    func setupResultInfoCollectionView(){
        
        resultInfoCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createLayout())
        resultInfoCollectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        resultInfoCollectionView.backgroundColor = .clear
        resultInfoCollectionView.delegate = self
        resultInfoCollectionView.isScrollEnabled = true
        
        bluredView.contentView.addSubview(resultInfoCollectionView)
        
        pin(selectedView: resultInfoCollectionView)
        
        resultCollectionView.register(InfoCell.self, forCellWithReuseIdentifier: InfoCell.reuseIdentifier)
        
    }
    
    func createResultInfoDataSource(info: ResultController.ResultItemData){
        print("createResultInfoDataSource() called")
        
        resultInfoDataSource = UICollectionViewDiffableDataSource<ResultController.ResultItemData,ResultController.ResultItemDetails>(collectionView: resultInfoCollectionView){(collectionView: UICollectionView,indexPath: IndexPath,details: ResultController.ResultItemDetails) -> UICollectionViewCell? in
            
             
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  InfoCell.reuseIdentifier, for: indexPath) as? InfoCell else {
                fatalError("Error occured while creating a new cell")
            }
            
            
            return cell
        }
        
        resultInfoSnapshot = NSDiffableDataSourceSnapshot<ResultController.ResultItemData,ResultController.ResultItemDetails>()
        
        resultController.collections.forEach {
            let collection = $0
            collection.supplements.forEach{
                let item = $0
                if item == info{
                    resultInfoSnapshot.appendSections([item])
                    resultInfoSnapshot.appendItems(item.details)
                }
            }
            
            
        }
        resultInfoDataSource.apply(resultInfoSnapshot, animatingDifferences: true)
    }
    
    
    
    
}

//MARK: Collection View Compositional Layout Creator
extension ResultViewController{
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // if we have the space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                   heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: ResultViewController.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

//MARK: Gesture Recogniser Handler Functions
extension ResultViewController{
    //func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //    let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
    //    let direction = gesture.velocity(in: view).y
    //
    //    let y = view.frame.minY
    //    if (y == fullView && resultCollectionView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
    //        resultCollectionView.isScrollEnabled = false
    //    } else {
    //        resultCollectionView.isScrollEnabled = true
    //    }
    //
    //    return false
    //}
}

// bluredView.contentView.addSubview(resultTitle)
//        resultTitle.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20).isActive = true
//        resultTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
//        // resultTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
//        resultTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10).isActive = true
//subTitle.text = resultsCell.data?.title

//        //Result Subtitle setup
//        bluredView.contentView.addSubview(resultSubtitle)
//        resultSubtitle.topAnchor.constraint(equalTo: resultTitle.bottomAnchor, constant: 2).isActive = true
//        resultSubtitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
//        resultSubtitle.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//
//GIF representation
//        bluredView.contentView.addSubview(instructionGif)
//        instructionGif.translatesAutoresizingMaskIntoConstraints = false
//        //width
//        instructionGif.widthAnchor.constraint(equalToConstant: 500).isActive = true
//        //height
//        instructionGif.heightAnchor.constraint(equalToConstant: 400).isActive = true
//        //x position
//        instructionGif.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        //y position
//        instructionGif.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: -50).isActive = true

        
        
