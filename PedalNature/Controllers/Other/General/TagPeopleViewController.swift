//
//  TagPeopleViewController.swift
//  PedalNature
//
//  Created by Volkan on 14.10.2021.
//

import UIKit

class TagPeopleViewController: UIViewController {

    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private let headerLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
    
    private let searchLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "Write name on SearchBar"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
    
    private let NameResultTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(NameResultTableViewCell.self, forCellReuseIdentifier: NameResultTableViewCell.identifier)
        tableView.layer.masksToBounds = true
        tableView.isHidden = true
        return tableView
    }()
    
    private let taggedPeopleTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CityAndNameTableViewCell.self, forCellReuseIdentifier: NameResultTableViewCell.identifier)
        tableView.layer.masksToBounds = true
        tableView.isHidden = false
        return tableView
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    private let taggedPersons = [User]()
    private let userNameResults = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        taggedPeopleTableView.delegate = self
        taggedPeopleTableView.dataSource = self
        taggedPeopleTableView.isHidden = false

        NameResultTableView.delegate = self
        NameResultTableView.dataSource = self
        NameResultTableView.isHidden = true

        searchBar.delegate = self
        
        view.addSubview(NameResultTableView)
        view.addSubview(taggedPeopleTableView)
        view.addSubview(searchBar)
        view.addSubview(dimmedView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCancelButtonItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        dimmedView.addGestureRecognizer(gesture)
        
        if taggedPersons.count == 0{
            searchLabel.isHidden = false
        }else{
            headerLabel.isHidden = false
            searchLabel.isHidden = true
            headerLabel.text = "Tagged People"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.frame = CGRect(x: 0,
                                 y: view.safeAreaInsets.top,
                                         width: view.width,
                                         height: 52)
        
        headerLabel.frame = CGRect(x: 0,
                                   y: searchBar.bottom + 30,
                                           width: view.width,
                                           height: 52)
        
        NameResultTableView.frame = CGRect(x: 0,
                                           y: headerLabel.bottom,
                                           width: view.width,
                                           height: view.height)
        
        taggedPeopleTableView.frame = CGRect(x: 0,
                                        y: headerLabel.bottom,
                                        width: view.width,
                                        height: view.height)
                                        
        searchLabel.frame = CGRect(x: view.width/2,
                                   y: view.height/2,
                                   width: view.width,
                                   height: view.height)
        
        dimmedView.frame = view.bounds
    }
    
}

extension TagPeopleViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action:#selector(didTapCancelButtonItem))
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = 0.5
        }
    }
    
    @objc private func didTapCancelButtonItem(){
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        NameResultTableView.isHidden = true
        taggedPeopleTableView.isHidden = false
        if taggedPersons.count == 0{
            searchLabel.isHidden = false
        }else{
            headerLabel.isHidden = false
            searchLabel.isHidden = true
            headerLabel.text = "Tagged People"
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0
        }) { done in
            if done{
                self.dimmedView.isHidden = true
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.isEmpty == false else{
            return
        }
        didTapCancelButtonItem()
        NameResultTableView.isHidden = false
        taggedPeopleTableView.isHidden = true
        headerLabel.isHidden = false
        searchLabel.isHidden = true
        headerLabel.text = "Search Results"
        searchQuery(with: query)
    }
    
    private func searchQuery(with query: String){
        print(query)
    }
}

extension TagPeopleViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == NameResultTableView{
            return userNameResults.count
        }
        
        else{
            return taggedPersons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == NameResultTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: NameResultTableViewCell.identifier, for: indexPath) as! NameResultTableViewCell
            cell.configure(with:userNameResults[indexPath.row])
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: NameResultTableViewCell.identifier, for: indexPath) as! NameResultTableViewCell
            cell.configure(with: taggedPersons[indexPath.row])
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
  
}
