//
//  UIColorLabel.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 30.01.20.
//  Copyright © 2020 Sarah Ragowski. All rights reserved.
//

import UIKit

/**
    UIColorLabel:
    Class for a Label with colored Background and optional UpperCase
 */
@IBDesignable
class UIColorLabel: UILabel {

    @IBInspectable
    var color: UIColor = .white
    
    @IBInspectable
    var upperCase: Bool = false
    
    @IBInspectable
    var newText: String? {
        get {
            return super.text
        }
        
        set {
            
            super.backgroundColor = color
            
            
        }
    }
    
    override var text: String? {
        get {
            return super.text
        }
        
        set {
            if(!upperCase){
                super.backgroundColor = color
                super.text = newValue
            }else{
                super.backgroundColor = color
                super.text = newValue?.uppercased()
            }
        }
    }
    

}
