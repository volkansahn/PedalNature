//
//  SearchFilterCollectionViewCell.swift
//  PedalNature
//
//  Created by Volkan on 7.10.2021.
//

import UIKit

protocol SearchFilterCollectionViewCellDelegate : AnyObject{
    func didTapLocationResultResponse()
    func didTapRouteNameResultResponse()
    func didTapUserNameResultResponse()
}

class SearchFilterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchFilterCollectionViewCell"
    
    var delegate: SearchFilterCollectionViewCellDelegate?
    
    private let locationResultsButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitle("Locations", for: .normal)
        return button
    }()
    
    private let userNameResultsButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitle("Users", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(locationResultsButton)
        contentView.addSubview(userNameResultsButton)
        contentView.backgroundColor = .systemBackground
        locationResultsButton.addTarget(self,
                                  action: #selector(didTapLocationResultsButton),
                                  for: .touchUpInside)
        userNameResultsButton.addTarget(self,
                                        action: #selector(didTapUserNameResultsButton),
                                        for: .touchUpInside)
        locationResultsButton.backgroundColor = .secondarySystemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLocationResultsButton(){
        delegate?.didTapLocationResultResponse()
        locationResultsButton.backgroundColor = .secondarySystemBackground
        userNameResultsButton.backgroundColor = .systemBackground

    }
    
    @objc func didTapUserNameResultsButton(){
        delegate?.didTapUserNameResultResponse()
        userNameResultsButton.backgroundColor = .secondarySystemBackground
        locationResultsButton.backgroundColor = .systemBackground
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        let widthSize = contentView.width/2
        locationResultsButton.frame = CGRect(x: 0,
                                             y: 0,
                                             width: widthSize,
                                             height: contentView.height)
        
        userNameResultsButton.frame = CGRect(x: locationResultsButton.right,
                                             y: 0,
                                             width: widthSize,
                                             height: contentView.height)
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        locationResultsButton.backgroundColor = .secondarySystemBackground
        userNameResultsButton.backgroundColor = .systemBackground
    }

}
