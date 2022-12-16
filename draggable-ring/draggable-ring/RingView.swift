//
//  RingView.swift
//  draggable-ring
//
//  Created by Luqman on 12/8/22.
//

import UIKit

class RingView: UIImageView{

    static let radius = 30

    override init(frame: CGRect = CGRect(x: 0, y: 0, width: RingView.radius, height: RingView.radius)) {
        super.init(frame: frame)
        drawRing()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func drawRing() {
        let circleShape = CAShapeLayer()
        let circlePath = UIBezierPath(
            arcCenter: .zero, radius: CGFloat(RingView.radius), startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true
        )

        circleShape.path = circlePath.cgPath
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.strokeColor = UIColor.white.cgColor
        circleShape.lineWidth = 8

        layer.addSublayer(circleShape)
    }

}
