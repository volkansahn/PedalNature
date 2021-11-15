//
//  CreateAnimationShareActionTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 15.11.2021.
//

import UIKit

class CreateAnimationShareActionTableViewCell: UITableViewCell {
    // MARK: Variable Decleration
      
    static let identifier = "CreateAnimationShareActionTableViewCell"

    private let shareButton : UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor(rgb: 0x5da973)
        button.setTitleColor(.white, for: .normal)
        return button
      }()
      
    let buttonHeight = 52.0
    let buttonWidth = 100.0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          contentView.backgroundColor = .systemBackground
          //Selection Container
          contentView.addSubview(shareButton)
          
      }
      
      override func layoutSubviews() {
          super.layoutSubviews()
          
          shareButton.frame = CGRect(x: 10,
                                        y: 10,
                                        width: contentView.width/4,
                                        height: contentView.height)
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      override func prepareForReuse() {
          super.prepareForReuse()
      }
  }
