//
//  ViewController.swift
//  MessengerSnapchatIntegration
//
//  Created by Luqman on 2/14/23.
//

import UIKit
import FacebookShare
import SCSDKCreativeKit


class ViewController: UIViewController, SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {


    }

    func sharer(_ sharer: Sharing, didFailWithError error: Error) {

    }

    func sharerDidCancel(_ sharer: Sharing) {

    }


    let messengerSDKBtn = UIButton()
    let messengerURLBtn = UIButton()
    let messengerOSBtn = UIButton()
    let snapchatBtn = UIButton()
    let viberBtn = UIButton()
    let button = FBSendButton()
    var snapAPI: SCSDKSnapAPI?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessengerSDKBtn()
        configureMessengerURLBtn()
        configureMessengerOSBtn()

//        snapAPI = SCSDKSnapAPI()

    }

    func configureMessengerOSBtn() {
        view.addSubview(messengerOSBtn)
        messengerOSBtn.backgroundColor = .systemGray
        messengerOSBtn.layer.cornerRadius = 10
        messengerOSBtn.setTitle("iOS", for: .normal)

        messengerOSBtn.addTarget(self, action: #selector(tappedMessengerOSBtn), for: .touchUpInside)

        messengerOSBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messengerOSBtn.heightAnchor.constraint(equalToConstant: 30),
            messengerOSBtn.widthAnchor.constraint(equalToConstant: 80),
            messengerOSBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            messengerOSBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    func configureMessengerURLBtn() {
        view.addSubview(messengerURLBtn)
        messengerURLBtn.backgroundColor = .blue
        messengerURLBtn.layer.cornerRadius = 10
        messengerURLBtn.setTitle("URL", for: .normal)

        messengerURLBtn.addTarget(self, action: #selector(tappedMessengerURLBtn), for: .touchUpInside)

        messengerURLBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messengerURLBtn.heightAnchor.constraint(equalToConstant: 30),
            messengerURLBtn.widthAnchor.constraint(equalToConstant: 80),
            messengerURLBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messengerURLBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20)
        ])
    }

    func configureMessengerSDKBtn() {
        view.addSubview(messengerSDKBtn)

        messengerSDKBtn.backgroundColor = .systemBlue
        messengerSDKBtn.layer.cornerRadius = 10
        messengerSDKBtn.setTitle("SDK", for: .normal)

        messengerSDKBtn.addTarget(self, action: #selector(tappedMessengerSDKBtn), for: .touchUpInside)

        messengerSDKBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messengerSDKBtn.heightAnchor.constraint(equalToConstant: 30),
            messengerSDKBtn.widthAnchor.constraint(equalToConstant: 80),
            messengerSDKBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messengerSDKBtn.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20)
        ])
    }

//    func configureSnapchatBtn() {
//        view.addSubview(snapchatBtn)
//        snapchatBtn.backgroundColor = .yellow
//        snapchatBtn.layer.cornerRadius = 10
//
//        snapchatBtn.addTarget(self, action: #selector(tappedSnapchatBtn), for: .touchUpInside)
//
//        snapchatBtn.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            snapchatBtn.heightAnchor.constraint(equalToConstant: 30),
//            snapchatBtn.widthAnchor.constraint(equalToConstant: 80),
//            snapchatBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            snapchatBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20)
//        ])
//    }

    @objc func tappedMessengerOSBtn() {
        let urlString = "https://peerclub.com/"
        let url = URL(string: urlString)!
        let text = "get this app" as String
        let shareObject: [AnyObject] = [urlString as AnyObject]

        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.completionWithItemsHandler = { (type,completed,items,error) in
            if completed { vc.dismiss(animated: true, completion: nil) }
        }
        present(vc, animated: true, completion: nil)
    }


    @objc func tappedMessengerURLBtn() {
        guard let msgURL = URL(string: "fb-messenger://share?link=https://peerclub.com/") else {return}
        UIApplication.shared.open(msgURL)
    }

    @objc func tappedMessengerSDKBtn() {
        guard let url = URL(string: "https://peerclub.com/") else {return}

        let content = ShareLinkContent()
        content.contentURL = url
        let dialog  = MessageDialog(content: content, delegate: self)
        dialog.show()
    }

//    @objc func tappedSnapchatBtn() {
//        print("snapchat")
//        guard let image = UIImage.init(named: "snapchat") else {return}
//        let snapImage = image/* Set your image here */
//        let photo = SCSDKSnapPhoto(image: snapImage)
//        let content = SCSDKPhotoSnapContent(snapPhoto: photo)
//
//       //disable user interaction until the share is over.
//       view.isUserInteractionEnabled = false
//       snapAPI?.startSending(content) { [weak self] (error: Error?) in
//           DispatchQueue.main.async {
//               self?.view.isUserInteractionEnabled = true
//           }
//         // Handle response
//       }
//
//    }

//    @objc func tappeddViberBtn() {
//        print("snapchat")
//        /* Stickers to be used in Snap */
//        //let stickerImage = /* prepare a sticker image */
//        let sticker = SCSDKSnapSticker(stickerImage: UIImage())
//        /* Alternatively, use a URL instead */
//        //let sticker = SCSDKSnapSticker(stickerUrl: stickerImageUrl, isAnimated: false)
//
//        /* Modeling a Snap using SCSDKVideoSnapContent */
//        let snap = SCSDKPhotoSnapContent(snapPhoto: SCSDKSnapPhoto(image: UIImage()))
//        snap.sticker = sticker /* Optional */
//        snap.caption = "Snap on Snapchat!" /* Optional */
//        snap.attachmentUrl = "https://www.snapchat.com" /* Optional */
//
//        let snapAPI = SCSDKSnapAPI()
//        snapAPI.startSending(snap, completionHandler: {_ in})
//    }
}

