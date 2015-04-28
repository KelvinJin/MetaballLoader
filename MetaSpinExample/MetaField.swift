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
    
    private var colorRed: UInt8 = 255
    private var colorGreen: UInt8 = 255
    private var colorBlue: UInt8 = 255
    
    var ballFillColor: UIColor {
        get {
            return UIColor(red: CGFloat(colorRed / 255), green: CGFloat(colorGreen / 255), blue: CGFloat(colorBlue / 255), alpha: 1.0)
        }
        set {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            newValue.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            self.colorRed = UInt8(red * 255)
            self.colorGreen = UInt8(green * 255)
            self.colorBlue = UInt8(blue * 255)
        }
    }
    
    private(set) var metaBalls: [MetaBall] = []
    
    override init(frame: CGRect) {
        let rect = CGRect(x: frame.minX, y: frame.minY, width: CGFloat(Int(frame.width)), height: CGFloat(Int(frame.height)))
        
        bytesPerRow = Int(frame.width) * bitsPerComponent * bytesPerPixel / 8
        data = UnsafeMutablePointer<UInt8>.alloc(bytesPerRow * Int(frame.height))
        
        super.init(frame: rect)
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
                    data[pointIndex + 0] = 1
                    data[pointIndex + 1] = colorRed
                    data[pointIndex + 2] = colorGreen
                    data[pointIndex + 3] = colorBlue
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
