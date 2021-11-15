//
//  CreateAnimationViewController.swift
//
//  Created by Volkan on 02.11.2021.
//
import UIKit
import SDWebImage
import CoreLocation
import MapKit
import Charts
import AVKit

class CreateAnimationViewController: UIViewController {
    
    private var cretaAnimationTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CreateAnimationTableViewCell.self, forCellReuseIdentifier: CreateAnimationTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    public var images = [RouteImage]()
    public var route = [CLLocationCoordinate2D]()
    public var locations = [CLLocation]()
    public var totalCount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(cretaAnimationTableView)
        cretaAnimationTableView.delegate = self
        cretaAnimationTableView.dataSource = self
        //view.addSubview(animatedMapView)
        
/*
        avPlayerController.view.isHidden = true
        animationSelectionTableView.delegate = self
        animationSelectionTableView.dataSource = self
        center(onRoute: route, fromDistance: 10)
        //MapView
        animatedMapView.delegate = self
        //animatedMapView.translatesAutoresizingMaskIntoConstraints = false
        
        //Animation
        routeAnimate(duration: duration)
        
        //Max Elevation and Speed
        maxEleLocationCoordinate = locations.first!.coordinate
        maxSpeedLocationCoordinate = locations.first!.coordinate
        
        
        findMaxEleAndSpeedCoordinates(locations : locations)
        
        
        //Create Annotation
        createAnnotations(locationCoordinates : route, images : images)
        
        //Cancel Share
        self.tabBarController?.tabBar.isHidden = true

        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Don't Share", style: .plain, target: self, action: #selector(cancelTapped))
 */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cretaAnimationTableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - 49)
        /*
        animatedMapView.frame = CGRect(x: 20.0,
                                       y: view.safeAreaInsets.top + 20,
                                       width: view.width - 40.0,
                                       height: view.width - 40.0)
        
        routeImageView.frame = CGRect(x: 20.0,
                                      y: view.safeAreaInsets.top + 20,
                                      width: view.width - 40.0,
                                      height: view.width - 40.0)

        avPlayerController.view.frame = animatedMapView.bounds

        showLabel.center = animatedMapView.center
        let ContainerViewHeight = 320.0
        let tableViewHeight = 200.0
        containerView.frame = CGRect(x: 0,
                                     y: animatedMapView.bottom + 20.0,
                                     width: view.width,
                                     height: ContainerViewHeight)
        
        shareButton.frame = CGRect(x: view.width/2.0 - buttonWidth/2.0,
                                   y: containerView.bottom - 20.0 - buttonHeight,
                                   width: buttonWidth,
                                   height: buttonHeight)
        
        actionContainerView.frame = CGRect(x: containerView.left + 20.0,
                                           y: containerView.top + 20.0,
                                           width: containerView.width - 40.0,
                                           height: tableViewHeight)
        actionContainerView.layer.cornerRadius = 16.0
        
        animationSelectionTableView.frame = CGRect(x: actionContainerView.left + 10.0,
                                                   y: actionContainerView.top,
                                                   width: actionContainerView.width - 20.0,
                                                   height: tableViewHeight)
        let labelWidth = 80
        let labelHeight = 52
        speedGaugeLabel.frame = CGRect(x: Int(animatedMapView.right) - 20 - labelWidth,
                                       y: Int(animatedMapView.top) + 20,
                                       width: labelWidth,
                                       height: labelHeight)
        
        elevationChartView.frame = CGRect(x: Int(animatedMapView.left) + 5,
                                          y: Int(animatedMapView.top) + 20,
                                          width: Int(view.width)/2,
                                          height: 50)
        
        distanceIndicatorLabel.frame = CGRect(x:  Int(animatedMapView.left) + 20,
                                              y: Int(animatedMapView.bottom) - 20 - labelHeight,
                                              width: labelWidth,
                                              height: labelHeight)
        
        durationIndicatorLabel.frame = CGRect(x: Int(animatedMapView.right) - 20 - labelWidth,
                                              y: Int(animatedMapView.bottom) - 20 - labelHeight,
                                              width: labelWidth,
                                              height: labelHeight)
    */
    }
    
    /*
    //Cancel Save
    @objc func cancelTapped(){
        let actionSheet = UIAlertController(title: "Cancel Sharing Route", message: "Do you want to Cancel Sharing Route.", preferredStyle: .actionSheet)
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
    
    private func createAnnotations(locationCoordinates: [CLLocationCoordinate2D], images : [RouteImage]){
        annotationCoords.append(contentsOf:[locationCoordinates.first!, locationCoordinates.last!, maxEleLocationCoordinate!, maxSpeedLocationCoordinate!])
        let titles = ["Start", "End", "MaxElevation", "MaxSpeed"]
        for i in annotationCoords.indices {
            let annotation = MKPointAnnotation()
            annotation.coordinate = annotationCoords[i]
            annotation.title = titles[i]
            annotations.append(annotation)
            animatedMapView.addAnnotation(annotation)
            
        }
        
        for image in images{
            if images.count > 0{
                let annotation = MKPointAnnotation()
                annotation.coordinate = image.coordinate
                if image.image != nil{
                    annotation.title = "Image"
                }else{
                    annotation.title = "Video"
                }
                annotations.append(annotation)
                annotationCoords.append(annotation.coordinate)
                animatedMapView.addAnnotation(annotation)
            }
        }
        
        
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

    private func preparePlayer(with fileURL: URL) {
        
        avPlayer = AVPlayer(url: fileURL)
        
        avPlayerController.player = avPlayer
        
        // Turn on video controlls
        avPlayerController.showsPlaybackControls = false
        
        // play video
        avPlayerController.player?.play()
                
        avPlayerController.exitsFullScreenWhenPlaybackEnds = true
        
    }
         */
}

extension CreateAnimationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateAnimationTableViewCell.identifier, for: indexPath) as! CreateAnimationTableViewCell
        cell.configure(with: images[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.height-49
    }
    
}


