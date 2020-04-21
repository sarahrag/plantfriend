//
//  UIUpperCase.swift
//  PlantFriend
//
//  Created by Sarah Ragowski on 03.12.19.
//  Copyright © 2019 Sarah Ragowski. All rights reserved.
//

import UIKit


/**
    UIUpperCase:
    Class for a UILabel with all characters uppercased if "upperCase" is true.
 */
@IBDesignable
class UIUpperCase: UILabel {

    @IBInspectable
       var upperCase: Bool = false

       @IBInspectable
       var newText: String? {
           get {
               return super.text
           }
           
           set {
               if upperCase {
                   super.text = newValue?.uppercased()
               } else {
                   super.text = newValue
               }
               
           }
       }
       
       override var text: String? {
           get {
               return super.text
           }
           
           set {
               if upperCase {
                   super.text = newValue?.uppercased()
               } else {
                   super.text = newValue
               }
               
           }
       }

}
