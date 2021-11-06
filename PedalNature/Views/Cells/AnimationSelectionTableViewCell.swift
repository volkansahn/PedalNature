//
//  AnimationSelectionTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 4.11.2021.
//

import UIKit

protocol AnimationSelectionTableViewCellDelegate : AnyObject{
    
    func switchTriggered(switchLabel : String, state: Bool)
    
}

class AnimationSelectionTableViewCell: UITableViewCell {
    
    static let identifier = "AnimationSelectionTableViewCell"
    
    private var selectedSwitch = String()
    
    public var delegate: AnimationSelectionTableViewCellDelegate?
    
    private let selectionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let selectionSwitch : UISwitch = {
        let uiswitch = UISwitch()
        return uiswitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(selectionLabel)
        contentView.addSubview(selectionSwitch)
        
        selectionSwitch.addTarget(self, action: #selector(switchStateChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchStateChanged(_ sender:UISwitch){
        let state = sender.isOn
        delegate?.switchTriggered(switchLabel : selectedSwitch, state: state)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let switchWidth = 80.0
        selectionLabel.frame =  CGRect(x: 20,
                                       y: contentView.top + 10.0,
                                       width: contentView.width - switchWidth - 10.0,
                                       height: contentView.height - 20.0)
        
        selectionSwitch.frame = CGRect(x: contentView.width - 10.0 - switchWidth,
                                       y: contentView.top + 10.0,
                                       width: switchWidth,
                                       height: contentView.height - 20.0)
    }
    
    
    public func configure(with label: String){
        selectedSwitch = label
        selectionLabel.text = label
    }
    
}
