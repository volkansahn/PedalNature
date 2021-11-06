//
//  DetailRouteTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 17.10.2021.
//

import UIKit

protocol DetailRouteTableViewCellDelegate: AnyObject{
    //User Info More Button
    func didTapMoreButtonResponse()
    //Route Name and Tag Button
    func didTapTaggedPersonsButtonResponse()
    //Action Buttons
    func likeButtonResponse()
    func commentButtonResponse()
    func likeAndCommentListResponse()
}

final class DetailRouteTableViewCell: UITableViewCell {

    static let identifier = "DetailRouteTableViewCell"
    
    public var delegate : DetailRouteTableViewCellDelegate?
    
    // MARK: User Info Section
    private let userPhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel : UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let locationAndDateLabel : UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let moreButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
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
    
    // MARK: Route Image Section
    private let homeImageView : UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.backgroundColor = nil
        return imageview
        
    }()
    
    // MARK: Route Likes Comments and Action
    // MARK: Action Section
    private let likeButton :UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let commentButton :UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "message", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let likeAndCommentNumberLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    // MARK: Route Info
	private var routeInfoTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CreateRouteInfoTableViewCell.self, forCellReuseIdentifier: CreateRouteInfoTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
	public var duration = ""
	public var distance = ""
	public var maxElevation = ""
	public var maxSpeed = ""
	
    // MARK: Elevation Graph
    private let elevationGraphContainerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = nil
        return imageView
    }()
    
    private let elevationHeader : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Elevation Graph"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    // MARK: Speed Graph
    private let speedGraphContainerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = nil
        return imageView
    }()
    
    private let speedHeader : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Speed Graph"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // MARK: User Info Section
        contentView.addSubview(userPhotoImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(locationAndDateLabel)
        
        // MARK: Route Image Section
        contentView.addSubview(homeImageView)
        
        // MARK: Route Name and Tag Section
        contentView.addSubview(containerView)
        contentView.addSubview(withLabel)
        contentView.addSubview(secondTagPhotoImageView)
        contentView.addSubview(firstTagPhotoImageView)
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
        
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        
        // MARK: Action Section
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(likeAndCommentNumberLabel)
        likeButton.addTarget(self,
                             action: #selector(didTapLikeButton),
                             for: .touchUpInside)
        commentButton.addTarget(self,
                             action: #selector(didTapCommentButton),
                             for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapListLikeandCommentButton))
        likeAndCommentNumberLabel.isUserInteractionEnabled = true
        likeAndCommentNumberLabel.addGestureRecognizer(tapGesture)
        
        // MARK: Route Info
		contentView.addSubview(routeInfoTableView)
		routeInfoTableView.delegate = self
		routeInfoTableView.dataSource = self
        
        // MARK: Elevation Graph
        contentView.addSubview(elevationGraphContainerImageView)
        contentView.addSubview(elevationHeader)
        
        // MARK: Speed Graph
        contentView.addSubview(speedGraphContainerImageView)
        contentView.addSubview(speedHeader)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        containerView.isHidden = true
        withLabel.isHidden = true
        secondTagPhotoImageView.isHidden = true
        firstTagPhotoImageView.isHidden = true
        moreTagLabel.isHidden = true
    }
    
    @objc func didTapLikeButton(){
        delegate?.likeButtonResponse()
    }
    
    @objc func didTapCommentButton(){
        delegate?.commentButtonResponse()
    }
    
    @objc func didTapListLikeandCommentButton(){
        delegate?.likeAndCommentListResponse()
        
    }
    
    @objc private func tagPhotoPressed(){
        delegate?.didTapTaggedPersonsButtonResponse()
    }
    
    @objc func didTapMoreButton(){
        delegate?.didTapMoreButtonResponse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // MARK: User Info Section
        let userInfoSectionHeight = 65
        let routeandTagSectionHeight = 70.0
        let routeImageSectionHeight = contentView.width
        let actionSectionHeight = 70
        let size = userInfoSectionHeight-5
        
        userPhotoImageView.frame = CGRect(x: 5,
                                          y: (userInfoSectionHeight - size)/2,
                                          width: size,
                                          height: size)
        userPhotoImageView.layer.cornerRadius = CGFloat(size/2)
        
        moreButton.frame = CGRect(x: Int(contentView.width)-size-5,
                                  y: (userInfoSectionHeight - size)/2,
                                  width: size,
                                  height: size)
        userNameLabel.frame = CGRect(x: Int(userPhotoImageView.right) + 5,
                                     y: (userInfoSectionHeight/2)-20,
                                     width: Int(contentView.width) - (size*2) - 10,
                                     height: (size/2) - 15)
        locationAndDateLabel.frame = CGRect(x: userPhotoImageView.right + 5,
                                            y: userNameLabel.bottom,
                                            width: contentView.width - CGFloat(size*2) - 10,
                                            height: CGFloat((size/2) - 5))
        
        // MARK: Route Image Section
        homeImageView.frame = CGRect(x: 0,
                                     y: userPhotoImageView.bottom,
                                     width: routeImageSectionHeight,
                                     height: routeImageSectionHeight)
        
        // MARK: Route Tag and Name Section
        let tagPhotoSize = routeandTagSectionHeight/2.0
        
        containerView.frame = CGRect(x: contentView.width-20.0-4*tagPhotoSize,
                                     y: homeImageView.bottom - tagPhotoSize-20,
                                     width: 4*tagPhotoSize,
                                     height: tagPhotoSize+10)
        containerView.layer.cornerRadius = 10
        
        withLabel.frame = CGRect(x: contentView.width-4*tagPhotoSize,
                                 y: homeImageView.bottom-tagPhotoSize-15,
                                 width: tagPhotoSize,
                                 height: tagPhotoSize)
        
        firstTagPhotoImageView.frame = CGRect(x:Double(withLabel.right),
                                              y:Double(homeImageView.bottom)-tagPhotoSize-15,
                                              width: tagPhotoSize,
                                              height: tagPhotoSize)
        firstTagPhotoImageView.layer.cornerRadius = CGFloat(tagPhotoSize/2)
        
        secondTagPhotoImageView.frame = CGRect(x:Double(withLabel.right) + tagPhotoSize/4,
                                               y:Double(homeImageView.bottom)-tagPhotoSize-15,
                                               width: tagPhotoSize,
                                               height: tagPhotoSize)
        secondTagPhotoImageView.layer.cornerRadius = CGFloat(tagPhotoSize/2)
        
        moreTagLabel.frame = CGRect(x: Double(secondTagPhotoImageView.right) + 5,
                                    y: Double(homeImageView.bottom)-tagPhotoSize-15,
                                    width: tagPhotoSize,
                                    height: tagPhotoSize)

        // MARK: Action Section
        let actionButtonSize = (actionSectionHeight/2)-5
        likeButton.frame = CGRect(x: 5,
                                  y: Int(homeImageView.bottom)+10,
                                  width: actionButtonSize + 15,
                                  height: actionButtonSize + 5)
        
        commentButton.frame = CGRect(x: Int(likeButton.right) + 20,
                                     y: Int(homeImageView.bottom)+10,
                                     width: actionButtonSize + 15,
                                     height: actionButtonSize + 5)
        
        likeAndCommentNumberLabel.frame = CGRect(x: 15,
                                                 y: likeButton.bottom,
                                                 width: contentView.width/2,
                                                 height: CGFloat(actionSectionHeight/2))
        
        // MARK: ROUTE INFO
		routeInfoTableView.frame = CGRect(x: 0,
                                           y: likeAndCommentNumberLabel.bottom,
                                           width: contentView.width,
                                           height: contentView.width)
		
        // MARK: Elevation Graph
        elevationHeader.frame = CGRect(x: 0,
                                       y: routeInfoTableView.bottom,
                                       width: contentView.width/2,
                                       height: contentView.width/4)
        
        elevationGraphContainerImageView.frame = CGRect(x: 0,
                                               y: elevationHeader.bottom,
                                               width: contentView.width,
                                               height: 3*contentView.width/4)
        
        // MARK: Speed Graph
        speedHeader.frame = CGRect(x: 0,
                                   y: elevationGraphContainerImageView.bottom,
                                       width: contentView.width/2,
                                       height: contentView.width/4)
        
        speedGraphContainerImageView.frame = CGRect(x: 0,
                                               y: speedHeader.bottom,
                                               width: contentView.width,
                                               height: 3*contentView.width/4)
        
        
    }

    public func configure(with modal: UserRoute){
        // MARK: User Info
        userPhotoImageView.image = UIImage(systemName: "person.circle")
        //let imageURL = modal.owner.profilePhoto

        //userPhotoImageView.sd_setImage(with: imageURL, completed: nil)
        userNameLabel.text = modal.owner.userName
        locationAndDateLabel.text = "\(modal.city), \(modal.createdDate)"
        
        // MARK: Route Name and Tag
        routeModal = modal
        firstTagPhotoImageView.backgroundColor = .systemRed
        secondTagPhotoImageView.backgroundColor = .systemBlue
        if modal.tagUser.count > 0{
            if modal.tagUser.count == 1{
                containerView.isHidden = false
                withLabel.isHidden = false
                firstTagPhotoImageView.isHidden = false
                //firstTagPhotoImageView.sd_setImage(with: modal.tagUser[0].profilePhoto, completed: nil)
            }else if modal.tagUser.count == 2{
                containerView.isHidden = false
                withLabel.isHidden = false
                secondTagPhotoImageView.isHidden = false
                firstTagPhotoImageView.isHidden = false
                //firstTagPhotoImageView.sd_setImage(with: modal.tagUser[0].profilePhoto, completed: nil)
                //secondTagPhotoImageView.sd_setImage(with: modal.tagUser[1].profilePhoto, completed: nil)
            }else if modal.tagUser.count > 2{
                moreTagLabel.text = "+\(modal.tagUser.count - 2)"
                containerView.isHidden = false
                withLabel.isHidden = false
                secondTagPhotoImageView.isHidden = false
                firstTagPhotoImageView.isHidden = false
                moreTagLabel.isHidden = false
                //firstTagPhotoImageView.sd_setImage(with: modal.tagUser[0].profilePhoto, completed: nil)
                //secondTagPhotoImageView.sd_setImage(with: modal.tagUser[1].profilePhoto, completed: nil)
            }
            
        }
        // MARK: Route Image
        homeImageView.image = UIImage(named: "test")
        
        //let mapImageURL = modal.routeMapImage
        //homeImageView.sd_setImage(with: mapImageURL, completed: nil)
        
        // MARK: Action Section
        let likeNumber = modal.likeCount.count
        let commentNumber = modal.comments.count
        var likeString = ""
        var commentString = ""
        
        if likeNumber == 1{
            likeString = "like"
        }else if likeNumber > 1{
            likeString = "likes"
        }else{
            likeString = ""
        }
        
        if commentNumber == 1{
            commentString = "comment"
        }else if commentNumber > 1{
            commentString = "comments"
        }else{
            commentString = ""
        }
        
        if commentNumber == 0 && likeNumber == 0{
            likeAndCommentNumberLabel.text = nil
        }else if commentNumber > 0 && likeNumber == 0{
            likeAndCommentNumberLabel.text = "\(modal.comments.count) \(commentString)"
        }else if commentNumber == 0 && likeNumber > 0{
            likeAndCommentNumberLabel.text = "\(modal.likeCount.count) \(likeString)"
        }else{
            likeAndCommentNumberLabel.text = "\(modal.likeCount.count) \(likeString) and \(modal.comments.count) \(commentString)"
        }
        
        // MARK: Route Info
		//configureRouteInfo()
        //duration = modal.routeDuration
		//distance = modal.routeLength
		duration = "1h20m" 
		distance = "1.27km"
        maxElevation = "875m"
		maxSpeed = "22m/sn"
        // MARK: Elevation Graph
        elevationGraphContainerImageView.image = UIImage(named: "test")

        // MARK: Speed Graph
        speedGraphContainerImageView.image = UIImage(named: "test")

    }
    
	/*
	private func configureRouteInfo(){
        for location in locations {
            if location.speed > maxSpeed{
                maxSpeed = maxSpeed.rounded(toPlaces: 2)
            }
            
            if location.altitude > maxElevation{
                maxElevation = location.altitude
                maxElevation = maxElevation.rounded(toPlaces: 2)

            }
        }
    }
	*/
}

extension DetailRouteTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateRouteInfoTableViewCell.identifier) as! CreateRouteInfoTableViewCell
        cell.configure(duration: duration, distance: distance, maxElevation: String(maxElevation), maxSpeed: String(maxSpeed))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return contentView.width

    }
    
}
