//
//  SelfUserMapAvatarView.swift
//  map-pinned-user
//
//  Created by Luqman on 12/19/22.
//

import UIKit
import MapKit

class SelfUserAnnotationView: MKAnnotationView, CLLocationManagerDelegate {
    let squircleBubble = SquircleBubbleView()
    let radarCone = RadarConeView()
    let pulsing = PulsingView()
    let locationManager = CLLocationManager()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configurePulsingView()
        configureSquircleBubble()
        configureRadarCone()
        configureLocationManager()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        radarCone.transform = CGAffineTransformMakeRotation(newHeading.magneticHeading.magnitude * .pi/180)
    }

    func configureRadarCone() {
        addSubview(radarCone)
        bringSubviewToFront(squircleBubble)
        radarCone.translatesAutoresizingMaskIntoConstraints = false
        radarCone.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radarCone.heightAnchor.constraint(equalToConstant: 95),
            radarCone.widthAnchor.constraint(equalToConstant: 70),
            radarCone.centerXAnchor.constraint(equalTo: squircleBubble.centerXAnchor),
            radarCone.topAnchor.constraint(equalTo: squircleBubble.bottomAnchor, constant: -95/2)
        ])


        radarCone.setAnchorPoint(CGPoint(x: 0.5, y: 0))
    }



    func configureSquircleBubble() {
        addSubview(squircleBubble)
        squircleBubble.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            squircleBubble.heightAnchor.constraint(equalToConstant: 38),
            squircleBubble.widthAnchor.constraint(equalToConstant: 38),
            squircleBubble.centerXAnchor.constraint(equalTo: pulsing.centerXAnchor),
            squircleBubble.centerYAnchor.constraint(equalTo: pulsing.centerYAnchor),
        ])


        UIView.animate(withDuration: 0.48, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.squircleBubble.transform = self.squircleBubble.transform.scaledBy(x: 1.06, y: 1.16)
        }, completion: nil)



    }

    func configurePulsingView() {
        addSubview(pulsing)
        pulsing.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pulsing.heightAnchor.constraint(equalToConstant: 38),
            pulsing.widthAnchor.constraint(equalToConstant: 38),
            pulsing.centerXAnchor.constraint(equalTo: centerXAnchor),
            pulsing.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        UIView.animate(withDuration: 1.6, delay: 0, options: [.repeat,], animations: {
            self.pulsing.transform = self.pulsing.transform.scaledBy(x: 3.4, y: 3.4)
            self.pulsing.alpha = 0
        }, completion: nil)

    }


}


class SquircleBubbleView: UIView{

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


class RadarConeView: UIView{

    let gradientColor = UIColor(
        red: 0.353, green: 0.485, blue: 0.970, alpha: 1
    )


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
                gradientColor.cgColor.copy(alpha: 0.01),
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

        let gradientColor = UIColor(red: 0.539, green: 1.000, blue: 0.811, alpha: 0.633)
        let gradientColor2 = UIColor(red: 0.896, green: 0.624, blue: 1.000, alpha: 0.606)

        //// Gradient Declarations
        let gradient = CGGradient(
            colorsSpace: nil,
            colors: [gradientColor.cgColor, gradientColor2.cgColor] as CFArray,
            locations: [0.01, 0.32, 0.8]
        )!

        //// Rectangle Drawing
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

