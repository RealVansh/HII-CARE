//
//  style.swift
//  PrescriptionScreen
//
//  Created by admin100 on 19/11/24.
//

import Foundation
import UIKit
class ViewStyle: UIView{
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
        
    }
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
        
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
        
    }
    @IBInspectable var shadowColor: UIColor = UIColor.clear
    {
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
        
    }

}
