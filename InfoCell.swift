//
//  InfoCell.swift
//  BeamV5
//
//  Created by Us on 09/04/2020.
//  Copyright © 2020 David Arebuwa. All rights reserved.
//

import UIKit
import Gifu

class InfoCell: UICollectionViewCell,SelfConfiguringSupplementaryCell{
    
    static var reuseIdentifier: String = "InfoCell"
    
    var data: ResultController.ResultItemData?{
        didSet{
            guard let data = data else{return}
        }
    }
    
    var subtitle : UILabel = {
        
        let text = UILabel()
        text.text = "Target Area: "
        //text.font = UIFont.systemFont(ofSize: 16)
        text.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 16, weight: .semibold))
        text.textColor = UIColor.secondaryLabel
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.textAlignment = .left
        return text
        
    }()
    
    var gifURL : String = ""
    
    //Gif used to displaying result
    var resultInfoGIF : GIFImageView = {
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
        
        
    }
    
    
}
extension InfoCell{
    func setup(){
        
        let stackView = UIStackView(arrangedSubviews: [subtitle,resultInfoGIF])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        stackView.setCustomSpacing(10, after: subtitle)
        
    }
}
