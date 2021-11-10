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

class CreateAnimationViewController: UIViewController {
    
    private var animatedMapView = MKMapView()
    private var drawingTimer: Timer?
    private var polyline: MKPolyline?
    
    private var maxEleLocationCoordinate : CLLocationCoordinate2D?
    private var maxSpeedLocationCoordinate : CLLocationCoordinate2D?
    
    private var maxSpeed = 0.0
    private var maxElevation = 0.0
    
    public var route = [CLLocationCoordinate2D]()
    public var locations = [CLLocation]()
    public var images = [RouteImage]()
    
    private var annotations = [MKPointAnnotation]()
    private var annotationCoords = [CLLocationCoordinate2D]()
    
    private var showLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .label
        label.textAlignment = .center
        label.frame = CGRect(x: 0,
                             y: 0,
                             width: 150,
                             height: 150)
        return label
    }()
    
    private let ContainerView : UIView = {
        let view = UIView()
        return view
    }()
    
    //Changed
    let selectionLabel = ["Speed Gauge", "Elevation Graph", "Duration", "Distance"]
    
    private var animationSelectionTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(AnimationSelectionTableViewCell.self, forCellReuseIdentifier: AnimationSelectionTableViewCell.identifier)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let PhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let actionContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    
    private let speedGaugeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Speed"
        label.isHidden = true
        return label
    }()
    
    private let elevationGraphLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Elevation"
        label.isHidden = true
        return label
    }()
    
    private let durationIndicatorLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Duration"
        label.isHidden = true
        return label
    }()
    
    private let distanceIndicatorLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Distance"
        label.isHidden = true
        return label
    }()
    
    private let shareButton : UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor(rgb: 0x5da973)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let buttonHeight = 52.0
    let buttonWidth = 100.0
    lazy var bottomHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
    
    public var duration = 10.0
    var currentStep = 1
    private var timer = Timer()
    var counter = 0
    var totalCount = 0.0
    public var durationTimer : String?
    public var isFinished = false
    
    private let elevationChartView : LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.isHidden = true
        lineChartView.backgroundColor = .none
        lineChartView.alpha = 0.6
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.isUserInteractionEnabled = false
        lineChartView.drawBordersEnabled = false
        
        let yAxis = lineChartView.leftAxis
        yAxis.drawLabelsEnabled = false
        yAxis.drawAxisLineEnabled = false
        yAxis.drawGridLinesEnabled = false
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        return lineChartView
    }()
    public var isElevationAvailable = false
    public var ElevationEntries = [ChartDataEntry]()
    public var elevationimage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(animatedMapView)
        view.addSubview(showLabel)
        //Changed
        view.addSubview(ContainerView)
        view.addSubview(actionContainerView)
        view.addSubview(animationSelectionTableView)
        view.addSubview(speedGaugeLabel)
        view.addSubview(elevationChartView)
        view.addSubview(durationIndicatorLabel)
        view.addSubview(distanceIndicatorLabel)
        view.addSubview(shareButton)
        view.addSubview(PhotoImageView)

        animationSelectionTableView.delegate = self
        animationSelectionTableView.dataSource = self
        PhotoImageView.image = elevationimage!
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
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Don't Share", style: .plain, target: self, action: #selector(cancelTapped))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*
        animatedMapView.frame = CGRect(x: 20.0,
                                       y: view.safeAreaInsets.top + 20,
                                       width: view.width - 40.0,
                                       height: view.width - 40.0)
        */
        PhotoImageView.frame = CGRect(x: 20.0,
                                      y: view.safeAreaInsets.top + 20,
                                      width: view.width - 40.0,
                                      height: view.width - 40.0)

        
        showLabel.center = PhotoImageView.center
        let ContainerViewHeight = 320.0
        let tableViewHeight = 200.0
        ContainerView.frame = CGRect(x: 0,
                                     y: PhotoImageView.bottom,
                                     width: view.width,
                                     height: ContainerViewHeight)
        
        shareButton.frame = CGRect(x: view.width/2.0 - buttonWidth/2.0,
                                   y: ContainerView.bottom - 20.0 - buttonHeight,
                                   width: buttonWidth,
                                   height: buttonHeight)
        
        actionContainerView.frame = CGRect(x: ContainerView.left + 20.0,
                                           y: ContainerView.top + 20.0,
                                           width: ContainerView.width - 40.0,
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
}

private extension CreateAnimationViewController {
    func center(onRoute route: [CLLocationCoordinate2D], fromDistance km: Double) {
        let center = MKPolyline(coordinates: route, count: route.count).coordinate
        animatedMapView.setCamera(MKMapCamera(lookingAtCenter: center, fromDistance: 2000, pitch: 0, heading: 0), animated: false)
    }
    
    func routeAnimate(duration: TimeInterval) {
        
        guard route.count > 0 else { return }
        
        let totalSteps = route.count
        let stepDrawDuration = duration/TimeInterval(totalSteps)
        timer = Timer.scheduledTimer(timeInterval: stepDrawDuration, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
        
    }
    
    @objc func animate(){
        //Duration
        counter = counter + Int((totalCount/duration)*(duration/Double(route.count)))
        let second = counter%60
        let minutes = counter/60
        let hours = counter/3600

        durationIndicatorLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, second)
        
        animatedMapView.setCamera(MKMapCamera(lookingAtCenter: route[currentStep-1], fromDistance: 200, pitch: 0, heading: 0), animated: true)
        
        let totalSteps = route.count
        var previousSegment: MKPolyline?
        
        if let previous = previousSegment {
            // Remove last drawn segment if needed.
            animatedMapView.removeOverlay(previous)
            previousSegment = nil
        }
        
        guard currentStep < totalSteps else {
            // If this is the last animation step...
            let finalPolyline = MKPolyline(coordinates: route, count: route.count)
            animatedMapView.addOverlay(finalPolyline)
            let location = locations.last!
            let distanceFromStart = location.distance(from: self.locations.first!)/1000.rounded(toPlaces: 2)
            let centerCoor = MKPolyline(coordinates: route, count: route.count).coordinate
            // Assign the final polyline instance to the class property.
            polyline = finalPolyline
            DispatchQueue.main.async {
                UIView.animate(withDuration: 2.0,
                               delay: 0.0,
                               options: [],
                               animations: {
                    self.showLabel.text = "End"
                    self.showLabel.fadeIn()
                    self.animatedMapView.setCamera(MKMapCamera(lookingAtCenter: centerCoor, fromDistance: distanceFromStart*1000, pitch: 0, heading: 0), animated: true)
                    self.isFinished = true
                    self.timer.invalidate()
                    
                }, completion: { [self] finished in
                    if finished{
                        showLabel.fadeOut()
                        animatedMapView.setCamera(MKMapCamera(lookingAtCenter: centerCoor, fromDistance: distanceFromStart*1000, pitch: 0, heading: 0), animated: true)
                    }
                })
            }
            return
        }
        
        // Animation step.
        // The current segment to draw consists of a coordinate array from 0 to the 'currentStep' taken from the route.
        let subCoordinates = Array(route.prefix(upTo: currentStep))
        let currentSegment = MKPolyline(coordinates: subCoordinates, count: subCoordinates.count)
        
        //Check Annotation
        let curentCoord = route[currentStep-1]
        if let index = self.annotationCoords.firstIndex(where:{$0 == curentCoord}){
            timer.invalidate()
            if annotations[index].title == "Start"{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 3.0,
                                   delay: 0.0,
                                   options: [],
                                   animations: {
                        self.showLabel.text = "Let's Go"
                        self.showLabel.fadeIn()
                    }, completion: { finished in
                        if finished{
                            self.showLabel.fadeOut()
                            self.routeAnimate(duration: self.duration)
                        }
                    })
                }
                
            }else if self.annotations[index].title == "MaxElevation"{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 2.0,
                                   delay: 0.0,
                                   options: [],
                                   animations: {
                        self.showLabel.text =  "\(self.maxElevation)m"
                        self.showLabel.fadeIn()
                    }, completion: { finished in
                        if finished{
                            self.showLabel.fadeOut()
                            self.routeAnimate(duration: self.duration)
                        }
                    })
                }
            }else if self.annotations[index].title == "MaxSpeed"{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 2.0,
                                   delay: 0.0,
                                   options: [],
                                   animations: {
                        self.showLabel.text =  "\(self.maxSpeed)m/sn"
                        self.showLabel.fadeIn()
                    }, completion: { finished in
                        if finished{
                            self.showLabel.fadeOut()
                            self.routeAnimate(duration: self.duration)
                        }
                    })
                }
            }else if self.annotations[index].title == "Image"{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 2.0,
                                   delay: 0.0,
                                   options: [],
                                   animations: {
                        self.showLabel.text =  "Image"
                        self.showLabel.fadeIn()
                    }, completion: { finished in
                        if finished{
                            self.showLabel.fadeOut()
                            self.routeAnimate(duration: self.duration)
                        }
                    })
                }
            }else if self.annotations[index].title == "Video"{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 2.0,
                                   delay: 0.0,
                                   options: [],
                                   animations: {
                        self.showLabel.text =  "Video"
                        self.showLabel.fadeIn()
                    }, completion: { finished in
                        if finished{
                            self.showLabel.fadeOut()
                            self.routeAnimate(duration: self.duration)
                        }
                    })
                }
            }
        }
        //Distance
        let currentLocation = locations[currentStep-1]
        let distanceFromStart = (currentLocation.distance(from: locations.first!)/1000).rounded(toPlaces: 2)
        distanceIndicatorLabel.text = String(distanceFromStart)+"km"
        
        //Elevation
        if ElevationEntries.isEmpty == false{
            let entries = Array(ElevationEntries.prefix(upTo: currentStep))
            if entries.count > 1 && isElevationAvailable{
                elevationChartView.isHidden = false
            }else{
                elevationChartView.isHidden = true
            }
            let set1 = LineChartDataSet(entries: entries, label: "")
            set1.mode = .cubicBezier
            set1.drawCirclesEnabled = false
            set1.lineWidth = 0
            set1.setColor(.white)
            set1.fill = Fill(color: .systemBlue)
            set1.fillAlpha = 1.0
            set1.drawFilledEnabled = true
            
            let data = LineChartData(dataSet: set1)
            data.setDrawValues(false)
            elevationChartView.data = data
            
        }
        
        animatedMapView.addOverlay(currentSegment)
        previousSegment = currentSegment
        currentStep += 1
    }
    
}

extension CreateAnimationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = UIColor(rgb: 0x5da973)
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.titleVisibility = .hidden
        switch annotation.title! {
        case "Start":
            annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "Start")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        case "End":
            annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "End")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        case "MaxElevation":
            annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "MaxElevation")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        case "MaxSpeed":
            annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "MaxSpeed")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        case "Image":
            annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "Image")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        case "Video":
            annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "Image")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        default:
            annotationView.markerTintColor = UIColor.blue
        }
        return annotationView
    }
}

extension CreateAnimationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnimationSelectionTableViewCell.identifier) as! AnimationSelectionTableViewCell
        cell.configure(with: selectionLabel[indexPath.row])
        cell.delegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}

extension CreateAnimationViewController: AnimationSelectionTableViewCellDelegate{
    func switchTriggered(switchLabel : String, state: Bool) {
        switch switchLabel{
        case "Speed Gauge":
            speedGaugeLabel.isHidden = !state
        case "Elevation Graph":
            isElevationAvailable = state
        case "Duration":
            durationIndicatorLabel.isHidden = !state
        case "Distance":
            distanceIndicatorLabel.isHidden = !state
        default:
            fatalError("Shouldn't be here")
        }
    }
    
}
