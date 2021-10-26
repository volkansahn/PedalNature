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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.text = "Duration"
        label.numberOfLines = 1
        return label
    }()
    
    private let distanceHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.text = "Distance"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxSpeedHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.text = "Max.Speed"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxElevationHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.text = "Max.Elevation"
        label.numberOfLines = 1
        return label
    }()
    
    private let durationLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.text = "1h30d"
        label.numberOfLines = 1
        return label
    }()
    
    private let distanceLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.text = "1.37km"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxSpeedLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.text = "22m/sn"
        label.numberOfLines = 1
        return label
    }()
    
    private let maxElevationLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.text = "750m"
        label.numberOfLines = 1
        return label
    }()
	
	private let durationContainerView : UIView = {
		let view = UIView()
		view.backgroundColor = .label
		view.layer.shadowRadius = 8
		view.layer.shadowOffset = CGSize(width: 3, height: 3)
		view.layer.shadowOpacity = 0.5
		view.layer.cornerRadius = 20
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let durationContainerContentsLayer : UIView = {
		let view = UIView()
		view.backgroundColor = .label
		view.layer.cornerRadius = 20
		view.layer.masksToBound = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let distanceContainerView : UIView = {
		llet view = UIView()
		view.backgroundColor = .label
		view.layer.shadowRadius = 8
		view.layer.shadowOffset = CGSize(width: 3, height: 3)
		view.layer.shadowOpacity = 0.5
		view.layer.cornerRadius = 20
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let distanceContainerContentsLayer : UIView = {
		let view = UIView()
		view.backgroundColor = .label
		view.layer.cornerRadius = 20
		view.layer.masksToBound = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let maxEleContainerView : UIView = {
		let view = UIView()
		view.backgroundColor = .label
		view.layer.shadowRadius = 8
		view.layer.shadowOffset = CGSize(width: 3, height: 3)
		view.layer.shadowOpacity = 0.5
		view.layer.cornerRadius = 20
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let maxEleContainerContentsLayer : UIView = {
		let view = UIView()
		view.backgroundColor = .label
		view.layer.cornerRadius = 20
		view.layer.masksToBound = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let maxSpeedContainerView : UIView = {
		let view = UIView()
		view.backgroundColor = .label
		view.layer.shadowRadius = 8
		view.layer.shadowOffset = CGSize(width: 3, height: 3)
		view.layer.shadowOpacity = 0.5
		view.layer.cornerRadius = 20
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let maxSpeedContainerContentsLayer : UIView = {
		let view = UIView()
		view.backgroundColor = .label
		view.layer.cornerRadius = 20
		view.layer.masksToBound = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(durationContainerView)
		contentView.addSubview(durationContainerContentsLayer)
		contentView.addSubview(distanceContainerView)
		contentView.addSubview(distanceContainerContentsLayer)
		contentView.addSubview(maxEleContainerView)
		contentView.addSubview(maxEleContainerContentsLayer)
		contentView.addSubview(maxSpeedContainerView)
		contentView.addSubview(maxSpeedContainerContentsLayer)
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
        
		let containerSize = (contentView.width - 60)/2
		
        durationContainerView.frame = CGRect(x: 20,
                                           y: 20,
                                           width: containerSize,
                                           height: containerSize)
		durationContainerContentsLayer.frame = durationContainerView.bounds
		
		durationHeaderLabel.frame = CGRect(x: durationContainerContentsLayer.left,
                                           y: durationContainerContentsLayer.top,
                                           width: containerSize,
                                           height: containerSize/2)
		
		durationLabel.frame = CGRect(x: durationContainerContentsLayer.left,
                                     y: durationHeaderLabel.bottom,
                                     width: containerSize,
                                     height: containerSize/2)
        
        distanceContainerView.frame = CGRect(x: durationContainerContentsLayer.right + 20,
                                           y: 20,
                                           width: containerSize,
                                           height: containerSize)
		distanceContainerContentsLayer.frame = distanceContainerView.bounds
		
		distanceHeaderLabel.frame = CGRect(x: distanceContainerContentsLayer.left,
                                           y: distanceContainerContentsLayer.bottom,
                                           width: containerSize,
                                           height: containerSize/2)
        
        distanceLabel.frame = CGRect(x: distanceContainerContentsLayer.left,
                                     y: distanceHeaderLabel.bottom,
                                     width: containerSize,
                                     height: containerSize/2)
		
		maxSpeedContainerView.frame = CGRect(x: 20,
                                           y: durationContainerView.bottom + 20,
                                           width: containerSize,
                                           height: containerSize)
		maxSpeedContainerContentsLayer.frame = maxSpeedContainerView.bounds
		
		maxSpeedHeaderLabel.frame = CGRect(x: maxSpeedContainerContentsLayer.left,
                                           y: maxSpeedContainerContentsLayer.bottom,
                                           width: containerSize,
                                           height: containerSize/2)
        
        maxSpeedLabel.frame = CGRect(x: maxSpeedContainerContentsLayer.left,
                                     y: maxSpeedHeaderLabel.bottom,
                                     width: containerSize,
                                     height: containerSize/2)
		
		maxEleContainerView.frame = CGRect(x: maxSpeedContainerContentsLayer.right + 20,
                                           y: distanceContainerView.bottom + 20,
                                           width: containerSize,
                                           height: containerSize)
		maxEleContainerContentsLayer.frame = maxEleContainerView.bounds
		
		maxElevationHeaderLabel.frame = CGRect(x: maxEleContainerContentsLayer.left,
                                               y: maxEleContainerContentsLayer.bottom,
                                               width: containerSize,
                                               height: containerSize/2)
        
        maxElevationLabel.frame = CGRect(x: maxEleContainerContentsLayer.left,
                                         y: maxElevationHeaderLabel.bottom,
                                         width: containerSize,
                                         height: containerSize/2)
    }
    
    public func configure(duration : String, distance : String, maxElevation : String, maxSpeed: String){
        durationLabel.text = duration
        distanceLabel.text = "\(distance)km"
        maxSpeedLabel.text = "\(maxSpeed)m/sn"
        maxElevationLabel.text = "\(maxElevation)m"
    }
}
