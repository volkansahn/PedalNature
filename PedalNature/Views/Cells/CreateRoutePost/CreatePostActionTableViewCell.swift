//
//  CreatePostActionTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 12.10.2021.
//

import UIKit

final class CreatePostActionTableViewCell: UITableViewCell {

    static let identifier = "CreatePostActionTableViewCell"

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
