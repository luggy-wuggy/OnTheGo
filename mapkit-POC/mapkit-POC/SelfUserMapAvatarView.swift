//
//  SelfUserMapAvatarView.swift
//  mapkit-POC
//
//  Created by Luqman on 12/19/22.
//

import UIKit

class SelfUserMapAvatarView: UIView {

  

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
        red: 0.353, green: 0.485, blue: 0.970, alpha: 0.6
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

