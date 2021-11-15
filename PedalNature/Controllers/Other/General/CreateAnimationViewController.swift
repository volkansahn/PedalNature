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
        tableView.register(CreateAnimationAnimatedMapTableViewCell.self, forCellReuseIdentifier: CreateAnimationAnimatedMapTableViewCell.identifier)
        tableView.register(CreateAnimationSelectionTableViewCell.self, forCellReuseIdentifier: CreateAnimationSelectionTableViewCell.identifier)
        tableView.register(CreateAnimationShareActionTableViewCell.self, forCellReuseIdentifier: CreateAnimationShareActionTableViewCell.identifier)
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
        
        //Cancel Share
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Don't Share", style: .plain, target: self, action: #selector(cancelTapped))
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
        
    */
    }
    
    
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

}

extension CreateAnimationViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateAnimationAnimatedMapTableViewCell.identifier) as! CreateAnimationAnimatedMapTableViewCell
            cell.configure(images: images, route: route, locations: locations)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateAnimationSelectionTableViewCell.identifier) as! CreateAnimationSelectionTableViewCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateAnimationShareActionTableViewCell.identifier) as! CreateAnimationShareActionTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section{
        case 0:
            return view.width
        case 1:
            return view.width/2
        case 2:
            return view.width/8
        default: fatalError("Shouldn't be here")
            
        }
        
    }
    
}
