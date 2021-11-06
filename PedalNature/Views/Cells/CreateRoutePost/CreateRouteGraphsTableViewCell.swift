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
    
    private var maxSpeed = 0.0
    private var maxElevation = 0.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        mapView.delegate = self
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
        if locationCoordinates.count > 3{
            let coordinates = Array(locationCoordinates[3..<locationCoordinates.count])
            let syncedLocations = Array(locations[3..<locations.count])
            let polyline = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
            let midLocation = coordinates[(coordinates.count/2)]
            let startLocation = locations.first!
            let endLocation = locations.last!
            let delta: CLLocationDistance = startLocation.distance(from: endLocation)
            let regionRadius : CLLocationDistance = delta + 100
            
            let coordinateRegion = MKCoordinateRegion(
                center: midLocation,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius)
            
            mapView.setRegion(coordinateRegion, animated: true)
            findMaxEleAndSpeedCoordinates(locations : syncedLocations)
            addAnnotations(locationCoordinates : coordinates, images : images)
        }else{
            print("finished too early")
        }
        
                
    }
    
    private func addAnnotations(locationCoordinates: [CLLocationCoordinate2D], images : [RouteImage]){
        let coords = [locationCoordinates.first!, locationCoordinates.last!, maxEleLocationCoordinate, maxSpeedLocationCoordinate]
        let titles = ["Start", "End", "MaxElevation", "MaxSpeed"]
        for i in coords.indices {
            let annotation = MKPointAnnotation()
            if coords[i] != nil{
                annotation.coordinate = coords[i]!
                annotation.title = titles[i]
                mapView.addAnnotation(annotation)
            }
            else{
                print("No \(titles[i])")
                return
            }
        }
        
        for image in images{
            if images.count > 0{
                let annotation = MKPointAnnotation()
                annotation.coordinate = image.coordinate
                annotation.title = "Image"
                mapView.addAnnotation(annotation)
            }
        }
        
        
    }
    
    private func findMaxEleAndSpeedCoordinates(locations : [CLLocation]){
        for location in locations {
            if location.speed > maxSpeed{
                maxSpeedLocationCoordinate = location.coordinate
            }
            
            if location.altitude > maxElevation{
                maxElevation = location.altitude
                maxEleLocationCoordinate = location.coordinate
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
        annotationView.titleVisibility = .hidden
        switch annotation.title!! {
        case "Start":
            //annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "Start")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        case "End":
            //annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "End")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        case "MaxElevation":
            //annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "MaxElevation")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        case "MaxSpeed":
            //annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "MaxSpeed")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        case "Image":
            //annotationView.markerTintColor = UIColor(rgb: 0xe7e7e7)
            annotationView.glyphImage = UIImage(named: "Image")
            annotationView.glyphImage!.withRenderingMode(.alwaysOriginal)
        default:
            annotationView.markerTintColor = UIColor.blue
        }
        return annotationView
    }
}

