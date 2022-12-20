//
//  ViewController.swift
//  mapkit-POC
//
//  Created by Luqman on 12/16/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController{

    let bounds = UIScreen.main.bounds
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var userCoordinate: CLLocationCoordinate2D?
    var userCGPoint: CGPoint?
    var userTopAnchorConstraints: NSLayoutConstraint!
    var userLeadingAnchorConstraints: NSLayoutConstraint!
    var userTrailingAnchorConstraints: NSLayoutConstraint!
    var userHeightAnchorConstraints: NSLayoutConstraint!
    var userWidthAnchorConstraints: NSLayoutConstraint!
    let pinnedUserView = PinnedUserView()
    var isUserPinned = false {
        didSet{
            print("isUserOutBounds: \(isUserPinned)")
            if isUserPinned {
                UIView.animate(withDuration: 0.4, animations: {
                    self.pinnedUserView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                    self.pinnedUserView.alpha = 1
                })
                } else{

                    UIView.animate(withDuration: 0.4, animations: {
                        self.pinnedUserView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.pinnedUserView.alpha = 0
                    })

                }
        }

        willSet{

        }

    }


    override func viewDidLoad() {
        configureMapView()
        configurePinnedUserView()

        super.viewDidLoad()
    }

    func configurePinnedUserView() {
        view.addSubview(pinnedUserView)
        pinnedUserView.alpha = 0
        pinnedUserView.translatesAutoresizingMaskIntoConstraints = false

        userTopAnchorConstraints = pinnedUserView.topAnchor.constraint(equalTo: view.topAnchor)
        userTrailingAnchorConstraints = pinnedUserView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        userLeadingAnchorConstraints = pinnedUserView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)

        userHeightAnchorConstraints = pinnedUserView.heightAnchor.constraint(equalToConstant: 35)

        userWidthAnchorConstraints = pinnedUserView.widthAnchor.constraint(equalToConstant: 35)

        NSLayoutConstraint.activate([
            userHeightAnchorConstraints,
            userWidthAnchorConstraints,
            userTrailingAnchorConstraints,
            userTopAnchorConstraints,
        ])


    }

    func configureMapView() {
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.overrideUserInterfaceStyle = .dark
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])

    }

    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }



    func renderUserAnnotation(_ location: CLLocation) {

        self.userCoordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: self.userCoordinate!, span: span)

        mapView.setRegion(region, animated: true)

        let userPin  = MKPointAnnotation()
        userPin.coordinate = self.userCoordinate!
        mapView.addAnnotation(userPin)
    }

}

extension ViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.stopUpdatingLocation()

            renderUserAnnotation(location)
        }
    }

}

extension ViewController: MKMapViewDelegate{

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        if(self.userCoordinate == nil){
            return
        }
        self.userCGPoint = mapView.convert(self.userCoordinate!, toPointTo: self.view)
        print(self.userCGPoint ?? "nil")

        userTopAnchorConstraints.isActive = true
        userTopAnchorConstraints.constant = self.userCGPoint!.y - 35


        if((self.userCGPoint!.x) >= bounds.size.width){
            if (isUserPinned != true){
                isUserPinned = true
            }
            userLeadingAnchorConstraints.isActive = false
            userTrailingAnchorConstraints.isActive = true

            view.setNeedsLayout()
            view.layoutIfNeeded()
        } else if(self.userCGPoint!.x <= 0) {
            if (isUserPinned != true){
                isUserPinned = true
            }
            userTrailingAnchorConstraints.isActive = false
            userLeadingAnchorConstraints.isActive = true

            view.setNeedsLayout()
            view.layoutIfNeeded()
        } else{
            if (isUserPinned != false){
                isUserPinned = false
            }

            userLeadingAnchorConstraints.constant = self.userCGPoint!.x
            userLeadingAnchorConstraints.isActive = true
        }


    }
}

class PinnedUserView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let shape = CAShapeLayer()
        layer.addSublayer(shape)

        shape.fillColor = UIColor.red.cgColor


        let path = CGMutablePath()
        path.addRoundedRect(in: bounds, cornerWidth: 10, cornerHeight: 10)

        shape.path = path
    }


}
