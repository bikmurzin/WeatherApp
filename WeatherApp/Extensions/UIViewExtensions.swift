////   /*
//
//  Project: WeatherApp
//  File: UIViewExtensions.swift
//  Created by: Robert Bikmurzin
//  Date: 13.10.2023
//
//  Status: in progress | Decorated
//
//  */

import UIKit

extension UIView {
    func round( _ radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
        
        // Если true, то subviews не выходят за границы view
        self.clipsToBounds = true
    }
    
    func addWhiteShadow() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }
    
    func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            self.addSubview(subview)
        }
    }
}
