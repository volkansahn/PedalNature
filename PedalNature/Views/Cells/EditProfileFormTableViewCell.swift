//
//  EditProfileFormTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 29.09.2021.
//

import UIKit
//Return field value
protocol EditProfileFormTableViewDelegate: AnyObject{
    func formTableViewCell(_ cell: EditProfileFormTableViewCell, didUpdateField updatedModal: EditProfileFormModal)
}

class EditProfileFormTableViewCell: UITableViewCell {

    public let formLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    public let formField : UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()
    
    public weak var delegate : EditProfileFormTableViewDelegate?
    
    static let identifier = "EditProfileFormTableViewCell"
    
    private var modal: EditProfileFormModal?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        formField.delegate = self
        contentView.addSubview(formLabel)
        contentView.addSubview(formField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with modal: EditProfileFormModal){
        self.modal = modal
        formLabel.text = modal.label
        formField.placeholder = modal.placeHolder
        formField.text = modal.value
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        formLabel.text = nil
        formField.placeholder = nil
        formField.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        formLabel.frame = CGRect(x: 10,
                                 y: 0,
                                 width: contentView.width/3,
                                 height: contentView.height)
        formField.frame = CGRect(x: formLabel.right + 5,
                                 y: 0,
                                 width: contentView.width - 10 - formLabel.width,
                                 height: contentView.height)
    }
    
}

extension EditProfileFormTableViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        modal?.value = textField.text
        guard let modal = modal else{
            return true
        }
        delegate?.formTableViewCell(self, didUpdateField: modal)
        textField.resignFirstResponder()
        return true
    }
}
