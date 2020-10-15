//
//  UIViewExtension.swift
//  App
//
//  Created by Luis Vasquez on 23/06/20.
//  Copyright © 2020 Cisco. All rights reserved.
//

import UIKit

extension UIView {
    func rounded(_ radius: CGFloat = 10.0){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func bordered(_ width: CGFloat = 1.0, color: CGColor = UIColor.systemBlue.cgColor){
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
}
