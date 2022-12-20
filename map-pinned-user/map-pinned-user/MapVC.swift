//
//  ViewController.swift
//  map-pinned-user
//
//  Created by Luqman on 12/19/22.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var userCoordinate: CLLocationCoordinate2D?
    var userCGPoint: CGPoint?
    let userPin  = MKPointAnnotation()
    //let selfUserMapAvatar = SelfUserMapAvatarView()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
    }

    override func viewDidAppear(_ animated: Bool) {
        configureLocationManager()

    }

    func renderPinnedUser(_ location: CLLocation) {

        self.userCoordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        if let coordinate = self.userCoordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)


            self.userPin.coordinate = coordinate
            mapView.addAnnotation(self.userPin)
        }

    }

}

extension MapVC: MKMapViewDelegate {

    func configureMapView() {
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        mapView.delegate = self
        mapView.overrideUserInterfaceStyle = .dark
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard annotation is MKPointAnnotation else { return nil }
        let selfUserAnnotation = self.selfUserAnnotationView(
            in: mapView, for: annotation
        )
        return selfUserAnnotation
    }

    private func selfUserAnnotationView(in mapView: MKMapView, for annotation: MKAnnotation) -> SelfUserAnnotationView {
        let identifier = "\(SelfUserAnnotationView.self)"

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? SelfUserAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let customAnnotationView = SelfUserAnnotationView(
                annotation: annotation, reuseIdentifier: identifier
            )
            customAnnotationView.canShowCallout = true
            return customAnnotationView
        }
    }
}

extension MapVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.stopUpdatingLocation()
            renderPinnedUser(location)
        }
    }

    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

}
