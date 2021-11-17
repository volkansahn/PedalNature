//
//  CreateAnimationSelectionTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 15.11.2021.
//

import UIKit

protocol CreateAnimationSelectionTableViewCellDelegate: AnyObject{
    func elevationState(state: Bool)
    func durationState(state: Bool)
    func distanceState(state: Bool)
}

final class CreateAnimationSelectionTableViewCell: UITableViewCell {
    
    // MARK: Variable Decleration
    
    static let identifier = "CreateAnimationSelectionTableViewCell"
    
    public var delegate: CreateAnimationSelectionTableViewCellDelegate?
    
    private let actionContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let elevationSelectionLabel : UILabel = {
        let label = UILabel()
        label.text = "Elevation"
        label.font = .systemFont(ofSize: 17, weight: .bold)
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
        label.font = .systemFont(ofSize: 17, weight: .bold)
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
        label.font = .systemFont(ofSize: 17, weight: .bold)
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
        //For selections
        contentView.addSubview(elevationSelectionLabel)
        contentView.addSubview(elevationSelectionSwitch)
        contentView.addSubview(durationSelectionLabel)
        contentView.addSubview(durationSelectionSwitch)
        contentView.addSubview(distanceSelectionLabel)
        contentView.addSubview(distanceSelectionSwitch)
        elevationSelectionSwitch.addTarget(self, action: #selector(elevationStateChange(_:)), for: .valueChanged)
        durationSelectionSwitch.addTarget(self, action: #selector(durationStateChange(_:)), for: .valueChanged)
        distanceSelectionSwitch.addTarget(self, action: #selector(distanceStateChange(_:)), for: .valueChanged)
        
    }
    
    @objc func elevationStateChange(_ sender:UISwitch){
        let state = sender.isOn
        delegate?.elevationState(state: state)
    }
    
    @objc func durationStateChange(_ sender:UISwitch){
        let state = sender.isOn
        delegate?.durationState(state: state)
    }
    
    @objc func distanceStateChange(_ sender:UISwitch){
        let state = sender.isOn
        delegate?.distanceState(state: state)
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
        
        elevationSelectionLabel.frame = CGRect(x: Int(actionContainerView.left) + 10,
                                 y: Int(actionContainerView.top),
                                 width: Int(actionContainerView.width/2.0) - 20,
                                 height: goToViewHeights)
        
        elevationSelectionSwitch.frame = CGRect(x: Int(actionContainerView.width)-40,
                                           y: Int(actionContainerView.top),
                                           width: goToViewHeights,
                                           height: goToViewHeights)
        
        durationSelectionLabel.frame = CGRect(x: Int(actionContainerView.left) + 10,
                                   y: Int(elevationSelectionLabel.bottom) + padding,
                                   width: Int(actionContainerView.width/2.0) - 20,
                                   height: goToViewHeights)
        
        durationSelectionSwitch.frame = CGRect(x: Int(actionContainerView.width)-40,
                                            y: Int(elevationSelectionSwitch.bottom) + padding,
                                            width: goToViewHeights,
                                            height: goToViewHeights)
        
        distanceSelectionLabel.frame = CGRect(x: Int(actionContainerView.left) + 10,
                                 y: Int(durationSelectionLabel.bottom) + padding,
                                 width: Int(actionContainerView.width/2.0) - 20,
                                 height: goToViewHeights)
        
        distanceSelectionSwitch.frame = CGRect(x: Int(actionContainerView.width)-40,
                                      y: Int(durationSelectionSwitch.bottom) + padding,
                                      width: goToViewHeights,
                                      height: goToViewHeights)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
