//
//  UIAlertControllerExtension.swift
//  RSS-Parser
//
//  Created by Сергей on 10/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    @objc func urlValidate() {
        if let text = textFields?[0].text, let action = actions.last {
            if (text.hasPrefix("http://") || text.hasPrefix("https://")) {
                guard URL(string: text) != nil else {
                    action.isEnabled = false
                    return
                }
                
                action.isEnabled = true
            } else {
                guard URL(string: "http://" + text) != nil else {
                    action.isEnabled = false
                    return
                }
                
                action.isEnabled = true
            }
        }
    }
    
}
