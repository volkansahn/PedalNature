//
//  RouteImagesTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 25.10.2021.
//

import UIKit
import CoreLocation
import MapKit
import AVKit

final class RouteImagesTableViewCell: UITableViewCell {
    //identifier
    static let identifier = "RouteImagesTableViewCell"
    
    private let mapView = MKMapView()
    
    private let routeImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = nil
        imageView.isHidden = true
        return imageView
    }()
    
    private let mapContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = true
        view.alpha = 0.75
        return view
    }()
    
    private let routeMapImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = nil
        return imageView
    }()
    
    private let useNotUseImageButton : UIButton = {
        let button = UIButton()
        button.setTitle("Don't Use", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor.red
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    var avPlayer: AVPlayer!
    let avPlayerController = AVPlayerViewController()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mapView.delegate = self
        avPlayerController.view.isHidden = true
        contentView.addSubview(routeImageView)
        contentView.addSubview(avPlayerController.view)
        contentView.addSubview(mapContainerView)
        contentView.addSubview(mapView)
        contentView.addSubview(useNotUseImageButton)
        contentView.addSubview(dimmedView)
        
    }
    
    private func preparePlayer(with fileURL: URL) {
        
        avPlayer = AVPlayer(url: fileURL)
        
        avPlayerController.player = avPlayer
        
        // Turn on video controlls
        avPlayerController.showsPlaybackControls = true
        // play video
        avPlayerController.player?.play()
        


    }
    
    @objc func useNotUseImageButtonPressed(){
        
        if useNotUseImageButton.currentTitle == "Don't Use"{
            dimmedView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.dimmedView.alpha = 0.5
            }
            useNotUseImageButton.setTitle("Use", for: .normal)
            useNotUseImageButton.backgroundColor = UIColor(rgb: 0x5da973)
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.dimmedView.alpha = 0
            }) { done in
                if done{
                    self.dimmedView.isHidden = true
                }
            }
            useNotUseImageButton.setTitle("Don't Use", for: .normal)
            useNotUseImageButton.backgroundColor = UIColor.red
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonWidth = 100
        let buttonHeight = 52
        routeImageView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: contentView.width,
                                      height: contentView.height - CGFloat(buttonHeight) - 10)
        avPlayerController.view.frame = routeImageView.frame
        
         let mapContainerHeight = 50
         let mapContainerWidth = 100
         
        mapContainerView.frame = CGRect(x: Int(routeImageView.width)-mapContainerWidth-20,
                                        y: Int(routeImageView.bottom) - mapContainerHeight-40,
                                        width: mapContainerWidth,
                                        height: mapContainerHeight)
        
        mapView.frame = CGRect(x: Int(mapContainerView.left) + 5,
                               y: Int(mapContainerView.top) + 5,
                               width: mapContainerWidth-10,
                               height: mapContainerHeight-10)
         
        
        useNotUseImageButton.frame = CGRect(x: contentView.width/2 - CGFloat(buttonWidth/2),
                                            y: CGFloat(routeImageView.bottom + 10),
                                            width: CGFloat(buttonWidth),
                                            height: CGFloat(buttonHeight))
        
        dimmedView.frame = routeImageView.frame
        
    }
    
    public func configure(image: RouteImage, locationCoordinates: [CLLocationCoordinate2D], locations : [CLLocation]){
        
        if image.image != nil{
            routeMapImageView.isHidden = false
            print(image.image?.size)
            avPlayerController.view.isHidden = true
            routeImageView.image = image.image
            
        }else if image.videoURL != nil{
            routeMapImageView.isHidden = true
            avPlayerController.view.isHidden = false
            preparePlayer(with: image.videoURL!)
        }
        
        //mapView configure
        var coordinates = [CLLocationCoordinate2D]()
        var syncedLocations = [CLLocation]()
        
        if locationCoordinates.count > 4 && locations.count > 4{
            coordinates = Array(locationCoordinates[3..<locationCoordinates.count])
            syncedLocations = Array(locations[3..<locations.count])
        }else{
            coordinates = locationCoordinates
            syncedLocations = locations
        }
        let midLocation = coordinates[(coordinates.count/2)]
        let startLocation = syncedLocations.first!
        let endLocation = syncedLocations.last!
        let delta: CLLocationDistance = startLocation.distance(from: endLocation)
        let regionRadius : CLLocationDistance = delta + 500
        
        let coordinateRegion = MKCoordinateRegion(
            center: midLocation,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        addAnnotations(image : image)
        return
        
    }
    
    private func addAnnotations(image : RouteImage){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = image.coordinate
        annotation.title = "Image"
        mapView.addAnnotation(annotation)
        
    }
}
extension RouteImagesTableViewCell: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.9)
            renderer.lineWidth = 7
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.titleVisibility = .hidden
        annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
        annotationView.glyphImage = UIImage(named: "Image")
        annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        return annotationView
    }
}
