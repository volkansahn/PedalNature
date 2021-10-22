//
//  ProfileInfoHeaderCollectionReusableView.swift
//  PedalNature
//
//  Created by Volkan on 30.09.2021.
//

import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject{
    func profileHeaderDidTapRoutesButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowerButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapSeeBioButton(_ header: ProfileInfoHeaderCollectionReusableView)
}

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private let profilePhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Volkan Sahin"
        return label
    }()
    
    private let seeBioButton: UIButton={
        let button = UIButton()
        button.setTitle("See Bio", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let routesButton : UIButton = {
        let button = UIButton()
        button.setTitle("Routes", for: .normal)
        return button
    }()
    
    private let followerButton : UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        return button
    }()
    
    private let followingButton : UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addButtonActions()
        backgroundColor = .systemBackground
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profilePhotoSize = width/4
        profilePhotoImageView.frame = CGRect(x: 5,
                                             y: 5,
                                             width: profilePhotoSize,
                                             height: profilePhotoSize).integral
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2
        
        let buttonHeight = profilePhotoSize/2
        let countButtonWidth = (width - 10 - profilePhotoSize)/3
        
        routesButton.frame = CGRect(x: profilePhotoImageView.right,
                                    y: 5,
                                    width: countButtonWidth,
                                    height: buttonHeight).integral
        
        followerButton.frame = CGRect(x: routesButton.right,
                                      y: 5,
                                      width: countButtonWidth,
                                      height: buttonHeight).integral
        
        followingButton.frame = CGRect(x: followerButton.right,
                                      y: 5,
                                      width: countButtonWidth,
                                      height: buttonHeight).integral
        
        nameLabel.frame = CGRect(x: 5,
                                      y: 5 + profilePhotoSize,
                                      width: countButtonWidth,
                                      height: buttonHeight).integral
        
        seeBioButton.frame = CGRect(x: 5,
                                       y: nameLabel.bottom,
                                      width: profilePhotoSize,
                                      height: 50).integral
        
    }
    
    private func addSubviews(){
        addSubview(profilePhotoImageView)
        addSubview(nameLabel)
        addSubview(followerButton)
        addSubview(followingButton)
        addSubview(routesButton)
        addSubview(nameLabel)
        addSubview(seeBioButton)
    }
    
    private func addButtonActions(){
        routesButton.addTarget(self,
                               action: #selector(didTapRoutesButton),
                               for: .touchUpInside)
        followerButton.addTarget(self,
                               action: #selector(didTapFollowerButton),
                               for: .touchUpInside)
        followingButton.addTarget(self,
                               action: #selector(didTapFollowingButton),
                               for: .touchUpInside)
        seeBioButton.addTarget(self,
                               action: #selector(didTapSeeBioButton),
                               for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc func didTapRoutesButton(){
        delegate?.profileHeaderDidTapRoutesButton(self)
    }
    
    @objc func didTapFollowerButton(){
        delegate?.profileHeaderDidTapFollowerButton(self)
    }
    
    @objc func didTapFollowingButton(){
        delegate?.profileHeaderDidTapFollowingButton(self)
    }
    
    @objc func didTapSeeBioButton(){
        delegate?.profileHeaderDidTapSeeBioButton(self)
    }
}
