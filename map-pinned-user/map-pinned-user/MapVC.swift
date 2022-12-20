//
//  ViewController.swift
//  map-pinned-user
//
//  Created by Luqman on 12/19/22.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    let bounds = UIScreen.main.bounds
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var userCoordinate: CLLocationCoordinate2D?
    var userCGPoint: CGPoint?
    let userPin  = MKPointAnnotation()

    var avatarBounds =  AvatarBounds.inBounds {
        didSet{
            switch avatarBounds{
            case  .inBounds:
                print("INBOUNDS")
            case  .leftSide:
                print("LEFT SIDE")
            case .rightSide:
                print("RIGHT SIDE")
            }
        }
    }
    //let selfUserMapAvatar = SelfUserMapAvatarView()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
    }

    override func viewDidAppear(_ animated: Bool) {
        renderPinnedUser()

    }

    func renderPinnedUser() {
        if let userCoordinate = mapView.userLocation.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: userCoordinate, span: span)
            mapView.setRegion(region, animated: true)
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
        mapView.showsUserLocation = true

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let userCGPoint = mapView.convert(mapView.userLocation.coordinate, toPointTo: mapView)
        let userView = mapView.view(for: mapView.userLocation)

        if userCGPoint.x <= 0 {
            if avatarBounds != .leftSide {
                avatarBounds = .leftSide
                UIView.animate(withDuration: 0.3, animations: {
                    userView?.alpha = 0
                })
            }

        } else if userCGPoint.x >= bounds.size.width{
            if avatarBounds != .rightSide {
                avatarBounds = .rightSide
                UIView.animate(withDuration: 0.3, animations: {
                    userView?.alpha = 0
                })
            }
        } else {
            if avatarBounds != .inBounds {
                avatarBounds = .inBounds
                UIView.animate(withDuration: 0.3, animations: {
                    userView?.alpha = 1
                })
            }
        }

    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {


        if annotation.isEqual(mapView.userLocation){
            let userAnnotationView = self.selfUserAnnotationView(in: mapView, for: annotation)
            if avatarBounds == .inBounds{
                UIView.animate(withDuration: 0.5, animations: {
                    userAnnotationView.alpha = 0
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })

            }else{
                userAnnotationView.alpha = 1
            }

            return userAnnotationView
        }
        return nil
    }


    private func selfUserAnnotationView(in mapView: MKMapView, for annotation: MKAnnotation) -> SelfUserAnnotationView {
        let identifier = "\(SelfUserAnnotationView.self)"

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? SelfUserAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let selfUserAnnotation = SelfUserAnnotationView(
                annotation: annotation, reuseIdentifier: identifier
            )
            selfUserAnnotation.canShowCallout = true
            return selfUserAnnotation
        }
    }
}

enum AvatarBounds {
    case leftSide
    case rightSide
    case inBounds
}
