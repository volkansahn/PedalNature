//
//  CreateAnimationTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 14.11.2021.
//
import UIKit
import MapKit
import CoreLocation
import Charts
import AVKit

class CreateAnimationAnimatedMapTableViewCell: UITableViewCell {
    
    // MARK: Variable Decleration
    
    static let identifier = "CreateAnimationAnimatedMapTableViewCell"
    
    private var animatedMapView = MKMapView()
    private var drawingTimer: Timer?
    private var polyline: MKPolyline?
    
    private var maxEleLocationCoordinate : CLLocationCoordinate2D?
    private var maxSpeedLocationCoordinate : CLLocationCoordinate2D?
    
    private var maxSpeed = 0.0
    private var maxElevation = 0.0
    
    public var routeCoordinate = [CLLocationCoordinate2D]()
    public var routeLocations = [CLLocation]()
    public var routeImages = [RouteImage]()
    
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
    
    public var duration = 10.0
    var currentStep = 1
    private var timer = Timer()
    var counter = 0
    var totalCount = 0.0
    public var durationTimer : String?
    public var isFinished = false
    var showImage = UIImage()
    
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
    
    //Show Picture
    private let routeImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.alpha = 0.0
        return imageView
    }()
    //Show Video
    var avPlayer: AVPlayer!
    let avPlayerController = AVPlayerViewController()
  
    lazy var second = counter%60
    lazy var minutes = counter/60
    lazy var hours = counter/3600
    
    var isDurationEnabled = false {
      didSet {
          if isDurationEnabled{
              DispatchQueue.main.async {
                  self.durationIndicatorLabel.isHidden = false
                  self.durationIndicatorLabel.text = String(format: "%02d:%02d:%02d", self.hours, self.minutes, self.second)
              }
          }else{
              DispatchQueue.main.async {
                  self.durationIndicatorLabel.isHidden = true
              }
          }
      }
    }
    var isDistanceEnabled = false {
      didSet {
          if isDistanceEnabled{
              DispatchQueue.main.async {
                  self.distanceIndicatorLabel.isHidden = false
              }
          }else{
              DispatchQueue.main.async {
                  self.distanceIndicatorLabel.isHidden = true
              }
          }
      }
    }
    var isElevationGraphEnabled = false {
      didSet {
          if isElevationGraphEnabled{
              DispatchQueue.main.async {
                  self.elevationChartView.isHidden = false
              }
          }else{
              DispatchQueue.main.async {
                  self.elevationChartView.isHidden = true
              }
          }
               
      }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        //Animations
        contentView.addSubview(animatedMapView)
        contentView.addSubview(avPlayerController.view)
        contentView.addSubview(routeImageView)
        contentView.addSubview(elevationChartView)
        contentView.addSubview(durationIndicatorLabel)
        contentView.addSubview(distanceIndicatorLabel)
        contentView.addSubview(showLabel)
        
        animatedMapView.isHidden = false
        routeImageView.isHidden = true
        avPlayerController.view.isHidden = true
        
        //MapView
        animatedMapView.delegate = self
        animatedMapView.alpha = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        animatedMapView.frame = CGRect(x: 20,
                                       y: 10,
                                       width: contentView.width - 40,
                                       height: contentView.height)
        animatedMapView.layer.cornerRadius = 8.0
        routeImageView.frame = animatedMapView.bounds
        avPlayerController.view.frame = animatedMapView.bounds
        routeImageView.layer.cornerRadius = 8.0
        avPlayerController.view.layer.cornerRadius = 8.0
        
        showLabel.center = animatedMapView.center
        let labelWidth = 80
        let labelHeight = 52
        elevationChartView.frame = CGRect(x: Int(animatedMapView.left) + 5,
                                          y: Int(animatedMapView.top) + 20,
                                          width: Int(contentView.width)/2,
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
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(images: [RouteImage],  route : [CLLocationCoordinate2D], locations : [CLLocation], durationStatus: Bool, distanceStatus: Bool, elevationGraphStatus: Bool){
        routeCoordinate = route
        routeLocations = locations
        routeImages = images
        //Max Elevation and Speed
        maxEleLocationCoordinate = routeLocations.first!.coordinate
        maxSpeedLocationCoordinate = routeLocations.first!.coordinate
        
        findMaxEleAndSpeedCoordinates(locations : routeLocations)
        
        //Create Annotation
        createAnnotations(locationCoordinates : routeCoordinate, images : routeImages)
        
        //Animation
        routeAnimate(duration: duration)
        center(onRoute: routeCoordinate, fromDistance: 10)

        isDistanceEnabled = distanceStatus
        isDurationEnabled = durationStatus
        isElevationGraphEnabled = elevationGraphStatus
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
    
    
}

extension CreateAnimationAnimatedMapTableViewCell: MKMapViewDelegate {
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

private extension CreateAnimationAnimatedMapTableViewCell {
    func center(onRoute route: [CLLocationCoordinate2D], fromDistance km: Double) {
        let center = MKPolyline(coordinates: route, count: route.count).coordinate
        animatedMapView.setCamera(MKMapCamera(lookingAtCenter: center, fromDistance: 2000, pitch: 0, heading: 0), animated: false)
    }
    
    func routeAnimate(duration: TimeInterval) {
        
        guard routeCoordinate.count > 0 else { return }
        
        let totalSteps = routeCoordinate.count
        let stepDrawDuration = duration/TimeInterval(totalSteps)
        timer = Timer.scheduledTimer(timeInterval: stepDrawDuration, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
        
    }
    
    @objc func animate(){
        //Duration
        counter = counter + Int((totalCount/duration)*(duration/Double(routeCoordinate.count)))
        second = counter%60
        minutes = counter/60
        hours = counter/3600
        
        durationIndicatorLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, second)
        
        animatedMapView.setCamera(MKMapCamera(lookingAtCenter: routeCoordinate[currentStep-1], fromDistance: 200, pitch: 0, heading: 0), animated: true)
        
        let totalSteps = routeCoordinate.count
        var previousSegment: MKPolyline?
        
        if let previous = previousSegment {
            // Remove last drawn segment if needed.
            animatedMapView.removeOverlay(previous)
            previousSegment = nil
        }
        
        guard currentStep < totalSteps else {
            // If this is the last animation step...
            let finalPolyline = MKPolyline(coordinates: routeCoordinate, count: routeCoordinate.count)
            animatedMapView.addOverlay(finalPolyline)
            let location = routeLocations.last!
            let distanceFromStart = location.distance(from: self.routeLocations.first!)/1000.rounded(toPlaces: 2)
            let centerCoor = MKPolyline(coordinates: routeCoordinate, count: routeCoordinate.count).coordinate
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
        let subCoordinates = Array(routeCoordinate.prefix(upTo: currentStep))
        let currentSegment = MKPolyline(coordinates: subCoordinates, count: subCoordinates.count)
        
        //Check Annotation
        let curentCoord = routeCoordinate[currentStep-1]
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
                routeImageView.isHidden = false
                animatedMapView.isHidden = true
                routeImageView.bringSubviewToFront(animatedMapView)
                for image in self.routeImages{
                    if image.coordinate == curentCoord{
                        showImage = image.image!
                        routeImageView.image = self.showImage

                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.00) {
                   /*Do something after 2.00 seconds have passed*/
                    self.routeImageView.isHidden = true
                    self.animatedMapView.isHidden = false
                    self.animatedMapView.bringSubviewToFront(self.routeImageView)
                    self.routeAnimate(duration: self.duration)
                }
            }else if self.annotations[index].title == "Video"{
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 2.0,
                                   delay: 0.0,
                                   options: [],
                                   animations: {
                        for image in self.routeImages{
                            if image.coordinate == curentCoord{
                                self.animatedMapView.isHidden = true
                                self.avPlayerController.view.isHidden = true
                                self.preparePlayer(with: image.videoURL!)
                            }
                        }
                        
                    }, completion: { finished in
                        if finished{
                            self.animatedMapView.isHidden = false
                            self.avPlayerController.view.isHidden = true
                            self.routeAnimate(duration: self.duration)
                        }
                    })
                }
            }
        }
        //Distance
        let currentLocation = routeLocations[currentStep-1]
        let distanceFromStart = (currentLocation.distance(from: routeLocations.first!)/1000).rounded(toPlaces: 2)
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
    
    @objc func showTheImage(){
        
        
    }
}
