//
//  CreateRouteInfoTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 12.10.2021.
//

import UIKit

final class CreateRouteInfoTableViewCell: UITableViewCell {
    
    static let identifier = "CreateRouteInfoTableViewCell"
    
    private let durationHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.text = "Duration"
        label.numberOfLines = 1
        return label
    }()
    
    private let distanceHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.text = "Distance"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxSpeedHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.text = "Max.Speed"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxElevationHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.text = "Max.Elevation"
        label.numberOfLines = 1
        return label
    }()
    
    private let durationLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.text = "1h30d"
        label.numberOfLines = 1
        return label
    }()
    
    private let distanceLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.text = "1.37km"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxSpeedLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.text = "22m/sn"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxElevationLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.text = "750m"
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(durationHeaderLabel)
        contentView.addSubview(distanceHeaderLabel)
        contentView.addSubview(maxSpeedHeaderLabel)
        contentView.addSubview(maxElevationHeaderLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(maxSpeedLabel)
        contentView.addSubview(maxElevationLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        durationHeaderLabel.frame = CGRect(x: 0,
                                           y: 0,
                                           width: contentView.width/4-10,
                                           height: contentView.height/3)
        
        distanceHeaderLabel.frame = CGRect(x: durationHeaderLabel.right,
                                           y: 0,
                                           width: contentView.width/4,
                                           height: contentView.height/3)
        
        maxSpeedHeaderLabel.frame = CGRect(x: distanceHeaderLabel.right,
                                           y: 0,
                                           width: contentView.width/4,
                                           height: contentView.height/3)
        
        maxElevationHeaderLabel.frame = CGRect(x: maxSpeedHeaderLabel.right,
                                               y: 0,
                                               width: contentView.width/4+10,
                                               height: contentView.height/3)
        
        durationLabel.frame = CGRect(x: 0,
                                     y: durationHeaderLabel.bottom,
                                     width: contentView.width/4-10,
                                     height: 2*contentView.height/3)
        
        distanceLabel.frame = CGRect(x: durationLabel.right,
                                     y: distanceHeaderLabel.bottom,
                                     width: contentView.width/4,
                                     height: 2*contentView.height/3)
        
        maxSpeedLabel.frame = CGRect(x: distanceLabel.right,
                                     y: maxSpeedHeaderLabel.bottom,
                                     width: contentView.width/4,
                                     height: 2*contentView.height/3)
        
        maxElevationLabel.frame = CGRect(x: maxSpeedLabel.right,
                                         y: maxElevationHeaderLabel.bottom,
                                         width: contentView.width/4+10,
                                         height: 2*contentView.height/3)
    }
    
    public func configure(duration : String, distance : String, maxElevation : String, maxSpeed: String){
        durationLabel.text = duration
        distanceLabel.text = "\(distance)km"
        maxSpeedLabel.text = "\(maxSpeed)m/sn"
        maxElevationLabel.text = "\(maxElevation)m"
    }
}
