//
//  UILabel.swift
//  WordsGame
//
//  Created by khaledannajar on 6/24/19.
//  Copyright © 2019 khaledannajar. All rights reserved.
//

import UIKit

extension UILabel {
    func hide() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
        }) { (completed) in
            
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 1
            self.isHidden = false
        }) { (completed) in
            
        }
    }
}
