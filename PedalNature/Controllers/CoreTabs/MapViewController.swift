//
//  MapViewController.swift
//  PedalNature
//
//  Created by Volkan on 24.09.2021.
//

import UIKit
import MapKit
import CoreLocation
/// Map Tab

final class MapViewController: UIViewController {
    
    private var mapView = MKMapView()
    private var imagePickerController: UIImagePickerController?
    private var timer = Timer()
    private var counter = 0
    
    public let stopButtonSize = 100.0
    private let goButtonSize = 100.0
    
    private let labelHeight = 40.0
    private let headerHeight = 25.0
    private var locationArray = [CLLocation]()
    private var locationCoordinateArray = [CLLocationCoordinate2D]()
    public var listOfContent = [RouteImage]()
    public var duration : String?
    public var distance : String?
    
    private let cameraButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .label
        button.isHidden = true
        return button
    }()
    
    private let distanceHeaderLabel : UILabel = {
        let label = UILabel()
        label.text = "DISTANCE"
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.isHidden = true
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    private let elevationHeaderLabel : UILabel = {
        let label = UILabel()
        label.text = "ELEVATION"
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        label.backgroundColor = .white
        return label
    }()
    
    private let timeHeaderLabel : UILabel = {
        let label = UILabel()
        label.text = "TIME"
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        label.backgroundColor = .white
        return label
    }()
    
    private let speedHeaderLabel : UILabel = {
        let label = UILabel()
        label.text = "SPEED"
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        label.backgroundColor = .white
        return label
    }()
    
    private let distanceLabel : UILabel = {
        let label = UILabel()
        label.text = "00.0km"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        label.backgroundColor = .white
        return label
    }()
    
    private let elevationLabel : UILabel = {
        let label = UILabel()
        label.text = "0m"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        label.backgroundColor = .white
        return label
    }()
    
    private let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        label.backgroundColor = .white
        return label
    }()
    
    private let speedLabel : UILabel = {
        let label = UILabel()
        label.text = "00m/sn"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        label.backgroundColor = .white
        return label
    }()
    
    private var pauseLabel : UILabel = {
        let label = UILabel()
        label.text = "PAUSED"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.systemRed.cgColor
        label.isHidden = true
        return label
    }()
    
    public var pauseButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemYellow
        button.isHidden = true
        return button
    }()
    
    public var playButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemGreen
        button.isHidden = true
        return button
    }()
    
    public var endButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemRed
        button.isHidden = true
        return button
    }()
    
    private var buttonContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xd5d5d5)
        view.isHidden = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private var goButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x5da973)
        // create attributed string
        let title = "Go"
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.label,
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
        let myAttrString = NSAttributedString(string: title, attributes: myAttribute)
        
        // set attributed text on a UILabel
        button.setAttributedTitle(myAttrString, for: .normal)
        
        button.isHidden = false
        return button
    }()
    
    private let locationManager = CLLocationManager()
    
    public var cameraReturn = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        view.addSubview(buttonContainerView)
        view.addSubview(goButton)
        view.addSubview(endButton)
        view.addSubview(pauseButton)
        view.addSubview(playButton)
        view.addSubview(pauseLabel)
        view.addSubview(distanceLabel)
        view.addSubview(elevationLabel)
        view.addSubview(timeLabel)
        view.addSubview(speedLabel)
        view.addSubview(distanceHeaderLabel)
        view.addSubview(elevationHeaderLabel)
        view.addSubview(timeHeaderLabel)
        view.addSubview(speedHeaderLabel)
        view.addSubview(cameraButton)
        mapView.layer.masksToBounds = true
        mapView.overrideUserInterfaceStyle = .dark
        locationManager.delegate = self
        askLocationPermission()
        goButton.addTarget(self,
                           action: #selector(startActivity), for: .touchUpInside)
        endButton.addTarget(self,
                            action: #selector(endPressed), for: .touchUpInside)
        playButton.addTarget(self,
                             action: #selector(playPressed), for: .touchUpInside)
        
        pauseButton.addTarget(self,action: #selector(pausePressed), for: .touchUpInside)
        
        cameraButton.addTarget(self,
                               action: #selector(cameraPressed), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
    }
    
    @objc func cameraPressed(){
        pausePressed()
        let vc = CameraViewController()
        vc.location = locationArray.last!
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pausePressed(){
        pauseButton.fadeOut()
        self.locationManager.stopUpdatingLocation()
        timer.invalidate()
        goButton.isHidden = true
        endButton.center.x = pauseButton.center.x
        playButton.center.x = pauseButton.center.x
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [],
                       animations: {
            self.endButton.isHidden = false
            self.playButton.isHidden = false
            self.pauseLabel.isHidden = false
            self.pauseLabel.fadeIn()
            self.endButton.fadeIn()
            self.playButton.fadeIn()
            self.endButton.center.x = self.stopButtonSize/2 + 20
            self.playButton.center.x = self.view.width-self.stopButtonSize/2-20
            
        }, completion: { finished in
            if finished{
                self.goButton.fadeIn()
                self.pauseLabel.isHidden = false
                self.goButton.isHidden = true
                self.pauseButton.isHidden = true
                self.buttonContainerView.isHidden = false
                self.tabBarController?.tabBar.isHidden = true
                self.locationManager.stopUpdatingLocation()
                self.endButton.center.x = self.stopButtonSize/2 + 20
                self.playButton.center.x = self.view.width-self.stopButtonSize/2-20
                
            }
            
        })
    }
    
    @objc func endPressed(){
        self.locationManager.stopUpdatingLocation()
        timer.invalidate()
        goButton.isHidden = false
        timeLabel.isHidden = true
        elevationLabel.isHidden = true
        speedLabel.isHidden = true
        distanceLabel.isHidden = true
        timeHeaderLabel.isHidden = true
        elevationHeaderLabel.isHidden = true
        speedHeaderLabel.isHidden = true
        distanceHeaderLabel.isHidden = true
        cameraButton.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        pauseButton.isHidden = true
        buttonContainerView.isHidden = true
        endButton.isHidden = true
        playButton.isHidden = true
        pauseLabel.isHidden = true
        
        let vc = CreatePostViewController()
        vc.title = "Create Post"
        vc.locations = locationArray
        vc.distance = distance
        vc.duration = duration
        vc.images = listOfContent
        vc.totalCount = counter
        vc.locationCoordinates = locationCoordinateArray
        self.navigationController?.pushViewController(vc, animated: true)
        UIApplication.shared.isIdleTimerDisabled = false
        
    }
    
    @objc func playPressed(){
        startTimer()
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [],
                       animations: {
            self.pauseLabel.fadeOut()
            self.pauseLabel.isHidden = true
            self.pauseButton.isHidden = false
            self.pauseButton.fadeIn()
        }, completion: { finished in
            if finished{
                self.goButton.isHidden = true
                self.endButton.isHidden = true
                self.playButton.isHidden = true
                self.buttonContainerView.isHidden = false
                self.tabBarController?.tabBar.isHidden = true
                self.locationManager.startUpdatingLocation()
            }
            
        })
    }
    
    @objc func startActivity(){
        goButton.fadeOut()
        timeLabel.isHidden = false
        elevationLabel.isHidden = false
        speedLabel.isHidden = false
        distanceLabel.isHidden = false
        timeHeaderLabel.isHidden = false
        elevationHeaderLabel.isHidden = false
        speedHeaderLabel.isHidden = false
        distanceHeaderLabel.isHidden = false
        cameraButton.isHidden = false
        locationManager.startUpdatingLocation()
        startTimer()
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
            self.goButton.center.y = self.pauseButton.center.y
            self.tabBarController?.tabBar.isHidden = true
            self.pauseButton.isHidden = false
            self.buttonContainerView.isHidden = false
            self.buttonContainerView.fadeIn()
            self.pauseButton.fadeIn()
            
        }, completion: { finished in
            if finished{
                self.locationManager.startUpdatingLocation()
                self.goButton.isHidden = true
                self.endButton.isHidden = true
                self.playButton.isHidden = true
                self.pauseButton.isHidden = false
                self.buttonContainerView.isHidden = false
            }
            
        })
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func UpdateTimer() {
        counter = counter + 1
        let second = counter%60
        let minutes = counter/60
        let hours = counter/3600
        if hours > 0{
            duration = String(format: "%02dh%02dm%02ds", hours, minutes, second)
        }else{
            if minutes > 0{
                duration = String(format: "%02dm%02ds", minutes, second)
            }else{
                duration = String(format: "%02ds", second)
            }
        }
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, second)
    }
    
    private func askLocationPermission(){
        // Get the current location permissions
        let status = locationManager.authorizationStatus
        // initialise a pop up for using later
        let alertController = UIAlertController(title: "Location Permission", message: "This app needs your location to track your cycling activity. Please go to Settings and turn on the permissions", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        // Handle each case of location permissions
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            print("Authorize.")
            // get the user location
            goButton.isHidden = false
        case .notDetermined:
            // ask permission
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            // redirect the users to settings
            self.present(alertController, animated: true, completion: nil)
        @unknown default:
            fatalError("Shouldn't be here")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bottomHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        mapView.frame = CGRect(x: 0,
                               y: 0,
                               width: view.width,
                               height: view.height-49)
        
        goButton.frame = CGRect(x: (view.width/2) - CGFloat(goButtonSize/2),
                                y: bottomHeight - CGFloat(goButtonSize/2),
                                width: goButtonSize,
                                height: goButtonSize)
        
        goButton.layer.cornerRadius = goButtonSize/2
        
        
        buttonContainerView.frame = CGRect(x: 0,
                                           y: view.height - 1.5*goButtonSize,
                                           width: view.width,
                                           height: 1.5*goButtonSize)
        
        pauseLabel.frame = CGRect(x: (view.width/2) - CGFloat(goButtonSize/2),
                                  y: buttonContainerView.top+(stopButtonSize/2),
                                  width: goButtonSize,
                                  height: goButtonSize/2)
        pauseLabel.layer.cornerRadius = 3.0
        
        pauseButton.frame = CGRect(x: (view.width/2) - CGFloat(stopButtonSize/2),
                                   y: buttonContainerView.top+(0.25*stopButtonSize),
                                   width: stopButtonSize,
                                   height: stopButtonSize)
        
        pauseButton.layer.cornerRadius = stopButtonSize/2
        
        endButton.frame = CGRect(x: CGFloat(stopButtonSize),
                                 y: buttonContainerView.top+(0.25*stopButtonSize),
                                 width: stopButtonSize,
                                 height: stopButtonSize)
        endButton.center.x = stopButtonSize/2 + 20
        endButton.layer.cornerRadius = stopButtonSize/2
        
        playButton.frame = CGRect(x: (view.width/2) - CGFloat(stopButtonSize/2),
                                  y: buttonContainerView.top+(0.25*stopButtonSize),
                                  width: stopButtonSize,
                                  height: stopButtonSize)
        playButton.center.x = view.width-stopButtonSize/2-20
        
        playButton.layer.cornerRadius = stopButtonSize/2
        
        let cameraButtonSize = 30
        cameraButton.frame = CGRect(x: Int(view.width) - cameraButtonSize - 30,
                                    y: Int(elevationHeaderLabel.top) - cameraButtonSize - 30,
                                    width: Int(1.5*Double(cameraButtonSize)),
                                    height: cameraButtonSize)
        
        let labelwidth = view.width/2
        
        elevationHeaderLabel.frame = CGRect(x: 0,
                                            y: view.height - 1.5*goButtonSize - 2*labelHeight - 2*headerHeight,
                                            width: labelwidth,
                                            height: headerHeight)
        
        timeHeaderLabel.frame = CGRect(x: labelwidth,
                                       y: view.height - 1.5*goButtonSize - 2*labelHeight - 2*headerHeight,
                                       width: labelwidth,
                                       height: headerHeight)
        
        distanceHeaderLabel.frame = CGRect(x: 0,
                                           y: view.height - 1.5*goButtonSize - labelHeight - headerHeight,
                                           width: labelwidth,
                                           height: headerHeight)
        speedHeaderLabel.frame = CGRect(x: labelwidth,
                                        y: view.height - 1.5*goButtonSize - labelHeight - headerHeight,
                                        width: labelwidth,
                                        height: headerHeight)
        
        elevationLabel.frame = CGRect(x: 0,
                                      y: elevationHeaderLabel.bottom,
                                      width: labelwidth,
                                      height: labelHeight)
        timeLabel.frame = CGRect(x: labelwidth,
                                 y: timeHeaderLabel.bottom,
                                 width: labelwidth,
                                 height: labelHeight)
        distanceLabel.frame = CGRect(x: 0,
                                     y: view.height - 1.5*goButtonSize - labelHeight,
                                     width: labelwidth,
                                     height: labelHeight)
        speedLabel.frame = CGRect(x: labelwidth,
                                  y: view.height - 1.5*goButtonSize - labelHeight,
                                  width: labelwidth,
                                  height: labelHeight)
        
    }
    
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        UIApplication.shared.isIdleTimerDisabled = true
        
        if let location = locations.first {
            
            locationArray.append(location)
            locationCoordinateArray.append(location.coordinate)
            configureIndicators(location : location)
            
            mapView.centerToLocation(location)
            mapView.showsUserLocation = true
            
        }
        
        
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        askLocationPermission()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
        print("error")
    }
    
    
    private func configureIndicators(location : CLLocation){
        DispatchQueue.main.async {
            let elevation = (location.altitude).rounded(toPlaces: 2)
            let speed = (location.speed).rounded(toPlaces: 2)
            self.elevationLabel.text = String(elevation)+"m"
            self.speedLabel.text = String(speed)+"m/sn"
            
            if self.locationArray.count > 4{
                let distanceFromStart = (location.distance(from: self.locationArray[3])/1000).rounded(toPlaces: 2)
                self.distanceLabel.text = String(distanceFromStart)+"km"
                self.distance = "\(distanceFromStart)"
            }
            
        }
    }
}

