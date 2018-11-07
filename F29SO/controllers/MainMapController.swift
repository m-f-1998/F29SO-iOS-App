//
//  MainMapController.swift
//  F29SO
//
//  Created by Matthew on 29/10/2018.
//  Copyright © 2018 Matthew Frankland. All rights reserved.
//

import UIKit
import MapKit

class MainMapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView?
    private let pointsTitltes: [String] = ["Waverly", "Haymarket", "Leith", "Sighthill", "Holyrood", "Fort-Kinnaird", "Morningside", "Liberton", "Murrayfield", "Hilwood", "Danderhall", "West Pilton"]
    private let pointsLocation: [[Double]] = [[55.9520, -3.1900], [55.9453, -3.2224], [55.9755, -3.1665], [55.9230, -3.2849], [55.9460, -3.1596], [55.9343, -3.1045], [55.9277, -3.2101], [55.9132, -3.1600], [55.9422, -3.2408], [55.9544, -3.2735], [55.9140, -3.1149], [55.9708761165,  -3.2418490326]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView = MKMapView(frame: CGRect.init(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.bounds.width)!, height: (UIApplication.shared.keyWindow?.bounds.height)!))
        setRegion(lat: CLLocationDegrees.init(55.9533), long: CLLocationDegrees.init(-3.188267))
        self.mapView?.delegate = self
        
        self.view.addSubview(self.mapView!)
    }
    
    private func setRegion(lat: CLLocationDegrees, long: CLLocationDegrees) {
        // Set Hover Region To Region of Use
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
        let viewRegion: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 15500, longitudinalMeters: 15500);
        let adjustedRegion: MKCoordinateRegion = (mapView?.regionThatFits(viewRegion))!

        mapView?.setRegion(adjustedRegion, animated: true)
        self.mapView!.showsUserLocation = true
        setMarkouts()
    }
    
    private func setMarkouts() {
        if pointsTitltes.count == pointsLocation.count {
            for i in 0...pointsTitltes.count-1 {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.title = pointsTitltes[i]
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: pointsLocation[i][0], longitude: pointsLocation[i][1])
                mapView!.addAnnotation(newAnnotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let hireController = HireBikeController() as HireBikeController
        self.navigationController?.pushViewController(hireController, animated: true)
        
    }
    
}
