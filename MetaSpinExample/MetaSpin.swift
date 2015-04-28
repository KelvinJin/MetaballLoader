//
//  MetaSpin.swift
//  MetaSpinExample
//
//  Created by Jin Wang on 21/04/2015.
//  Copyright (c) 2015 uthoft. All rights reserved.
//

import UIKit
import GLKit

class MetaSpin: UIView {
    
    var centralBallRadius: CGFloat = 30 {
        didSet {
            centralBall.radius = centralBallRadius
            cruiseRadius = (centralBallRadius + sideBallRadius) / 2 * 1.5
        }
    }
    var sideBallRadius: CGFloat = 16 {
        didSet {
            self.sideBall.radius = sideBallRadius
            cruiseRadius = (centralBallRadius + sideBallRadius) / 2 * 1.5
        }
    }
    var cruiseRadius: CGFloat = 35
    var ballFillColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.metaField.ballFillColor = ballFillColor
        }
    }
    var speed: CGFloat = 0.06
    
    private var centralBall: MetaBall!
    private var sideBall: MetaBall!
    private var metaField: MetaField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set backgrounds
        backgroundColor = UIColor.clearColor()
        
        metaField = MetaField(frame: frame)
        metaField.backgroundColor = UIColor.clearColor()
        
        addCentralBall()
        addSideBall()
        
        addSubview(metaField)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addCentralBall() {
        centralBall = MetaBall(center: center, radius: centralBallRadius)
        
        metaField.addMetaBall(centralBall)
    }
    
    private func addSideBall() {
        sideBall = MetaBall(center: center, radius: sideBallRadius)
        
        metaField.addMetaBall(sideBall)
    }
    
    func animateSideBall() {
//        let animationCenter = CGPoint(x: CGFloat(centralBall.center.x), y: CGFloat(centralBall.center.y) - centralBall.radius)
//        
//        let animationPath = UIBezierPath(arcCenter: animationCenter, radius: centralBall.radius, startAngle: CGFloat(3 * M_PI_2), endAngle: CGFloat(7 * M_PI_2), clockwise: true)
//        
//        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
//        pathAnimation.path = animationPath.CGPath
//        pathAnimation.calculationMode = kCAAnimationPaced
//        pathAnimation.fillMode = kCAFillModeForwards
//        pathAnimation.removedOnCompletion = false
//        pathAnimation.repeatCount = HUGE
//        pathAnimation.duration = 1.0
//        pathAnimation.delegate = self
//        
        
        let displayLink = CADisplayLink(target: self, selector: "moveSideBall")
        
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    var currentAngle = CGFloat(0)
    var maxAngle = CGFloat(2.0 * M_PI)
    var flip = false
    
    func moveSideBall() {
        nextAngle()
        
        sideBall.center = newCenter(toEaseIn(currentAngle))
        
        metaField.setNeedsDisplay()
    }
    
    func newCenter(angle: CGFloat) -> CGPoint {
        let x = centralBall.center.x + cruiseRadius * (flip ? -sin(angle) : sin(angle))
        let y = centralBall.center.y + (flip ? cruiseRadius : -cruiseRadius) + cruiseRadius * (flip ? -cos(angle) : cos(angle))
        
        return CGPoint(x: x, y: y)
    }
    
    private func nextAngle(){
        if currentAngle >= maxAngle {
            currentAngle = 0
            flip = !flip
        } else {
            currentAngle += CGFloat(maxAngle * speed)
        }
        
    }
    
    private func toEaseIn(angle: CGFloat) -> CGFloat {
        let ratio = angle / CGFloat(2 * M_PI)
        var processed_ratio: CGFloat = 0
        if ratio < 0.5 {
            processed_ratio =  (1 - pow(1 - ratio, 3.0)) * 8 / 14
        } else {
            processed_ratio = 1 - (1 - pow(ratio, 3.0)) * 8 / 14
        }
        
        return processed_ratio * CGFloat(2 * M_PI)
    }
}
