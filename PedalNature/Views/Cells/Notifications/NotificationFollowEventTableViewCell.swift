//
//  NotificationFollowEventTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 2.10.2021.
//

import UIKit
import SDWebImage

protocol NotificationFollowEventTableViewCellDelegate: AnyObject{
    func didTapFollowUnFollowButton(modal: UserNotification)
}

class NotificationFollowEventTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationFollowEventTableViewCell"
    
    private var modal: UserNotification?
    
    private let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemRed
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Volkan starts to follow you"
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    weak var delegate: NotificationFollowEventTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(notificationImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        followButton.addTarget(self,
                               action: #selector(didTapFollowButton), for: .touchUpInside)
        configureForFollow()
        configureForUnFollow()
        selectionStyle = .none
    }
    
    @objc func didTapFollowButton(){
        guard let modal = modal else {
            return
        }

        delegate?.didTapFollowUnFollowButton(modal: modal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        notificationImageView.frame = CGRect(x: 3,
                                             y: 3,
                                             width: contentView.height-6,
                                             height: contentView.height-6)
        notificationImageView.layer.cornerRadius = notificationImageView.height/2
        let size = contentView.height-4
        followButton.frame = CGRect(x: contentView.width - 100 - 5,
                                    y: (contentView.height-40)/2,
                                        width: 100,
                                        height: 40)
        label.frame = CGRect(x: notificationImageView.right + 5,
                             y: 0,
                             width: contentView.width-notificationImageView.width-size-16,
                             height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        notificationImageView.image = nil
        label.text = nil
        followButton.layer.borderWidth = 0
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
        
    }
    
    public func configure(with modal: UserNotification){
        self.modal = modal
        switch modal.type{
        case .like(let post):
            break
        case .follow(let state):
            switch state{
            case .following:
                configureForUnFollow()
            case .notFollowing:
                configureForFollow()
            }
            break
            
        }
        label.text = modal.text
        notificationImageView.sd_setImage(with: modal.user.profilePhoto, completed: nil)
        
    }
    
    private func configureForUnFollow(){
        followButton.setTitle("Unfollow", for: .normal)
        followButton.setTitleColor(.label, for: .normal)
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        followButton.backgroundColor = .none
    }
    
    private func configureForFollow(){
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.borderWidth = 0
        followButton.backgroundColor = .link
    }
}
