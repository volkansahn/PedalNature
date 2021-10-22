//
//  NameResultTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 6.10.2021.
//

import UIKit

class NameResultTableViewCell: UITableViewCell {

    static let identifier = "NameResultTableViewCell"
    
    private let profilePhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    private let userNameLabel : UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let followUnfollowButton : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(profilePhotoImageView)
        contentView.addSubview(userNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = height - 5
        profilePhotoImageView.frame = CGRect(x: 5,
                                             y: (contentView.height - size)/2,
                                             width: size,
                                             height: size)
        profilePhotoImageView.layer.cornerRadius = size/2
        let userNameWidth = (3*(contentView.width - size - 5))/4
        userNameLabel.frame = CGRect(x: profilePhotoImageView.right + 10,
                                     y:  (contentView.height - size)/2,
                                     width: userNameWidth,
                                     height: size)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePhotoImageView.image = nil
        userNameLabel.text = nil
    }
    
    public func configure(with modal: User){
        profilePhotoImageView.sd_setImage(with: modal.profilePhoto, completed: nil)
        userNameLabel.text = modal.userName
    }

}
