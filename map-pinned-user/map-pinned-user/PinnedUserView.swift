//
//  PinnedUserView.swift
//  map-pinned-user
//
//  Created by Luqman on 12/20/22.
//

import UIKit

class PinnedUserView: UIView {
    let squircleBubble = SquircleBubbleView()
    let pulsing = PulsingView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePulsingView()
        configureSquircleBubble()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        UIView.animate(withDuration: 1, delay: 0, options: [.repeat,], animations: {
            self.pulsing.transform = self.pulsing.transform.scaledBy(x: 1.5, y: 1.5)
            self.pulsing.alpha = 0
        }, completion: nil)

    }


}
