//
//  TagAndImagesTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 10.11.2021.
//

import UIKit

protocol TagAndImagesTableViewCellDelegate : AnyObject{
    func tagPressed()
    func imagesPressed()
    func infoPressed()
}

class TagAndImagesTableViewCell: UITableViewCell {
    
    static let identifier = "TagAndImagesTableViewCell"
    
    public var delegate : TagAndImagesTableViewCellDelegate?
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tag Person"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let goToTagSearchButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let imagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Route Image"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let goToRouteImageButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Route Info"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let goToInfoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Tag
        contentView.addSubview(tagsLabel)
        contentView.addSubview(goToTagSearchButton)
        goToTagSearchButton.addTarget(self, action: #selector(didTapTagView), for: .touchUpInside)
        
        // Image
        contentView.addSubview(imagesLabel)
        contentView.addSubview(goToRouteImageButton)
        goToRouteImageButton.addTarget(self, action: #selector(didTapImagesView), for: .touchUpInside)
        
        // Info
        contentView.addSubview(infoLabel)
        contentView.addSubview(goToInfoButton)
        goToRouteImageButton.addTarget(self, action: #selector(didTapRouteInfoView), for: .touchUpInside)
        
    }
    
    //Tag
    @objc func didTapTagView(){
        delegate?.tagPressed()
    }
    //Image
    @objc func didTapImagesView(){
        delegate?.imagesPressed()
    }
    //Info
    @objc func didTapRouteInfoView(){
        delegate?.infoPressed()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let goToViewHeights = 30
        tagsLabel.frame = CGRect(x: 20,
                                 y: 0,
                                 width: Int(contentView.width/2.0) - 20,
                                 height: goToViewHeights)
        
        goToTagSearchButton.frame = CGRect(x: Int(contentView.width)-70,
                                           y: 0,
                                           width: goToViewHeights,
                                           height: goToViewHeights)
        imagesLabel.frame = CGRect(x: 20,
                                   y: Int(tagsLabel.bottom) + 30,
                                   width: Int(contentView.width/2.0) - 20,
                                   height: goToViewHeights)
        
        goToRouteImageButton.frame = CGRect(x: Int(contentView.width)-70,
                                            y: Int(goToTagSearchButton.bottom) + 30,
                                            width: goToViewHeights,
                                            height: goToViewHeights)
        infoLabel.frame = CGRect(x: 20,
                                 y: Int(imagesLabel.bottom) + 30,
                                 width: Int(contentView.width/2.0) - 20,
                                 height: goToViewHeights)
        
        goToInfoButton.frame = CGRect(x: Int(contentView.width)-70,
                                           y: Int(goToRouteImageButton.bottom) + 30,
                                           width: goToViewHeights,
                                           height: goToViewHeights)
    }
    
    
}
