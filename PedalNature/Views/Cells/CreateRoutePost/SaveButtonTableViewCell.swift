//
// SaveButtonTableViewCell.swift
// PedalNature
//
// Created by Volkan on 10.11.2021.
//
import UIKit

protocol SaveButtonTableViewCellDelegate : AnyObject{
    func savePressed()
}

class SaveButtonTableViewCell: UITableViewCell {
    
    static let identifier = "SaveButtonTableViewCell"
    
    public var delegate : SaveButtonTableViewCellDelegate?
    
    private let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save Route", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor(rgb: 0x5da973)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Save Button
        contentView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
    }
    
    @objc func savePressed(){
        delegate?.savePressed()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonWidth = 100
        saveButton.frame = CGRect(x: Int(contentView.width)/2-buttonWidth/2,
                                  y: 30,
                                  width: buttonWidth,
                                  height: Int(contentView.height)-60)

        }
}
