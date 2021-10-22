//
//  RouteCollectionViewCell.swift
//  PedalNature
//
//  Created by Volkan on 30.09.2021.
//

import SDWebImage
import UIKit

class RouteCollectionViewCell: UICollectionViewCell {
    static let identifier = "RouteCollectionViewCell"

    private let routeMapPhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
 
    private let routeElevationPhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let routeNameLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let routeLengthLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let routeDurationLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    override func layoutSubviews(){
        super.layoutSubviews()
        routeNameLabel.frame = CGRect(x: 0,
                                      y: contentView.top + 10,
                                      width: contentView.width/2,
                                      height: contentView.height/10)
        
        routeLengthLabel.frame = CGRect(x: routeNameLabel.right,
                                      y: contentView.top + 10,
                                        width: (contentView.width - routeNameLabel.width)/2,
                                      height: contentView.height/10)
        
        routeDurationLabel.frame = CGRect(x: routeLengthLabel.right,
                                      y: contentView.top + 10,
                                      width: (contentView.width - routeNameLabel.width)/2,
                                      height: contentView.height/10)
        
        routeMapPhotoImageView.frame = CGRect(x: 0,
                                           y: routeNameLabel.bottom,
                                           width: contentView.width,
                                           height: 9 * (contentView.height/10))
        
        routeElevationPhotoImageView.frame = CGRect(x: routeMapPhotoImageView.width - routeMapPhotoImageView.width/4,
                                                    y: routeMapPhotoImageView.height - routeMapPhotoImageView.height/4,
                                           width: routeMapPhotoImageView.width/4,
                                           height: routeMapPhotoImageView.height/4)
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        routeMapPhotoImageView.image = nil
        routeNameLabel.text = nil
        routeLengthLabel.text = nil
        routeDurationLabel.text = nil
        routeElevationPhotoImageView.image = nil
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(routeMapPhotoImageView)
        contentView.addSubview(routeNameLabel)
        contentView.addSubview(routeLengthLabel)
        contentView.addSubview(routeDurationLabel)
        contentView.addSubview(routeElevationPhotoImageView)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserRoute){
        let imageURL = model.routeMapImage
        routeMapPhotoImageView.sd_setImage(with: imageURL, completed: nil)
    }
    
    
    public func configure(debug text: String){
        routeNameLabel.text = "Test Route"
        routeLengthLabel.text = "1 km"
        routeDurationLabel.text = "1h30m"
        routeMapPhotoImageView.image = UIImage(named: "test")
        routeElevationPhotoImageView.image = UIImage(named: "elevationtest")
    }
    
}
