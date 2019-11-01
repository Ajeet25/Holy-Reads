//
//  DashBoardVC.swift
//  Sabjiwala
//
//  Created by Ritesh Jain on 11/06/18.
//  Copyright © 2018 OWeBest.com. All rights reserved.
//

import Foundation
import UIKit

class ResponsiveButton: UIButton {
    
    
    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let buttonSize = self.frame.size
        let widthToAdd = (44-buttonSize.width > 0) ? 44-buttonSize.width : 0
        let heightToAdd = (44-buttonSize.height > 0) ? 44-buttonSize.height : 0
        let largerFrame = CGRect(x: 0-(widthToAdd/2), y: 0-(heightToAdd/2), width: buttonSize.width+widthToAdd, height: buttonSize.height+heightToAdd)
        return (largerFrame.contains(point)) ? self : nil
    }
}
