//
//  HorizontalImageSliderCollectionViewCell.swift
//  PedalNature
//
//  Created by Volkan on 24.10.2021.
//
import UIKit
import AVKit

final class HorizontalImageSliderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HorizontalImageSliderCollectionViewCell"
    //Show Image
    private let routePhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    //Show Video
    var avPlayer: AVPlayer!
    let avPlayerController = AVPlayerViewController()
        
    override func layoutSubviews(){
        super.layoutSubviews()
        routePhotoImageView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: contentView.width,
                                           height: contentView.height)
        avPlayerController.view.frame = CGRect(x: 0,
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
        contentView.addSubview(avPlayerController.view)
        avPlayerController.view.isHidden = true
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: RouteImage){
        if model.image != nil{
          routePhotoImageView.image = model.image
        }else{
          self.avPlayerController.view.isHidden = false
          self.preparePlayer(with: model.videoURL!)
        }
        //routePhotoImageView.sd_setImage(with: imageURL, completed: nil)
    }

    private func preparePlayer(with fileURL: URL) {
        
        avPlayer = AVPlayer(url: fileURL)
        
        avPlayerController.player = avPlayer
        
        // Turn on video controlls
        avPlayerController.showsPlaybackControls = true
        
        // play video
        avPlayerController.player?.play()

    }

}
