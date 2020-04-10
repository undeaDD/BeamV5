//
//  ResultCell.swift
//  BeamV5
//
//  Created by Us on 03/03/2020.
//  Copyright © 2020 David Arebuwa. All rights reserved.
//

import UIKit
import Gifu


class ResultCell: UICollectionViewCell, SelfConfiguringSupplementaryCell { //SelfConfiguringCell
    
    static let reuseIdentifier: String = "ResultCell"
    
    var data: ResultController.ResultItemData? {
        didSet {
            guard let data = data else {return}
        }
    }
    
    //Title used for displaying supplement header
    let titleLabel = UILabel()
    
    var gifURL : String = ""
    
    //Gif used to displaying result
    var resultGIF : GIFImageView = {
        let view = GIFImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true //just testing this out
        view.animate(withGIFNamed: "gymball") //Hard-coded we need to change this
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with items: ResultController.SupplementCollection) {
        
       
        
        //resultGIF.animate(withGIFNamed: "gymball")
        
    }
    
    //    func configure(with item: ResultController.ResultItemData) {
    //
    //        data?.name = item.name
    //        data?.tags = item.tags
    //        data?.gif = item.gif
    //        data?.details = item.details
    //
    //
    //        //resultGIF.animate(withGIFNamed: "gymball")
    //    }
    
    
}

extension ResultCell{
    func setup(){
         
        let stackView = UIStackView(arrangedSubviews: [resultGIF]) //titleLabel,
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -45)
        ])
        
       // stackView.setCustomSpacing(10, after: titleLabel)
        
    }
}
