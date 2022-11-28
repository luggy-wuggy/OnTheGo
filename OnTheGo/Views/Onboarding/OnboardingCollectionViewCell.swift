//
//  OnboardingCollectionViewCell.swift
//  OnTheGo
//
//  Created by Luqman Abdurrohman on 11/27/22.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier : String = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImage: UIImageView!
    
    @IBOutlet weak var slideTitleLbl: UILabel!
    
    @IBOutlet weak var slideDescriptionLbl: UILabel!
    
    func setUp(_ slide: OnboardingSlide){
        self.slideImage.image = slide.image
        self.slideTitleLbl.text = slide.title
        self.slideDescriptionLbl.text = slide.description
    }
} 
