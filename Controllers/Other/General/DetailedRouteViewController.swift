//
//  DetailedRouteViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit

/// Shows Details about the route posted by the user self or other people.
/// Reached from Home View , Explore View, Profile View or Notificattion View

final class DetailedRouteViewController: UIViewController {

    public var modal : UserRoute?
    
    private var postDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DetailRouteTableViewCell.self, forCellReuseIdentifier: DetailRouteTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(postDetailTableView)
        postDetailTableView.delegate = self
        postDetailTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        postDetailTableView.frame = view.bounds
        
    }
    
    private func createMockModals(){
        let user = User(identifier: "", userName: "@Volkan", profilePhoto: URL(string: "https://www.google.com")!,
                        name: (first: "Volkan", last: "Sahin"),
                        birthDate: Date(),
                        bio: "",
                        counts: UserCounts(following: 10, followers: 10, post: 10),
                        joinDate: Date())
        
        
        let post = UserRoute(identifier: "", owner: user, routeMapImage: URL(string: "https://www.google.com")!, velocityGraph: URL(string: "https://www.google.com")!, routeMapThumbnailImage: URL(string: "https://www.google.com")!, routeContent: [Content(type: .image)], routeName: "Ankara", routeLength: "", routeDuration: "", city: "Ankara", coordinates: [Coordinate(identifier: "", routeIdentifier: "", latitude: "", longitude: "")], elevations: [Elevation(elevation: 10.0)], speeds: [Speed(speed: 10.0)], likeCount: [RouteLikes(identifier: "", postIdentifier: "", user: user)], comments: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "Hello", createdDate: Date(), likes: [CommentLikes(identifier: "", commentIdentifier: "", user: user)], replyComment: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "Hi", createdDate: Date(), likes: [], replyComment: [])])], createdDate: Date(), tagUser: [user,user], elevationGraph: URL(string: "https://www.google.com")!)
        
        modal = post
    }
        
}

extension DetailedRouteViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailRouteTableViewCell.identifier, for: indexPath) as! DetailRouteTableViewCell
        cell.configure(with: modal!)
        cell.delegate = self
        return cell
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65 + 3*view.width + 80 + 100
    }
  
}


extension DetailedRouteViewController: DetailRouteTableViewCellDelegate{
    
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
    func didTapTaggedPersonsButtonResponse() {
        let vc = TaggedPersonsViewController()
        vc.title = "Tags"
        vc.routeModal = modal
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
        vc.commentModal = modal
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
