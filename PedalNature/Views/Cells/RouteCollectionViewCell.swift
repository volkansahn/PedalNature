//
//  RouteCollectionViewCell.swift
//  PedalNature
//
//  Created by Volkan on 30.09.2021.
//

import SDWebImage
import UIKit

protocol RouteCollectionViewCellDelegate: AnyObject{
    //Route Name and Tag Button
    func didTapTaggedPersonsButtonResponse(_ row : Int)
}

class RouteCollectionViewCell: UICollectionViewCell {
    static let identifier = "RouteCollectionViewCell"

	public var delegate : RouteCollectionViewCellDelegate?
	
    private let routeMapPhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
	
	private let routeLocationLabel : UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let routeLengthLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Route Name and Tag
    private var routeModal : UserRoute?
    
    private let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = true
        view.isHidden = true
        view.alpha = 0.75
        return view
    }()
    
    private let withLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "with:"
        label.isHidden = true
        label.layer.masksToBounds = true
        return label
    }()
    
    private let firstTagPhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let secondTagPhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let moreTagLabel: UILabel = {
        let label = UILabel ()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .heavy)
        label.textColor = .label
        label.isHidden = true
        label.layer.masksToBounds = true
        return label
    }()
    
    override func layoutSubviews(){
        super.layoutSubviews()
		
		// MARK: User Info Section
        let routeInfoSectionHeight = 65
        let routeandTagSectionHeight = 70.0
        
		// MARK: Route Image Section
        routeMapPhotoImageView.frame = CGRect(x: 0,
                                          y: routeInfoSectionHeight,
                                              width: Int(contentView.width),
                                              height: Int(contentView.height)-routeInfoSectionHeight)
        
        // MARK: Route Info
		routeLocationLabel.frame = CGRect(x: 5,
                                     y: 0,
                                     width: Int(contentView.width/2),
                                     height: routeInfoSectionHeight/2)
									 
        dateLabel.frame = CGRect(x: 5,
                                            y: routeLocationLabel.bottom,
                                            width: contentView.width/2,
                                 height: CGFloat(routeInfoSectionHeight/2))
											
        routeLengthLabel.frame = CGRect(x: Int(contentView.width) - 100,
                                            y: routeInfoSectionHeight/2,
                                        width: Int(contentView.width)/2,
                                            height: routeInfoSectionHeight)
        
        // MARK: Route Tag and Name Section
        let tagPhotoSize = routeandTagSectionHeight/2.0
        
        containerView.frame = CGRect(x: contentView.width-20.0-4*tagPhotoSize,
                                     y: routeMapPhotoImageView.bottom - tagPhotoSize-20,
                                     width: 4*tagPhotoSize,
                                     height: tagPhotoSize+10)
        containerView.layer.cornerRadius = 10
        
        withLabel.frame = CGRect(x: contentView.width-4*tagPhotoSize,
                                 y: routeMapPhotoImageView.bottom-tagPhotoSize-15,
                                 width: tagPhotoSize,
                                 height: tagPhotoSize)
        
        firstTagPhotoImageView.frame = CGRect(x:Double(withLabel.right),
                                              y:Double(routeMapPhotoImageView.bottom)-tagPhotoSize-15,
                                              width: tagPhotoSize,
                                              height: tagPhotoSize)
        firstTagPhotoImageView.layer.cornerRadius = CGFloat(tagPhotoSize/2)
        
        secondTagPhotoImageView.frame = CGRect(x:Double(withLabel.right) + tagPhotoSize/4,
                                               y:Double(routeMapPhotoImageView.bottom)-tagPhotoSize-15,
                                               width: tagPhotoSize,
                                               height: tagPhotoSize)
        secondTagPhotoImageView.layer.cornerRadius = CGFloat(tagPhotoSize/2)
        
        moreTagLabel.frame = CGRect(x: Double(secondTagPhotoImageView.right) + 5,
                                    y: Double(routeMapPhotoImageView.bottom)-tagPhotoSize-15,
                                    width: tagPhotoSize,
                                    height: tagPhotoSize)
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(routeMapPhotoImageView)
        contentView.addSubview(routeLocationLabel)
		contentView.addSubview(dateLabel)
		contentView.addSubview(routeLengthLabel)
        contentView.addSubview(containerView)
		contentView.addSubview(withLabel)
		contentView.addSubview(firstTagPhotoImageView)
        contentView.addSubview(secondTagPhotoImageView)
		contentView.addSubview(moreTagLabel)
		
		let firstPhotogesture = UITapGestureRecognizer(target: self, action: #selector(tagPhotoPressed))
        firstTagPhotoImageView.addGestureRecognizer(firstPhotogesture)
        firstTagPhotoImageView.isUserInteractionEnabled = true
        
        let secondPhotogesture = UITapGestureRecognizer(target: self, action: #selector(tagPhotoPressed))
        secondTagPhotoImageView.addGestureRecognizer(secondPhotogesture)
        secondTagPhotoImageView.isUserInteractionEnabled = true
        
        let withLabelgesture = UITapGestureRecognizer(target: self, action: #selector(tagPhotoPressed))
        withLabel.addGestureRecognizer(withLabelgesture)
        withLabel.isUserInteractionEnabled = true
        
        let moreLabelgesture = UITapGestureRecognizer(target: self, action: #selector(tagPhotoPressed))
        moreTagLabel.addGestureRecognizer(moreLabelgesture)
        moreTagLabel.isUserInteractionEnabled = true
        
    }
	
	@objc private func tagPhotoPressed(){
        let row = withLabel.tag
        delegate?.didTapTaggedPersonsButtonResponse(row)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with modal: UserRoute){
    
        // MARK: Route Image
        routeMapPhotoImageView.image = UIImage(named: "test")
		//routeMapPhotoImageView.sd_setImage(with: mapImageURL, completed: nil)

		// MARK: Route Info
        routeLocationLabel.text = modal.city
        dateLabel.text = "\(modal.createdDate)"
		routeLengthLabel.text = modal.routeLength
        
        // MARK: Route Name and Tag
        routeModal = modal
        firstTagPhotoImageView.backgroundColor = .systemRed
        secondTagPhotoImageView.backgroundColor = .systemBlue
        if modal.tagUser.count > 0{
            if modal.tagUser.count == 1{
                containerView.isHidden = false
                withLabel.isHidden = false
                firstTagPhotoImageView.isHidden = false
                //withLabel.tag = row
                //firstTagPhotoImageView.tag = row
                //firstTagPhotoImageView.sd_setImage(with: modal.tagUser[0].profilePhoto, completed: nil)
            }else if modal.tagUser.count == 2{
                containerView.isHidden = false
                withLabel.isHidden = false
                secondTagPhotoImageView.isHidden = false
                firstTagPhotoImageView.isHidden = false
//                withLabel.tag = row
//                firstTagPhotoImageView.tag = row
//                secondTagPhotoImageView.tag = row
                //firstTagPhotoImageView.sd_setImage(with: modal.tagUser[0].profilePhoto, completed: nil)
                //secondTagPhotoImageView.sd_setImage(with: modal.tagUser[1].profilePhoto, completed: nil)
            }else if modal.tagUser.count > 2{
                moreTagLabel.text = "+\(modal.tagUser.count - 2)"
                containerView.isHidden = false
                withLabel.isHidden = false
                secondTagPhotoImageView.isHidden = false
                firstTagPhotoImageView.isHidden = false
                moreTagLabel.isHidden = false
//                withLabel.tag = row
//                firstTagPhotoImageView.tag = row
//                secondTagPhotoImageView.tag = row
//                moreTagLabel.tag = row
                //firstTagPhotoImageView.sd_setImage(with: modal.tagUser[0].profilePhoto, completed: nil)
                //secondTagPhotoImageView.sd_setImage(with: modal.tagUser[1].profilePhoto, completed: nil)
            }
            
        }
    }
    
    override func prepareForReuse() {
		routeMapPhotoImageView.image = nil
		routeLocationLabel.text = nil
		dateLabel.text = nil
		routeLengthLabel.text = nil
		containerView.isHidden = true
        withLabel.isHidden = true
        secondTagPhotoImageView.isHidden = true
        firstTagPhotoImageView.isHidden = true
        moreTagLabel.isHidden = true
    }
    
}
