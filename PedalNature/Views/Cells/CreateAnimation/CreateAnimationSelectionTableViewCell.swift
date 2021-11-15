//
//  CreateAnimationSelectionTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 15.11.2021.
//

import UIKit

class CreateAnimationSelectionTableViewCell: UITableViewCell {
    
    // MARK: Variable Decleration
    
    static let identifier = "CreateAnimationSelectionTableViewCell"
    
    private let actionContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let elevationSelectionLabel : UILabel = {
        let label = UILabel()
        label.text = "Elevation"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let elevationSelectionSwitch : UISwitch = {
        let uiswitch = UISwitch()
        return uiswitch
    }()

    private let durationSelectionLabel : UILabel = {
        let label = UILabel()
        label.text = "Duration"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let durationSelectionSwitch : UISwitch = {
        let uiswitch = UISwitch()
        return uiswitch
    }()
    
    private let distanceSelectionLabel : UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let distanceSelectionSwitch : UISwitch = {
        let uiswitch = UISwitch()
        return uiswitch
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        //Selection Container
        contentView.addSubview(actionContainerView)
        //For İmages
        
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
        /*
        tagsLabel.frame = CGRect(x: Int(actionContainerView.left) + 10,
                                 y: Int(actionContainerView.top),
                                 width: Int(actionContainerView.width/2.0) - 20,
                                 height: goToViewHeights)
        
        goToTagSearchButton.frame = CGRect(x: Int(actionContainerView.width)-20,
                                           y: Int(actionContainerView.top),
                                           width: goToViewHeights,
                                           height: goToViewHeights)
        
        imagesLabel.frame = CGRect(x: Int(actionContainerView.left) + 10,
                                   y: Int(tagsLabel.bottom) + padding,
                                   width: Int(actionContainerView.width/2.0) - 20,
                                   height: goToViewHeights)
        
        goToRouteImageButton.frame = CGRect(x: Int(actionContainerView.width)-20,
                                            y: Int(goToTagSearchButton.bottom) + padding,
                                            width: goToViewHeights,
                                            height: goToViewHeights)
        
        infoLabel.frame = CGRect(x: Int(actionContainerView.left) + 10,
                                 y: Int(imagesLabel.bottom) + padding,
                                 width: Int(actionContainerView.width/2.0) - 20,
                                 height: goToViewHeights)
        
        goToInfoButton.frame = CGRect(x: Int(actionContainerView.width)-20,
                                      y: Int(goToRouteImageButton.bottom) + padding,
                                      width: goToViewHeights,
                                      height: goToViewHeights)
        */
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
