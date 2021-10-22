//
//  TaggedPersonTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 14.10.2021.
//

import UIKit

protocol TaggedPersonTableViewCellDelegate{
    func userNameorPhotoPressed(_ response : User)
}

class TaggedPersonTableViewCell: UITableViewCell {
    
    static let identifier = "TaggedPersonTableViewCell"
    
    public var delegate: TaggedPersonTableViewCellDelegate?
    
    private var userModal : User?
    
    private let photoContainer: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemRed
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photoContainer)
        contentView.addSubview(userName)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserInfo))
        photoContainer.addGestureRecognizer(gesture)
        photoContainer.isUserInteractionEnabled = true
        let namegesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserInfo))
        userName.addGestureRecognizer(namegesture)
        userName.isUserInteractionEnabled = true
    }
    
    @objc private func didTapUserInfo(){
        delegate?.userNameorPhotoPressed(userModal!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let photoSize = contentView.height - 10
        photoContainer.frame = CGRect(x: 5,
                                      y: 5,
                                      width: photoSize,
                                      height: photoSize)
        photoContainer.layer.cornerRadius = photoSize/2
        
        userName.frame = CGRect(x: photoContainer.right+5,
                                y: 5,
                                width: contentView.width/3-photoSize,
                                height: photoSize)
    }
    
    public func configure(with modal: User){
        userModal = modal
        photoContainer.image = nil
        userName.text = modal.userName
        return
        photoContainer.sd_setImage(with: modal.profilePhoto, completed: nil)
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        photoContainer.image = nil
        userName.text = nil
    }
}
