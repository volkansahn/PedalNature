//
//  CreatePostViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit
import CoreLocation

/// Create Post for Share
/// Reached from Activity Record View
final class CreatePostViewController: UIViewController {

    private var createRouteTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CreateRouteGraphsTableViewCell.self, forCellReuseIdentifier: CreateRouteGraphsTableViewCell.identifier)
        tableView.register(CreateRouteInfoTableViewCell.self, forCellReuseIdentifier: CreateRouteInfoTableViewCell.identifier)
        tableView.register(CreateRouteTagsTableViewCell.self, forCellReuseIdentifier: CreateRouteTagsTableViewCell.identifier)
        tableView.register(CreateRouteImagesTableViewCell.self, forCellReuseIdentifier: CreateRouteImagesTableViewCell.identifier)
        tableView.register(ElevationGraphTableViewCell.self, forCellReuseIdentifier: ElevationGraphTableViewCell.identifier)
        tableView.register(SpeedGraphTableViewCell.self, forCellReuseIdentifier: SpeedGraphTableViewCell.identifier)
        tableView.register(CreatePostActionTableViewCell.self, forCellReuseIdentifier: CreatePostActionTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    public var locationCoordinates = [CLLocationCoordinate2D]()
    
    public var locations = [CLLocation]()
	
    public var images = [RouteImage]()

    public var duration : String?
    
    public var distance : String?
    
    public var modal : UserRoute?
    
    private var maxSpeed = 0.0
    private var maxElevation = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModals()
        view.backgroundColor = .systemBackground
        view.addSubview(createRouteTableView)
        createRouteTableView.delegate = self
        createRouteTableView.dataSource = self
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        configureRouteInfo()
        addAnnotations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomHeight = view.safeAreaLayoutGuide.layoutFrame.size.height

        createRouteTableView.frame = CGRect(x: 0,
                                            y: view.safeAreaInsets.top,
                                            width: view.width,
                                            height: bottomHeight)
        
    }
    
	private func addAnnotations(){
		let coords = [locationCoordinates.first, locationCoordinates.last]
		let titles = ["Start", "End"]
		for i in coords.indices {
			let annotation = MKPointAnnotation()
			annotation.coordinate = coords[i]
			annotation.title = titles[i]
			mapView.addAnnotation(annotation)
		}
	}
	
    private func configureRouteInfo(){
        for location in locations {
            if location.speed > maxSpeed{
                maxSpeed = maxSpeed.rounded(toPlaces: 2)
            }
            
            if location.altitude > maxElevation{
                maxElevation = location.altitude
                maxElevation = maxElevation.rounded(toPlaces: 2)

            }
        }
    }
    
    @objc func cancelTapped(){
        
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

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateRouteGraphsTableViewCell.identifier) as! CreateRouteGraphsTableViewCell
            cell.configure(with: locationCoordinates, locations: locations, images : images)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateRouteInfoTableViewCell.identifier) as! CreateRouteInfoTableViewCell
            cell.configure(duration: duration!, distance: distance!, maxElevation: String(maxElevation), maxSpeed: String(maxSpeed))
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateRouteTagsTableViewCell.identifier) as! CreateRouteTagsTableViewCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateRouteImagesTableViewCell.identifier) as! CreateRouteImagesTableViewCell
            cell.configure(with: images)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: ElevationGraphTableViewCell.identifier) as! ElevationGraphTableViewCell
            cell.configure(with: locations)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: SpeedGraphTableViewCell.identifier) as! SpeedGraphTableViewCell
            cell.configure(with: locations)
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreatePostActionTableViewCell.identifier) as! CreatePostActionTableViewCell
            return cell
        default: fatalError("Shouldn't be here")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return view.width
        case 1:
            return 100
        case 2:
            return 50
        case 3:
            return view.width
        case 4:
            return view.width
        case 5:
            return view.width
        case 6:
            return 50
        default: fatalError("Shouldn't be here")
        }
    }
    
}
