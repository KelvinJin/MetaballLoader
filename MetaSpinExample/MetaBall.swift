//
//  MetaBall.swift
//  MetaSpinExample
//
//  Created by Jin Wang on 21/04/2015.
//  Copyright (c) 2015 uthoft. All rights reserved.
//

import UIKit
import GLKit

let ForceConstant: CGFloat = 6.67384
let DistanceConstant: CGFloat = 2.0
let MaximumForce: CGFloat = 10000

class MetaBall: NSObject {
    dynamic var center: CGPoint
    var radius: CGFloat
    private(set) var mess: CGFloat
    
    init(center: CGPoint, radius: CGFloat) {
        self.center = center
        self.radius = radius
        self.mess = ForceConstant * CGFloat(M_PI) * radius * radius
    }
    
    func forceAt(position: CGPoint) -> CGFloat {
        var div = pow(distance(center, toPoint: position) , DistanceConstant)
        return div == 0 ? MaximumForce : mess / div
    }
    
    private func distance(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
        let difX = fromPoint.x - toPoint.x
        let difY = fromPoint.y - toPoint.y
        return sqrt(difX * difX + difY * difY)
    }
}