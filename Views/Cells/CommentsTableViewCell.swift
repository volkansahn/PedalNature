//
//  CommentsTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 18.10.2021.
//

import UIKit

final class CommentsTableViewCell: UITableViewCell {
    
    static let identifier = "CommentsTableViewCell"
    
    private let userPhotoImage : UIImageView = {
        let imageView = UIImageView ()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let userName : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let commetLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let commentDateLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let commentButton :UIButton = {
        let button = UIButton()
        button.setTitle("Reply", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userPhotoImage)
        contentView.addSubview(userName)
        contentView.addSubview(commentButton)
        contentView.addSubview(commetLabel)
        contentView.addSubview(commentDateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        let photoSize = 30.0
        userPhotoImage.frame = CGRect(x: 10,
                                      y: (contentView.height - photoSize)/2,
                                      width: photoSize,
                                      height: photoSize)
        userPhotoImage.layer.cornerRadius = photoSize/2
        
        userName.frame = CGRect(x: userPhotoImage.right + 5.0,
                                y: (contentView.height - photoSize)/2,
                                width: 3*photoSize,
                                height: contentView.height - photoSize - 10.0)
        
        commetLabel.frame = CGRect(x: userName.right + 5.0,
                                    y: (contentView.height - photoSize)/2,
                                    width: contentView.width,
                                    height: contentView.height - photoSize - 10.0)
        
        commentDateLabel.frame = CGRect(x: userPhotoImage.right + 5.0,
                                        y: userName.bottom + 5.0,
                                        width: contentView.width / 2.0,
                                        height: photoSize)
        
        commentButton.frame = CGRect(x: commentDateLabel.right + 5.0,
                                     y: userName.bottom + 5.0,
                                     width: photoSize + 20.0,
                                     height: photoSize)
        
        
    }
    
    public func configure(with modal : RouteComment){
        userPhotoImage.backgroundColor = .systemBlue
        //userPhotoImage.sd_setImage(with: modal.user.profilePhoto, completed: nil)
        userName.text = modal.user.userName
        commetLabel.text = modal.text
        commentDateLabel.text = "\(modal.createdDate)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userPhotoImage.image = nil
        userName.text = nil
        commetLabel.text = nil
        commentDateLabel.text = nil
    }
    
}
