//
//  UIView+Extension.swift
//  OnTheGo
//
//  Created by Luqman Abdurrohman on 11/27/22.
//

import UIKit

extension UIView{
    
    @IBInspectable var cornerRadius : CGFloat{
        get {return self.cornerRadius}
        set{
            self.layer.cornerRadius = newValue
        }
        
    }
     
    
}
