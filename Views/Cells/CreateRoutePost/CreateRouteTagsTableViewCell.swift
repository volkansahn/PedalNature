//
//  CreateRouteTagsTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 12.10.2021.
//

import UIKit

final class CreateRouteTagsTableViewCell: UITableViewCell {
    
    static let identifier = "CreateRouteTagsTableViewCell"
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tag Person"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let goToTagSearchButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let tagSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private let cancelSearchButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.isHidden = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tagSearchBar.delegate = self
        contentView.addSubview(tagsLabel)
        contentView.addSubview(goToTagSearchButton)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tagsLabel.frame = CGRect(x: 5,
                                 y: 0,
                                 width: contentView.height + 50,
                                 height: contentView.height)
        
        goToTagSearchButton.frame = CGRect(x: contentView.width-50,
                                           y: 15,
                                           width: contentView.height-30,
                                           height: contentView.height-30)
    }
}

extension CreateRouteTagsTableViewCell: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        cancelSearchButton.isHidden = false
        cancelSearchButton.addTarget(self, action: #selector(didTapCancelButtonItem), for: .touchUpInside)
    }
    
    @objc private func didTapCancelButtonItem(){
        tagSearchBar.resignFirstResponder()
        cancelSearchButton.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.isEmpty == false else{
            return
        }
        didTapCancelButtonItem()
        searchQuery(with: query)
    }
    
    private func searchQuery(with query: String){
        print(query)
    }
}
