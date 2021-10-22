//
//  NotificationViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit

/// Notification Tab
final class NotificationViewController: UIViewController {

    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationFollowEventTableViewCell .identifier)
        return tableView
    }()
    
    private lazy var noNotificationsView = NoNotificationsView()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private var modals = [UserNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        //view.addSubview(spinner)
        //spinner.startAnimating()
        view.addSubview(tableView)
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0,
                               y: 0,
                               width: 100,
                               height: 100)
        spinner.center = view.center
    }
    
    private func addNoNotificationView(){
        tableView.isHidden = true
        view.addSubview(noNotificationsView)
        noNotificationsView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: view.width/2,
                                           height: view.height/4)
        noNotificationsView.center = view.center
    }
    
    private func fetchNotifications(){
        for x in 0...100{
            let user = User(identifier: "", userName: "Volkan", profilePhoto: URL(string: "https://www.google.com")!,
                            name: (first: "Volkan", last: "Sahin"),
                            birthDate: Date(),
                            bio: "",
                            counts: UserCounts(following: 10, followers: 10, post: 10),
                            joinDate: Date())
            let post = UserRoute(identifier: "", owner: user, routeMapImage: URL(string: "https://www.google.com")!, velocityGraph: URL(string: "https://www.google.com")!, routeMapThumbnailImage: URL(string: "https://www.google.com")!, routeContent: [Content(type: .image)], routeName: "Ankara", routeLength: "", routeDuration: "", city: "Ankara", coordinates: [Coordinate(identifier: "", routeIdentifier: "", latitude: "", longitude: "")], elevations: [Elevation(elevation: 10.0)], speeds: [Speed(speed: 10.0)], likeCount: [RouteLikes(identifier: "", postIdentifier: "", user: user)], comments: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "Hello", createdDate: Date(), likes: [CommentLikes(identifier: "", commentIdentifier: "", user: user)], replyComment: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "Hi", createdDate: Date(), likes: [], replyComment: [])])], createdDate: Date(), tagUser: [user,user], elevationGraph: URL(string: "https://www.google.com")!)
            
            
            let modal = UserNotification(type: x % 2 == 0 ? .like(post: post) : .follow(state: .following),text: "Hello",user: user)
            modals.append(modal)
        }
    }
    
    
}

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modal = modals[indexPath.row]
        switch modal.type{
        case .like(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier, for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: modal)
            cell.delegate = self
            return cell
        case .follow:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier, for: indexPath) as! NotificationFollowEventTableViewCell
           // cell.configure(with: modal)
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}

extension NotificationViewController: NotificationFollowEventTableViewCellDelegate{
    func didTapFollowUnFollowButton(modal: UserNotification) {
        //perform databse update
    }
    
    
}

extension NotificationViewController: NotificationLikeEventTableViewCellDelegate{
    func didTapLikedRouteButton(modal: UserNotification) {
        // Open Post Detail
        switch modal.type{
        case .like(let post):
            let vc = DetailedRouteViewController()
            vc.modal = post
            vc.title = "Route"
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .follow(_):
            fatalError("Shouldn't be trigged. Dev Error")
        }
        
    }
    
}

