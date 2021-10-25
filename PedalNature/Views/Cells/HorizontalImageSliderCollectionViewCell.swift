//
//  HorizontalImageSliderCollectionViewCell.swift
//  PedalNature
//
//  Created by Volkan on 24.10.2021.
//

import UIKit

final class HorizontalImageSliderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HorizontalImageSliderCollectionViewCell"
    
    private let routePhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
        
    override func layoutSubviews(){
        super.layoutSubviews()
        routePhotoImageView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: contentView.width,
                                           height: contentView.height)
        
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        routePhotoImageView.image = nil
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(routePhotoImageView)

        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: RouteImage, imagelist : [RouteImage]){
        routePhotoImageView.image = model.image
        //routePhotoImageView.sd_setImage(with: imageURL, completed: nil)
    }
}
