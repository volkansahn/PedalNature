//
//  ProfileTabsCollectionReusableView.swift
//  PedalNature
//
//  Created by Volkan on 30.09.2021.
//

import UIKit

protocol ProfileTabsCollectionReusableViewDelegate: AnyObject{
    func didTapOwnRouteTap()
    func didTapTaggedRouteTap()
}

struct ProfileTapConstants{
    static let padding: CGFloat = 8
}

class ProfileTabsCollectionReusableView: UICollectionReusableView {

    static let identifier = "ProfileTabsCollectionReusableView"
    
    public weak var delegate: ProfileTabsCollectionReusableViewDelegate?
    
    private let ownRoutesButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .systemBlue
        button.setBackgroundImage(UIImage(systemName: "map"), for: .normal)
        return button
    }()
    
    private let taggedRoutesButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.setBackgroundImage(UIImage(systemName: "tag"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
        addSubview(ownRoutesButton)
        addSubview(taggedRoutesButton)
        ownRoutesButton.addTarget(self,
                                  action: #selector(didTapOwnRouteButton),
                                  for: .touchUpInside)
        taggedRoutesButton.addTarget(self,
                                  action: #selector(didTapTaggedRouteButton),
                                  for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapOwnRouteButton(){
        ownRoutesButton.tintColor = .systemBlue
        taggedRoutesButton.tintColor = .lightGray
        delegate?.didTapOwnRouteTap()
    }
    
    @objc func didTapTaggedRouteButton(){
        ownRoutesButton.tintColor = .lightGray
        taggedRoutesButton.tintColor = .systemBlue
        delegate?.didTapTaggedRouteTap()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = height-(ProfileTapConstants.padding*2)
        let ownRoutesButtonX = ((width/2)-size)/2
        ownRoutesButton.frame = CGRect(x: ownRoutesButtonX,
                                       y: ProfileTapConstants.padding,
                                       width: size,
                                       height: size)
        
        taggedRoutesButton.frame = CGRect(x: ownRoutesButtonX + (width/2),
                                          y: ProfileTapConstants.padding,
                                          width: size,
                                          height: size)
    }
}
