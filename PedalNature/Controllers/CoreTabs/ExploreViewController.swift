//
//  ExploreViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit

/// Explore Tab

final class ExploreViewController: UIViewController {

    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private let searchResultTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CityAndNameTableViewCell.self, forCellReuseIdentifier: CityAndNameTableViewCell.identifier)
        tableView.layer.masksToBounds = true
        tableView.isHidden = true
        return tableView
    }()
    
    private let exploreTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CityAndNameTableViewCell.self, forCellReuseIdentifier: CityAndNameTableViewCell.identifier)
        tableView.layer.masksToBounds = true
        tableView.isHidden = false
        return tableView
    }()
    
    private let NameResultTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(NameResultTableViewCell.self, forCellReuseIdentifier: NameResultTableViewCell.identifier)
        tableView.layer.masksToBounds = true
        tableView.isHidden = true
        return tableView
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    private var searchFilterTabBarCollectionView : UICollectionView?
    
    private var searchResultViewRenderModals = [UserRoute]()

    private var exploreViewRenderModals = [UserRoute]()

    private var userNameResults = [User]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModals()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.titleView = searchBar

        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.isHidden = true
        
        exploreTableView.delegate = self
        exploreTableView.dataSource = self
        exploreTableView.isHidden = false

        NameResultTableView.delegate = self
        NameResultTableView.dataSource = self
        NameResultTableView.isHidden = true

        searchBar.delegate = self
        
        // CollectionView Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.width, height: 52)
      
        searchFilterTabBarCollectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
                
        // CollectionView Cell
        searchFilterTabBarCollectionView?.register(SearchFilterCollectionViewCell.self, forCellWithReuseIdentifier: SearchFilterCollectionViewCell.identifier)
        
        searchFilterTabBarCollectionView?.delegate = self
        searchFilterTabBarCollectionView?.dataSource = self
        guard let collectionView = searchFilterTabBarCollectionView else {
            return
        }
        collectionView.isHidden = true
        collectionView.layer.masksToBounds = true
        view.addSubview(collectionView)
        
        view.addSubview(searchResultTableView)
        view.addSubview(NameResultTableView)
        view.addSubview(exploreTableView)
        view.addSubview(dimmedView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCancelButtonItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        dimmedView.addGestureRecognizer(gesture)
        tabBarController?.tabBar.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        searchFilterTabBarCollectionView?.frame = CGRect(x: 0,
                                                         y: view.safeAreaInsets.top,
                                                         width: view.width,
                                                         height: 40)
        let bottomHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        searchResultTableView.frame = CGRect(x: 0,
                                             y: searchFilterTabBarCollectionView!.bottom,
                                             width: view.width,
                                             height: bottomHeight - searchFilterTabBarCollectionView!.height)
        
        NameResultTableView.frame = CGRect(x: 0,
                                           y: searchFilterTabBarCollectionView!.bottom,
                                           width: view.width,
                                           height: bottomHeight - searchFilterTabBarCollectionView!.height)
        
        exploreTableView.frame = CGRect(x: 0,
                                        y: view.safeAreaInsets.top,
                                        width: view.width,
                                        height: bottomHeight)
        
        dimmedView.frame = view.bounds
    }
    
    private func createMockModals(){
        let user = User(identifier: "", userName: "@Volkan", profilePhoto: URL(string: "https://www.google.com")!,
                        name: (first: "Volkan", last: "Sahin"),
                        birthDate: Date(),
                        bio: "",
                        counts: UserCounts(following: 10, followers: 10, post: 10),
                        joinDate: Date())
        
        
        let post = UserRoute(identifier: "", owner: user, routeMapImage: URL(string: "https://www.google.com")!, velocityGraph: URL(string: "https://www.google.com")!, routeMapThumbnailImage: URL(string: "https://www.google.com")!, routeContent: [Content(imageURL: "", videoURL: "", latitude: "", longitude: "")], routeName: "", routeLength: "", routeDuration: "", city: "Ankara", coordinates: [Coordinate(identifier: "", routeIdentifier: "", latitude: "", longitude: "")], elevations: [Elevation(elevation: 10.0)], speeds: [Speed(speed: 10.0)], likeCount: [RouteLikes(identifier: "", postIdentifier: "", user: user)], comments: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [CommentLikes(identifier: "", commentIdentifier: "", user: user)], replyComment: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [], replyComment: [])])], createdDate: Date(), tagUser: [user], elevationGraph: URL(string: "https://www.google.com")!)
        
        for _ in 0...10{
            searchResultViewRenderModals.append(post)
            exploreViewRenderModals.append(post)
            userNameResults.append(user)
        }
    }
    

}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchFilterCollectionViewCell.identifier, for: indexPath) as! SearchFilterCollectionViewCell
        cell.delegate = self
        return cell
    }
    
}

extension ExploreViewController: UISearchBarDelegate{
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
        searchFilterTabBarCollectionView?.isHidden = true
        searchResultTableView.isHidden = true
        NameResultTableView.isHidden = true
        exploreTableView.isHidden = false
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
        searchFilterTabBarCollectionView?.isHidden = false
        searchResultTableView.isHidden = false
        exploreTableView.isHidden = true
        searchQuery(with: query)
    }
    
    private func searchQuery(with query: String){
        print(query)
    }
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == NameResultTableView{
            return userNameResults.count
        }
        
        else{
            return exploreViewRenderModals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == NameResultTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: NameResultTableViewCell.identifier, for: indexPath) as! NameResultTableViewCell
            cell.configure(with:userNameResults[indexPath.row])
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CityAndNameTableViewCell.identifier, for: indexPath) as! CityAndNameTableViewCell
            cell.configure(with: exploreViewRenderModals[indexPath.row],at: indexPath.row)
            cell.delegate = self
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == NameResultTableView{
            let vc = UserProfileViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let modal = exploreViewRenderModals[indexPath.row]
            let vc = DetailedRouteViewController()
            vc.modal = modal
            vc.title = "Route"
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == NameResultTableView{
            return 70
        }
        
        else{
            return 65 + view.width + 20
        }
    }
  
}


extension ExploreViewController: CityAndNameTableViewCellDelegate{
    // MARK: User Info Section
    func didTapMoreButtonResponse() {
        let actionSheet = UIAlertController(title: "Route Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Follow Route", style: .default, handler: { _ in
            print("Tapped")
        }))
        actionSheet.addAction(UIAlertAction(title: "Share Route", style: .default, handler: { _ in
            print("Tapped")
        }))
        actionSheet.addAction(UIAlertAction(title: "Report Route", style: .destructive, handler: { _ in
            print("Tapped")
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("Tapped")
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: Route Tag Section
    func didTapTaggedPersonsButtonResponse(_ row: Int) {
        let vc = TaggedPersonsViewController()
        vc.title = "Tags"
        vc.routeModal = exploreViewRenderModals[row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExploreViewController: SearchFilterCollectionViewCellDelegate{
    func didTapLocationResultResponse() {
        searchResultTableView.isHidden = false
        NameResultTableView.isHidden = true
    }
    
    func didTapRouteNameResultResponse() {
        searchResultTableView.isHidden = false
        NameResultTableView.isHidden = true
    }
    
    func didTapUserNameResultResponse() {
        searchResultTableView.isHidden = true
        NameResultTableView.isHidden = false

    }
    
    
}
