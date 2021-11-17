//
// TagAndImagesTableViewCell.swift
// PedalNature
//
// Created by Volkan on 10.11.2021.
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
    
    private let actionContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    
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
        contentView.addSubview(actionContainerView)
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
        goToInfoButton.addTarget(self, action: #selector(didTapRouteInfoView), for: .touchUpInside)
        
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
        let padding = (Int(contentView.height) - (3*goToViewHeights))/4
        actionContainerView.frame = CGRect(x: contentView.left + 20.0,
                                           y: contentView.top + CGFloat(padding),
                                           width: contentView.width - 40.0,
                                           height: contentView.height - CGFloat(2*padding))
        
        actionContainerView.layer.cornerRadius = 16.0
        
        tagsLabel.frame = CGRect(x: Int(actionContainerView.left) + 10,
                                 y: Int(actionContainerView.top),
                                 width: Int(actionContainerView.width/2.0) - 20,
                                 height: goToViewHeights)
        
        goToTagSearchButton.frame = CGRect(x: Int(actionContainerView.width)-40,
                                           y: Int(actionContainerView.top),
                                           width: goToViewHeights,
                                           height: goToViewHeights)
        
        imagesLabel.frame = CGRect(x: Int(actionContainerView.left) + 10,
                                   y: Int(tagsLabel.bottom) + padding,
                                   width: Int(actionContainerView.width/2.0) - 20,
                                   height: goToViewHeights)
        
        goToRouteImageButton.frame = CGRect(x: Int(actionContainerView.width)-40,
                                            y: Int(goToTagSearchButton.bottom) + padding,
                                            width: goToViewHeights,
                                            height: goToViewHeights)
        
        infoLabel.frame = CGRect(x: Int(actionContainerView.left) + 10,
                                 y: Int(imagesLabel.bottom) + padding,
                                 width: Int(actionContainerView.width/2.0) - 20,
                                 height: goToViewHeights)
        
        goToInfoButton.frame =  CGRect(x: Int(actionContainerView.width)-40,
                                       y: Int(goToRouteImageButton.bottom) + padding,
                                       width: goToViewHeights,
                                       height: goToViewHeights)

    }
    
    
}
