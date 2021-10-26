//
//  CreatePostViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit
import MapKit
import CoreLocation

/// Create Post for Share
/// Reached from Activity Record View
final class CreatePostViewController: UIViewController {

	private var createRouteTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CreateRouteGraphsTableViewCell.self, forCellReuseIdentifier: CreateRouteGraphsTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
	
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
	
	private let imagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Route Image"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let goToRouteImageButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        return button
    }()
	
	private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Route Info"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let goToRouteInfoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        return button
    }()
	
	private let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save Route", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor(rgb: 0x5da973)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
	
    public var locationCoordinates = [CLLocationCoordinate2D]()
    
    public var locations = [CLLocation]()
    
    public var images = [RouteImage]()
	
	public var duration : String?
	
    public var distance : String?  
	
	public var maxSpeed = 0.0
	
    public var maxElevation = 0.0
    
    private var modal : UserRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModals()
		configureRouteInfo()
        view.backgroundColor = .systemBackground
		//Route Graph
		view.addSubview(createRouteTableView)
        createRouteTableView.delegate = self
        createRouteTableView.dataSource = self
		// Tag
        view.addSubview(tagsLabel)
        view.addSubview(goToTagSearchButton)
        goToTagSearchButton.addTarget(self, action: #selector(didTapTagView), for: .touchUpInside)
		
		// Image
        view.addSubview(imagesLabel)
        view.addSubview(goToRouteImageButton)
        goToRouteImageButton.addTarget(self, action: #selector(didTapImagesView), for: .touchUpInside)
		
		// Info
        view.addSubview(infoLabel)
        view.addSubview(goToRouteInfoButton)
        goToRouteInfoButton.addTarget(self, action: #selector(didTapRouteInfoView), for: .touchUpInside)
		
		//Save Button
		view.addSubview(saveButton)
		saveButton.addTarget(self, action: #selector(saveRoutePressed), for: .touchUpInside)
		
		//Cancel Route
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        configureRouteInfo()
    }
    
	//Tag
	@objc func didTapTagView(){
        let vc = TagPeopleViewController()
        vc.title = "Tag People"
        self.navigationController?.pushViewController(vc, animated: true)
    }
	//Image
	@objc func didTapImagesView(){
        let vc = RouteImageViewController()
        vc.title = "Route Images"
		vc.images = images
		vc.locationCoordinates = locationCoordinates
		vc.locations = locations
        self.navigationController?.pushViewController(vc, animated: true)
    }
	//Info
	@objc func didTapRouteInfoView(){
        let vc = RouteInfoViewController()
        vc.title = "Route Info"
		vc.duration = duration
		vc.distance = distance
		vc.maxSpeed = 0.0
		vc.maxElevation = 0.0
		vc.locations = locations
        self.navigationController?.pushViewController(vc, animated: true)
    }
	
	//Save Route
	@objc func saveRoutePressed(){
        print("Save Pressed")
    }
	
	//Cancel Save
	@objc func cancelTapped(){
        print("Cancel Pressed")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        createRouteTableView.frame = CGRect(x: 0,
                                            y: view.safeAreaInsets.top,
                                            width: view.width,
                                            height: view.width)
		let goToViewHeights = 35
		tagsLabel.frame = CGRect(x: 5,
                                 y: Int(createRouteTableView.bottom) + 30,
                                 width: Int(view.width/2.0),
                                 height: goToViewHeights)
        
        goToTagSearchButton.frame = CGRect(x: Int(view.width)-50,
                                           y: Int(createRouteTableView.bottom) + 30,
                                           width: goToViewHeights,
                                           height: goToViewHeights)
		imagesLabel.frame = CGRect(x: 5,
                                   y: Int(tagsLabel.bottom) + 30,
                                   width: Int(view.width/2.0),
                                 height: goToViewHeights)
        
        goToRouteImageButton.frame = CGRect(x: Int(view.width)-50,
                                            y: Int(goToTagSearchButton.bottom) + 30,
                                           width: goToViewHeights,
                                           height: goToViewHeights)
		infoLabel.frame = CGRect(x: 5,
                                 y: Int(imagesLabel.bottom) + 30,
                                 width: Int(view.width/2.0),
                                 height: goToViewHeights)
        
        goToRouteInfoButton.frame = CGRect(x: Int(view.width)-50,
                                           y: Int(goToRouteImageButton.bottom) + 30,
                                           width: goToViewHeights,
                                           height: goToViewHeights)
										   
		let buttonWidth = 100
        saveButton.frame = CGRect(x: Int(view.width)/2 - buttonWidth/2,
                                  y: Int(infoLabel.bottom)+30,
                                       width: buttonWidth,
                                       height: 50)
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateRouteGraphsTableViewCell.identifier) as! CreateRouteGraphsTableViewCell
        cell.configure(with: locationCoordinates, locations: locations, images : images)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.width
        
    }
    
}
