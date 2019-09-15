//
//  Helper.swift
//  RSS-Parser
//
//  Created by Сергей on 11/09/2019.
//  Copyright © 2019 mytest. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    func createCustomButton(view: UIViewController, name: String, selector: Selector) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        var img = self.imageWithImage(image: UIImage(named: name)!, scaledToSize: CGSize(width: 26, height: 26))
        img = img.withRenderingMode(.alwaysTemplate)
        button.setImage(img, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(view, action: selector, for: .touchUpInside)
        return button
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
