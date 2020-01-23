//
//  MapViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 13/04/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

import DatingKit



class MapViewController: UIViewController {
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    @IBOutlet weak var map: MKMapView!
    private let locationManager = CLLocationManager()
    
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        map.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        coordinate = locationManager.location?.coordinate

        getMyLocation()
    }
    
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnLocation(_ sender: Any) {
        getMyLocation()

    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }

    private func getMyLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if let locValue:CLLocationCoordinate2D = coordinate {
            map.mapType = MKMapType.standard
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            if let region: MKCoordinateRegion = MKCoordinateRegion(center: locValue, span: span) {
                map.setRegion(region, animated: true)
                locationManager.stopUpdatingLocation()
            } else {
                return
            }
        } else  {
            return
        }
       
      
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: CLLocationManagerDelegate,MKMapViewDelegate {
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        map.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        map.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinate = manager.location?.coordinate
//        manager.startUpdatingLocation()
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//
//        map.mapType = MKMapType.standard
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: locValue, span: span)
//        map.setRegion(region, animated: true)
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locValue
//        annotation.title = "Javed Multani"
//        annotation.subtitle = "current location"
//        map.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
}
