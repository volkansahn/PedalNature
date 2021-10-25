//
//  RouteInfoViewController.swift
//  PedalNature
//
//  Created by Volkan on 25.10.2021.
//

import UIKit
import MapKit
import CoreLocation

/// Create Post for Share
/// Reached from Activity Record View
final class RouteInfoViewController: UIViewController {
	
	private var createRouteTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CreateRouteInfoTableViewCell.self, forCellReuseIdentifier: CreateRouteInfoTableViewCell.identifier)
        tableView.register(ElevationGraphTableViewCell.self, forCellReuseIdentifier: ElevationGraphTableViewCell.identifier)
        tableView.register(SpeedGraphTableViewCell.self, forCellReuseIdentifier: SpeedGraphTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
        
    public var locations = [CLLocation]()

    public var duration : String?
    
    public var distance : String?
    
    public var modal : UserRoute?
    
    public var maxSpeed = 0.0
	
    public var maxElevation = 0.0
    

	override func viewDidLoad() {
        super.viewDidLoad()
        createMockModals()
        view.addSubview(createRouteTableView)
        createRouteTableView.delegate = self
        createRouteTableView.dataSource = self
    }
	
	override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomHeight = view.safeAreaLayoutGuide.layoutFrame.size.height

        createRouteTableView.frame = CGRect(x: 0,
                                            y: view.safeAreaInsets.top,
                                            width: view.width,
                                            height: bottomHeight)
        
    }
	
	private func createMockModals(){
        let user = User(identifier: "", userName: "@Volkan", profilePhoto: URL(string: "https://www.google.com")!,
                        name: (first: "Volkan", last: "Sahin"),
                        birthDate: Date(),
                        bio: "",
                        counts: UserCounts(following: 10, followers: 10, post: 10),
                        joinDate: Date())
        
        
        let post = UserRoute(identifier: "", owner: user, routeMapImage: URL(string: "https://www.google.com")!, velocityGraph: URL(string: "https://www.google.com")!, routeMapThumbnailImage: URL(string: "https://www.google.com")!, routeContent: [Content(imageURL: "", videoURL: "", latitude: "", longitude: "")], routeName: "", routeLength: "", routeDuration: "", city: "Ankara", coordinates: [Coordinate(identifier: "", routeIdentifier: "", latitude: "", longitude: "")], elevations: [Elevation(elevation: 10.0)], speeds: [Speed(speed: 10.0)], likeCount: [RouteLikes(identifier: "", postIdentifier: "", user: user)], comments: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [CommentLikes(identifier: "", commentIdentifier: "", user: user)], replyComment: [RouteComment(identifier: "", commentIdentifier: "", user: user, text: "", createdDate: Date(), likes: [], replyComment: [])])], createdDate: Date(), tagUser: [user], elevationGraph: URL(string: "https://www.google.com")!)
        
       modal = post
    }
}

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateRouteInfoTableViewCell.identifier) as! CreateRouteInfoTableViewCell
            cell.configure(duration: duration!, distance: distance!, maxElevation: String(maxElevation), maxSpeed: String(maxSpeed))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ElevationGraphTableViewCell.identifier) as! ElevationGraphTableViewCell
            cell.configure(with: locations)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: SpeedGraphTableViewCell.identifier) as! SpeedGraphTableViewCell
            cell.configure(with: locations)
            return cell
        default: fatalError("Shouldn't be here")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return view.width
        case 1:
            return view.width
        case 2:
            return view.width
        default: fatalError("Shouldn't be here")
        }
    }
    
}
