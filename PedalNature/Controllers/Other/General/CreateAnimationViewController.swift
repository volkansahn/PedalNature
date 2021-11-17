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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cretaAnimationTableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - 49)
        
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
            cell.delegate = self
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateAnimationShareActionTableViewCell.identifier) as! CreateAnimationShareActionTableViewCell
            cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension CreateAnimationViewController: CreateAnimationShareActionTableViewCellDelegate{
    func shareButonPressed() {
        print("Share Pressed")
    }
}

extension CreateAnimationViewController: CreateAnimationSelectionTableViewCellDelegate{
    func elevationState(state: Bool) {
        print("elevation")
    }
    
    func durationState(state: Bool) {
        print("duration")
    }
    
    func distanceState(state: Bool) {
        print("distance")
    }
    
    
}
