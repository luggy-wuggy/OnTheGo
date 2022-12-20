//
//  ViewController.swift
//  heading-POC
//
//  Created by Luqman on 12/15/22.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    let radarView = RadarView()
    let avatarView = AvatarView()
    let pulsingView = PulsingView()




    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingHeading()

        configureUserPin()
        configurePulsing()


    }

    override func viewDidAppear(_ animated: Bool) {

        UIView.animate(withDuration: 0.48, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.avatarView.transform = self.avatarView.transform.scaledBy(x: 1.06, y: 1.13)
            self.view.layoutIfNeeded()
        }, completion: nil)

        UIView.animate(withDuration: 1.6, delay: 0, options: [.repeat,], animations: {
            self.pulsingView.transform = self.pulsingView.transform.scaledBy(x: 3.2, y: 3.2)
            self.pulsingView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading.magneticHeading)
        radarView.transform = CGAffineTransformMakeRotation(newHeading.magneticHeading.magnitude * .pi/180)

    }

    func configurePulsing() {
        view.addSubview(pulsingView)
        view.sendSubviewToBack(pulsingView)

        pulsingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pulsingView.heightAnchor.constraint(equalToConstant: 38),
            pulsingView.widthAnchor.constraint(equalToConstant: 38),
            pulsingView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            pulsingView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor)
        ])


    }

    fileprivate func configureUserPin() {
        view.addSubview(radarView)

        radarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radarView.heightAnchor.constraint(equalToConstant: 95),
            radarView.widthAnchor.constraint(equalToConstant: 70),
            radarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            radarView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -95/2)
        ])


        radarView.setAnchorPoint(CGPoint(x: 0.5, y: 0))




        view.addSubview(avatarView)

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.heightAnchor.constraint(equalToConstant: 38),
            avatarView.widthAnchor.constraint(equalToConstant: 38),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -47.5  - 12.5)
        ])
    }


}

class PulsingView: UIView{

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Color Declarations
        let gradientColor = UIColor(red: 0.539, green: 1.000, blue: 0.811, alpha: 0.633)
        let gradientColor2 = UIColor(red: 0.896, green: 0.624, blue: 1.000, alpha: 0.606)

        //// Gradient Declarations
        let gradient = CGGradient(
            colorsSpace: nil,
            colors: [gradientColor.cgColor, gradientColor2.cgColor] as CFArray,
            locations: [0.01, 0.32, 0.8]
        )!

        //// Rectangle Drawing
//        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 12, y: 13, width: 52, height: 52), cornerRadius: 15)
        let rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: 12)
        context.saveGState()
        rectanglePath.addClip()
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: rect.minX + 8, y: rect.minY + 8),
            end: CGPoint(x: rect.maxX - 3, y: rect.maxY),
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()


        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: rect.midX - (rect.width - 8)/2 , y: rect.midY -  (rect.width - 8)/2, width: rect.width - 8, height: rect.height - 8), cornerRadius: 9)
        context.saveGState()
        rectangle2Path.addClip()
        context.drawLinearGradient(gradient,
            start: CGPoint(x: rect.maxX - 3, y: rect.maxY),
            end: CGPoint(x: rect.minX + 8, y: rect.minY + 8),
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()
    }

}



class AvatarView: UIView{


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let shape = CAShapeLayer()
        layer.addSublayer(shape)

        shape.fillColor = UIColor.red.cgColor
        shape.strokeColor = UIColor.black.cgColor
        shape.lineWidth = 2

        let path = CGMutablePath()
        path.addRoundedRect(in: bounds, cornerWidth: 15, cornerHeight: 15)
        shape.path = path
    }

}

class RadarView: UIView{

    let gradientColor = UIColor(red: 0.353, green: 0.485, blue: 0.970, alpha: 0.6)


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let gradient = CGGradient(
            colorsSpace: nil,
            colors: [
                gradientColor.cgColor,
                UIColor.clear.cgColor
            ] as CFArray,
            locations: [0.01, 0.6]
        )!

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: rect.midX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.midX, y: rect.minX))
        bezierPath.close()
        context.saveGState()
        bezierPath.addClip()
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: rect.midX, y: rect.minY),
            end: CGPoint(x: rect.midX, y: rect.maxY + 40),
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
        )
        context.restoreGState()

    }

}

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y



        layer.position = position
        layer.anchorPoint = point
    }
}
