//
//  PicturePreviewViewController.swift
//  PedalNature
//
//  Created by Volkan on 26.10.2021.
//

import UIKit

final class PicturePreviewViewController: UIViewController {

    public var image : UIImage?

    private let picturePreview : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

     override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(picturePreview)
        picturePreview.image = image!
    }

     override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cameraButtonSize = 100
        picturePreview.frame = view.bounds
    }
}
