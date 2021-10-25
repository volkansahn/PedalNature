//
//  RouteImageViewController.swift
//  PedalNature
//
//  Created by Volkan on 25.10.2021.
//

import UIKit
import MapKit
import CoreLocation

/// Create Post for Share
/// Reached from Activity Record View
final class RouteImageViewController: UIViewController {
	private var createRouteTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CreateRouteImagesTableViewCell.self, forCellReuseIdentifier: CreateRouteImagesTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    public var locationCoordinates = [CLLocationCoordinate2D]()
    
    public var locations = [CLLocation]()
    
    public var images = [RouteImage]()
	
	public var modal : UserRoute?

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
                                            y: view.safeAreaInsets.top + 10,
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
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: CreateRouteImagesTableViewCell.identifier) as! CreateRouteImagesTableViewCell
        cell.configure(image: images[indexPath.row], locationCoordinates: [CLLocationCoordinate2D], locations : [CLLocation])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.width
        
    }
    
}
