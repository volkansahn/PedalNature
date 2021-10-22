//
//  UserFollowTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 30.09.2021.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject{
    func didTapFollowUnFollowButton(modal: UserRelationShip)
}

public enum FollowState{
    case following // shows if the current user follow the other person
    case notFollowing // shows if the current user not follow the other person
}

struct UserRelationShip{
    let userName:String
    let type: FollowState
}

final class UserFollowTableViewCell: UITableViewCell {

    static let identifier = "UserFollowTableViewCell"
    
    weak var delegate: UserFollowTableViewCellDelegate?
    
    private var modal: UserRelationShip?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Melike"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    public func configure(with modal : UserRelationShip){
        self.modal = modal
        nameLabel.text = modal.userName
        switch modal.type{
        case .following:
            // Show follow Button
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
        case .notFollowing:
            // show Unfollow
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(followButton)
        selectionStyle = .none
        followButton.addTarget(self,
                               action: #selector(didTapFollowUnFollowButton),
                               for: .touchUpInside)
    }
    
    override func prepareForReuse(){
        profileImageView.image = nil
        nameLabel.text = nil
        followButton.setTitle(nil, for: .normal)
        followButton.setBackgroundImage(nil, for: .normal)
        followButton.backgroundColor = nil
        followButton.layer.borderColor = nil
        followButton.layer.borderWidth = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.height - 6
        profileImageView.frame = CGRect(x: 3,
                                        y: 3,
                                        width: size,
                                        height: size)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        
        let labelHeight = contentView.height/2
        let buttonWidth = contentView.width > 500 ? 220: contentView.width/3
        
        nameLabel.frame = CGRect(x: profileImageView.right+5,
                                 y: contentView.height/4,
                                 width: contentView.width-3-profileImageView.width-buttonWidth,
                                 height: labelHeight)
        
        followButton.frame = CGRect(x: contentView.width - 5 - buttonWidth,
                                    y: (contentView.height - 40)/2,
                                    width: buttonWidth,
                                    height: 40)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapFollowUnFollowButton(){
        guard let modal = modal else{
            return
        }
        delegate?.didTapFollowUnFollowButton(modal: modal)
    }
}
