//
//  RouteImagesTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 25.10.2021.
//

import UIKit

final class RouteImagesTableViewCell: UITableViewCell {
    //identifier
    static let identifier = "RouteImagesTableViewCell"
	
    private let mapView = MKMapView()

    private let routeImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = nil
        return imageView
    }()
	
	private let mapContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.masksToBounds = true
        view.isHidden = true
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
	
	private let notUseImageButton : UIButton = {
        let button = UIButton()
        button.setTitle("Don't Use", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor.red
        button.setTitleColor(.white, for: .normal)
        return button
    }()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
		mapView.delegate = self
        contentView.addSubview(mapView)
        contentView.addSubview(routeImageView)
        contentView.addSubview(elevationChartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        routeImageView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: contentView.width,
                                       height: 9*contentView.height/10)
		let mapContainerHeight = 50
		let mapContainerWidth = 100
									   
		mapContainerView.frame = CGRect(x: routeImageView.width-mapContainerWidth-20.0,
                                     y: routeImageView.bottom - mapContainerHeight-20,
                                     width: mapContainerWidth,
                                     height: mapContainerHeight)
									 
		mapView.frame = CGRect(x: mapContainerView.left + 5,
                                     y: mapContainerView.top + 5,
                                     width: mapContainerWidth-10,
                                     height: mapContainerHeight-10)
		
		let buttonWidth = 100
		notUseImageButton.frame = CGRect(x: contentView.width/2 - buttonWidth/2,
                                       y: routeImageView.bottom,
                                       width: buttonWidth,
                                       height: contentView.height/10)

    }
    
    public func configure(image: RouteImage, locationCoordinates: [CLLocationCoordinate2D], locations : [CLLocation]){
        
		routeImageView.image = image.image
        
		//mapView configure
		let coordinates = Array(locationCoordinates[3..<locationCoordinates.count])
        let syncedLocations = Array(locations[3..<locations.count])
        let polyline = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        let midLocation = coordinates[(coordinates.count/2)]
        let startLocation = locations.first!
        let endLocation = locations.last!
        let delta: CLLocationDistance = startLocation.distance(from: endLocation)
        let regionRadius : CLLocationDistance = delta + 500
        
        let coordinateRegion = MKCoordinateRegion(
            center: midLocation,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        addAnnotations(locationCoordinates : coordinates, image : image)
        return
       
    }
	
	private func addAnnotations(locationCoordinates: [CLLocationCoordinate2D], image : [RouteImage]){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = image.coordinate
        annotation.title = "Image"
        mapView.addAnnotation(annotation)
        
    }
}
extension CreateRouteGraphsTableViewCell: MKMapViewDelegate{
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
