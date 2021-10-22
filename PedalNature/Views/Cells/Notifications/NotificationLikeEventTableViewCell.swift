//
//  NotificationLikeEventTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 2.10.2021.
//

import UIKit

protocol NotificationLikeEventTableViewCellDelegate : AnyObject{
    func didTapLikedRouteButton(modal : UserNotification)
}

class NotificationLikeEventTableViewCell: UITableViewCell {

    static let identifier = "NotificationLikeEventTableViewCell"
    
    private var modal: UserNotification?
    
    weak var delegate: NotificationLikeEventTableViewCellDelegate?
    
    private let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "Volkan liked your route"
        return label
    }()
    
    private let likedRouteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        return button
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(notificationImageView)
        contentView.addSubview(label)
        contentView.addSubview(likedRouteButton)
        likedRouteButton.addTarget(self,
                               action: #selector(didTapLikedContentButton), for: .touchUpInside)
        selectionStyle = .none

    }
    
    @objc func didTapLikedContentButton(){
        guard let modal = modal else {
            return
        }

        delegate?.didTapLikedRouteButton(modal: modal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        notificationImageView.frame = CGRect(x: 3,
                                             y: 3,
                                             width: contentView.height-6,
                                             height: contentView.height-6)
        notificationImageView.layer.cornerRadius = notificationImageView.height/2
        let size = contentView.height-4
        likedRouteButton.frame = CGRect(x: contentView.width - size - 5,
                                        y: 2,
                                        width: size,
                                        height: contentView.height-4)
        label.frame = CGRect(x: notificationImageView.right + 5,
                             y: 0,
                             width: contentView.width-notificationImageView.width-size-16,
                             height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        notificationImageView.image = nil
        label.text = nil
        likedRouteButton.setBackgroundImage(nil, for: .normal)
    }
    
    public func configure(with modal: UserNotification){
        self.modal = modal
        switch modal.type{
        case .like(let post):
            let thumbnail = post.routeMapThumbnailImage
            likedRouteButton.sd_setBackgroundImage(with: thumbnail, for: .normal, completed: nil)
        case .follow:
            break
            
        }
        
        label.text = modal.text
        notificationImageView.sd_setImage(with: modal.user.profilePhoto, completed: nil)
        
    }

}
