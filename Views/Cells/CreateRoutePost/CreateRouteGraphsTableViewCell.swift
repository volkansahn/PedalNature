//
//  CreateRouteGraphsTableViewCell.swift
//  PedalNature
//
//  Created by Volkan on 12.10.2021.
//

import UIKit
import SDWebImage
import CoreLocation
import MapKit
import Charts

final class CreateRouteGraphsTableViewCell: UITableViewCell {

    static let identifier = "CreateRouteGraphsTableViewCell"

    private let mapView = MKMapView()
	
	private var maxEleLocationCoordinate : CLLocationCoordinate2D?
	private var maxSpeedLocationCoordinate : CLLocationCoordinate2D?

    private let locationManager: CLLocationManager

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mapView.delegate = self
        contentView.addSubview(graphContainerImageView)
        contentView.addSubview(mapView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = contentView.bounds
    }
	
    
    public func configure(with locationCoordinates: [CLLocationCoordinate2D], locations : [CLLocation], images : [RouteImage]){
        let coordinates = Array(locationCoordinates[3..<locationCoordinates.count])
        let syncedLocations = Array(locations[3..<locations.count])
		let polyline = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        let midLocation = coordinates[(coordinates.count/2)]
		let delta: CLLocationDistance = (coordinates.first).distanceFromLocation(coordinates.last)
        let regionRadius : CLLocationDistance = delta

        let coordinateRegion = MKCoordinateRegion(
            center: midLocation,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
		findMaxEleAndSpeedCoordinates(locations : syncedLocations)
		addAnnotations(locationCoordinates : coordinates, images : images)

        return
       
    }
	
	private func addAnnotations(locationCoordinates: [CLLocationCoordinate2D], images : [RouteImage], maxElevation){
		let coords = [locationCoordinates.first, locationCoordinates.last, maxEleLocationCoordinate, maxSpeedLocationCoordinate]
		let titles = ["Start", "End", "MaxElevation", "MaxSpeed"]
		let annotation = MKPointAnnotation()

		for i in coords.indices {
			annotation.coordinate = coords[i]
			annotation.title = titles[i]
			mapView.addAnnotation(annotation)
		}
		
		for image in images{
			annotation.coordinate = image.coordinate
			annotation.title = "Image"
			mapView.addAnnotation(annotation)
		}
		
		annotation.titleVisibility = .hidden
	}
	
	private func findMaxEleAndSpeedCoordinates(locations : [CLLocation]){
        for location in locations {
            if location.speed > maxSpeed{
				maxSpeedLocationCoordinate = locationManager.location
            }
            
            if location.altitude > maxElevation{
                maxElevation = location.altitude
				maxElevationLocationCoordinate = locationManager.location
            }
        }
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
		switch annotation.title!! {
			case "Start":
				annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
				annotationView.glyphImage = UIImage(named: "start")
			case "End":
				annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
				annotationView.glyphImage = UIImage(named: "end")			
			case "MaxElevation":
				annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
				annotationView.glyphImage = UIImage(named: "maxElevation")	
			case "MaxSpeed":
				annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
				annotationView.glyphImage = UIImage(named: "maxSpeed")
			case "Image":
				annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
				annotationView.glyphImage = UIImage(named: "image")
			default:
				annotationView.markerTintColor = UIColor.blue
		}    return annotationView
	}
}


