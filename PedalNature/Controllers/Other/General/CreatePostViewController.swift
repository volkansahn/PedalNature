//
// CreatePostViewController.swift
// PedalNature
//
// Created by Volkan on 24.09.2021.
//
import UIKit
import MapKit
import CoreLocation
import Charts
import CoreGraphics

/// Create Post for Share
/// Reached from Activity Record View
final class CreatePostViewController: UIViewController {
    
    private var createRouteTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CreateRouteGraphsTableViewCell.self, forCellReuseIdentifier: CreateRouteGraphsTableViewCell.identifier)
        tableView.register(TagAndImagesTableViewCell.self, forCellReuseIdentifier: TagAndImagesTableViewCell.identifier)
        tableView.register(ElevationGraphTableViewCell.self, forCellReuseIdentifier: ElevationGraphTableViewCell.identifier)
        tableView.register(SpeedGraphTableViewCell.self, forCellReuseIdentifier: SpeedGraphTableViewCell.identifier)
        tableView.register(SaveButtonTableViewCell.self, forCellReuseIdentifier: SaveButtonTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    public var locationCoordinates = [CLLocationCoordinate2D]()
    
    public var locations = [CLLocation]()
    
    public var images = [RouteImage]()
    
    public var duration : String?
    
    public var distance : String?
    
    public var maxSpeed = 0.0
    
    public var maxElevation = 0.0
    
    private var maxEleLocationCoordinate : CLLocationCoordinate2D?
    private var maxSpeedLocationCoordinate : CLLocationCoordinate2D?
    
    private var modal : UserRoute?
    
    public var totalCount = 0
    
    public var elevationChart : LineChartView?
    public var speedChart : LineChartView?
    
    public var elevationImagely : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMockModals()
        configureRouteInfo()
        view.backgroundColor = .systemBackground
        //Route Graph
        view.addSubview(createRouteTableView)
        createRouteTableView.delegate = self
        createRouteTableView.dataSource = self
        
        //Cancel Route
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Don't Save", style: .plain, target: self, action: #selector(cancelTapped))
        
        if locations.count > 3{
            locations = Array(locations[3..<locations.count])
            locationCoordinates = Array(locationCoordinates[3..<locationCoordinates.count])
        }
        
        //Max Elevation and Speed
        maxEleLocationCoordinate = locations.first!.coordinate
        maxSpeedLocationCoordinate = locations.first!.coordinate
        
        findMaxEleAndSpeedCoordinates(locations : locations)
        
    }
    
    //Cancel Save
    @objc func cancelTapped(){
        let actionSheet = UIAlertController(title: "Cancel Saving Route", message: "Do you want to Cancel Save Route.\nThis route will not be listed on your profile ", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.navigationController?.popToRootViewController(animated: true)
                
                self.tabBarController?.tabBar.isHidden = false
                self.tabBarController?.selectedIndex = 0
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func findMaxEleAndSpeedCoordinates(locations : [CLLocation]){
        for location in locations {
            if location.speed > maxSpeed{
                maxSpeed = location.speed.rounded(toPlaces: 2)
                maxSpeedLocationCoordinate = location.coordinate
            }
            
            if location.altitude > maxElevation{
                maxElevation = location.altitude.rounded(toPlaces: 2)
                maxEleLocationCoordinate = location.coordinate
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        
        createRouteTableView.frame = CGRect(x: 0,
                                            y: view.safeAreaInsets.top + 20.0,
                                            width: view.width,
                                            height: view.height - 98)
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateRouteGraphsTableViewCell.identifier) as! CreateRouteGraphsTableViewCell
            cell.configure(with: locationCoordinates, locations: locations, images : images)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TagAndImagesTableViewCell.identifier) as! TagAndImagesTableViewCell
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ElevationGraphTableViewCell.identifier) as! ElevationGraphTableViewCell
            cell.configure(with: locations)
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: SpeedGraphTableViewCell.identifier) as! SpeedGraphTableViewCell
            cell.configure(with: locations)
            cell.delegate = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: SaveButtonTableViewCell.identifier) as! SaveButtonTableViewCell
            cell.delegate = self
            return cell
        default: fatalError("Shouldn't be here")
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section{
        case 0:
            return view.width
        case 1:
            return view.width/2
        case 2:
            return view.width
        case 3:
            return view.width
        case 4:
            return 110
        default: fatalError("Shouldn't be here")
            
        }
        
    }
    
}

extension CreatePostViewController: TagAndImagesTableViewCellDelegate{
    func tagPressed() {
        let vc = TagPeopleViewController()
        vc.title = "Tag People"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func imagesPressed() {
        let vc = RouteImageViewController()
        vc.title = "Route Images"
        vc.images = images
        vc.locationCoordinates = locationCoordinates
        vc.locations = locations
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func infoPressed() {
        let vc = RouteInfoViewController()
        vc.title = "Route Info"
        vc.duration = duration
        vc.distance = distance
        vc.maxSpeed = maxSpeed
        vc.maxElevation = maxElevation
        vc.locations = locations
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension CreatePostViewController: SaveButtonTableViewCellDelegate{
    func savePressed() {
        let mapPhotoView = createRouteTableView
        let render = UIGraphicsImageRenderer(size : mapPhotoView.bounds.size)
        //Map Image
        let mapImage = render.image{(context) in
            mapPhotoView.drawHierarchy(in: mapPhotoView.bounds, afterScreenUpdates: true)
        }
        print("map : \(mapImage.size)")
        
        //Elevation Chart Image
        //let elevationChartImage = UIImage(data: (elevationChart?.getChartImage(transparent: false)?.pngData())!)
        //print("elevation : \(elevationChartImage!.size)")
        
        //Speed Chart Image
        let speedChartImage = speedChart?.getChartImage(transparent: false)
        elevationImagely = speedChartImage
        print(speedChartImage)
        //print("speed : \(speedChartImage!.size)")
        
        let alert = UIAlertController(title: "Saved",
                                      message: "Your Route has been saved!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [self] _ in
            let vc = CreateAnimationViewController()
            vc.title = "Share Route"
            vc.route = self.locationCoordinates
            vc.locations = self.locations
            vc.images = self.images
            vc.elevationimage = self.elevationImagely!
            vc.totalCount = Double(self.totalCount)
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension CreatePostViewController: ElevationGraphTableViewCellDelegate{
    func returnElevationChart(elevationChartView: LineChartView) {
        elevationChart = elevationChartView
    }
    
    
}

extension CreatePostViewController: SpeedGraphTableViewCellDelegate{
    func returnSpeedChart(speedChartView: LineChartView) {
        speedChart = speedChartView
    }
    
}
