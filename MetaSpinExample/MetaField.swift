//
//  MetaField.swift
//  MetaSpinExample
//
//  Created by Jin Wang on 21/04/2015.
//  Copyright (c) 2015 uthoft. All rights reserved.
//

import UIKit
import GLKit

class MetaField: UIView {
    
    var fieldThreshold: CGFloat = ForceConstant * CGFloat(M_PI)
    
    // Create a bitmap context
    let bytesPerPixel: Int = 4
    let bitsPerComponent: Int = 8
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedFirst.rawValue)
    var bytesPerRow: Int!
    var data: UnsafeMutablePointer<UInt8>!
    
    private(set) var metaBalls: [MetaBall] = []
    
    override init(frame: CGRect) {
        let rect = CGRect(x: frame.minX, y: frame.minY, width: CGFloat(Int(frame.width)), height: CGFloat(Int(frame.height)))
        
        bytesPerRow = Int(frame.width) * bitsPerComponent * bytesPerPixel / 8
        data = UnsafeMutablePointer<UInt8>.alloc(bytesPerRow * Int(frame.height))
        
        super.init(frame: rect)
        
        backgroundColor = UIColor.blackColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addMetaBallAt(position: CGPoint, radius: CGFloat) {
        let newBall = MetaBall(center: position, radius: radius)
        
        metaBalls.append(newBall)
    }
    
    func addMetaBall(metaBall: MetaBall) {
        metaBalls.append(metaBall)
        setNeedsDisplay()
    }
    
    
    override func drawRect(rect: CGRect) {
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        
        let bitmapContext = myBitmapContext()
        
        // Loop through all the points
        for i in 0..<height {
            for j in 0..<width {
                let pointVector = CGPoint(x: j, y: i)
                let pointIndex = i * bytesPerRow + j * bytesPerPixel
                
                // Reset the current total force
                var totalForce: CGFloat = 0
                
                // Loop through the meta balls and calculate the total force
                for metaBall in metaBalls {
                    totalForce += metaBall.forceAt(pointVector)
                }
                
                // If the force is over the threshold, draw white
                if totalForce > fieldThreshold {
                    data[pointIndex + 0] = 255
                    data[pointIndex + 1] = 255
                    data[pointIndex + 2] = 255
                    data[pointIndex + 3] = 255
                }
            }
        }
        
        let imageRef = CGBitmapContextCreateImage(bitmapContext)
        
        let myContext = UIGraphicsGetCurrentContext()
        CGContextSaveGState(myContext)
        
        CGContextClearRect(myContext, rect)
        
        CGContextDrawImage(myContext, rect, imageRef)
        
        CGContextRestoreGState(myContext)
        
        memset(data, 0, bytesPerRow * Int(frame.height))
    }
    
    private func myBitmapContext() -> CGContextRef {
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        let ctx = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)
        
        return ctx
    }
}
