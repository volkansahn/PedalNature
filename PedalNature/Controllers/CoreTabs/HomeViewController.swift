//
//  HomeViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit
import FirebaseAuth

/// Home Tab
final class HomeViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
        
    private var modals = [UserRoute?]()
        
    private var HomeTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTabTableViewCell.self, forCellReuseIdentifier: HomeTabTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModals()
        view.backgroundColor = .systemBackground
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
        view.addSubview(HomeTableView)
        configureNavigationBar()
    }
    
    private func createMockModals(){
        let user = User(identifier: "", userName: "@Volkan", profilePhoto: URL(string: "https://www.google.com")!,
                        name: (first: "Volkan", last: "Sahin"),
                        birthDate: Date(),
                        bio: "",
                        counts: UserCounts(following: 10, followers: 10, post: 10),
                        joinDate: Date())
        
        
        let post = UserRoute(identifier: "", owner: user, routeMapImage: URL(string: "https://www.google.com")!, velocityGraph: URL(string: "https://www.google.com")!, routeMapThumbnailImage: URL(string: "https://www.google.com")!, routeContent: [Content(imageURL: "", videoURL: "", latitude: "", longitude: "")], routeName: "", routeLength: "", routeDuration: "", city: "Ankara", coordinates: [Coordinate(identifier: "", routeIdentifier: "", latitude: "", longitude: "")], elevations: [Elevation(elevation: 10.0)], speeds: [Speed(speed: 10.0)], likeCount: [RouteLikes(identifier: "", postIdentifier: "", user: user)], comments: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [CommentLikes(identifier: "", commentIdentifier: "", user: user)], replyComment: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [], replyComment: [])])], createdDate: Date(), tagUser: [user], elevationGraph: URL(string: "https://www.google.com")!)
        
        let post2 = UserRoute(identifier: "", owner: user, routeMapImage: URL(string: "https://www.google.com")!, velocityGraph: URL(string: "https://www.google.com")!, routeMapThumbnailImage: URL(string: "https://www.google.com")!, routeContent: [Content(imageURL: "", videoURL: "", latitude: "", longitude: "")], routeName: "", routeLength: "", routeDuration: "", city: "Ankara", coordinates: [Coordinate(identifier: "", routeIdentifier: "", latitude: "", longitude: "")], elevations: [Elevation(elevation: 10.0)], speeds: [Speed(speed: 10.0)], likeCount: [RouteLikes(identifier: "", postIdentifier: "", user: user)], comments: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [CommentLikes(identifier: "", commentIdentifier: "", user: user)], replyComment: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [], replyComment: [])])], createdDate: Date(), tagUser: [user,user,user], elevationGraph: URL(string: "https://www.google.com")!)
        
        let post3 = UserRoute(identifier: "", owner: user, routeMapImage: URL(string: "https://www.google.com")!, velocityGraph: URL(string: "https://www.google.com")!, routeMapThumbnailImage: URL(string: "https://www.google.com")!, routeContent: [Content(imageURL: "", videoURL: "", latitude: "", longitude: "")], routeName: "", routeLength: "", routeDuration: "", city: "Ankara", coordinates: [Coordinate(identifier: "", routeIdentifier: "", latitude: "", longitude: "")], elevations: [Elevation(elevation: 10.0)], speeds: [Speed(speed: 10.0)], likeCount: [RouteLikes(identifier: "", postIdentifier: "", user: user)], comments: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [CommentLikes(identifier: "", commentIdentifier: "", user: user)], replyComment: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [], replyComment: [])])], createdDate: Date(), tagUser: [user,user], elevationGraph: URL(string: "https://www.google.com")!)
        
        for x in 0...15{
            if x % 3 == 0{
                modals.append(post)
            }else if x % 3 == 2{
               
                modals.append(post2)
            }else if x % 3 == 1{
               
                modals.append(post3)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomHeight = view.safeAreaLayoutGuide.layoutFrame.size.height

        HomeTableView.frame = CGRect(x: 0,
                                     y: view.safeAreaInsets.top,
                                     width: view.width,
                                     height: bottomHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if auth.currentUser == nil{
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTabTableViewCell.identifier, for: indexPath) as! HomeTabTableViewCell
        cell.configure(with: modals[indexPath.row]!,at: indexPath.row)
        cell.delegate = self
        return cell
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modal = modals[indexPath.row]
        let vc = DetailedRouteViewController()
        vc.modal = modal
        vc.title = "Route"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65 + view.width + 80 + 10
    }
  
}


extension HomeViewController: HomeTabTableViewCellDelegate{
    
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
        vc.routeModal = modals[row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Action Section
    func likeButtonResponse() {
        print("like")
    }
    
    func commentButtonResponse() {
        print("comment")

    }
    
    func likeAndCommentListResponse() {
        let vc = CommentAndLikesViewController()
        vc.title = "Likes & Comments"
        vc.commentModal = modals[0]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}
