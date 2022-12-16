//
//  ViewController.swift
//  draggable-ring
//
//  Created by Luqman on 12/8/22.
//

import UIKit

class ViewController: UIViewController {

    fileprivate let imageView = UIImageView(image: UIImage(named: "googlePin"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        view.addSubview(imageView)

        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:))))

        print("yes")



    }

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {

        if gesture.state ==  .began {
       
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            imageView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.4, animations: {
                self.imageView.transform = .identity
                //self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }


}

