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
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.text = "Duration"
        label.numberOfLines = 1
        return label
    }()
    
    private let distanceHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.text = "Distance"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxSpeedHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.text = "Max.Speed"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxElevationHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.text = "Max.Elevation"
        label.numberOfLines = 1
        return label
    }()
    
    private let durationLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.text = "1h30d"
        label.numberOfLines = 1
        return label
    }()
    
    private let distanceLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.text = "1.37km"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxSpeedLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.text = "22m/sn"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxElevationLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.text = "750m"
        label.numberOfLines = 1
        return label
    }()
	
	private let durationContainerView : UIView = {
		let view = UIView()
		view.backgroundColor = .label
		view.layer.cornerRadius = 20
		return view
	}()
	
	private let distanceContainerView : UIView = {
		let view = UIView()
        view.backgroundColor = .label
        view.layer.cornerRadius = 20
		return view
	}()
	
	private let maxEleContainerView : UIView = {
		let view = UIView()
        view.backgroundColor = .label
        view.layer.cornerRadius = 20
		return view
	}()
	
	private let maxSpeedContainerView : UIView = {
		let view = UIView()
        view.backgroundColor = .label
        view.layer.cornerRadius = 20
		return view
	}()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(durationContainerView)
		contentView.addSubview(distanceContainerView)
		contentView.addSubview(maxEleContainerView)
		contentView.addSubview(maxSpeedContainerView)
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
        
		let containerSize = (contentView.width - 40)/2
		
        durationContainerView.frame = CGRect(x: 20,
                                           y: 20,
                                           width: containerSize,
                                           height: containerSize)
		
		durationHeaderLabel.frame = CGRect(x: durationContainerView.left,
                                           y: durationContainerView.top,
                                           width: containerSize,
                                           height: containerSize/3)
		
		durationLabel.frame = CGRect(x: durationContainerView.left,
                                     y: durationHeaderLabel.bottom,
                                     width: containerSize,
                                     height: 2*containerSize/3)
        
        distanceContainerView.frame = CGRect(x: durationContainerView.right + 10,
                                           y: 20,
                                           width: containerSize,
                                           height: containerSize)
		
		distanceHeaderLabel.frame = CGRect(x: distanceContainerView.left,
                                           y: distanceContainerView.top,
                                           width: containerSize,
                                           height: containerSize/3)
        
        distanceLabel.frame = CGRect(x: distanceContainerView.left,
                                     y: distanceHeaderLabel.bottom,
                                     width: containerSize,
                                     height: 2*containerSize/3)
		
		maxSpeedContainerView.frame = CGRect(x: 20,
                                           y: durationContainerView.bottom + 10,
                                           width: containerSize,
                                           height: containerSize)
		
		maxSpeedHeaderLabel.frame = CGRect(x: maxSpeedContainerView.left,
                                           y: maxSpeedContainerView.top,
                                           width: containerSize,
                                           height: containerSize/3)
        
        maxSpeedLabel.frame = CGRect(x: maxSpeedContainerView.left,
                                     y: maxSpeedHeaderLabel.bottom,
                                     width: containerSize,
                                     height: 2*containerSize/3)
		
		maxEleContainerView.frame = CGRect(x: maxSpeedContainerView.right + 10,
                                           y: distanceContainerView.bottom + 10,
                                           width: containerSize,
                                           height: containerSize)
		
		maxElevationHeaderLabel.frame = CGRect(x: maxEleContainerView.left,
                                               y: maxEleContainerView.top,
                                               width: containerSize,
                                               height: containerSize/3)
        
        maxElevationLabel.frame = CGRect(x: maxEleContainerView.left,
                                         y: maxElevationHeaderLabel.bottom,
                                         width: containerSize,
                                         height: 2*containerSize/3)
    }
    
    public func configure(duration : String, distance : String, maxElevation : String, maxSpeed: String){
        durationLabel.text = duration
        distanceLabel.text = "\(distance)"
        maxSpeedLabel.text = "\(maxSpeed)"
        maxElevationLabel.text = "\(maxElevation)"
    }
}
