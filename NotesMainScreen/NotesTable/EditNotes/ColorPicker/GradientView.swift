//
//  ColorPicker.swift
//  Notes
//
//  Created by Илья Бочков  on 2/8/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    let saturationExponentTop:Float = 1.4
    let saturationExponentBottom:Float = 1.0
    var elementSize: CGFloat = 2.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        for x: CGFloat in stride(from: 0.0, to: rect.width, by: elementSize) {
            for y: CGFloat in stride(from: 0.0, to: rect.height, by: elementSize) {
                context?.setFillColor(getColorAtPoint(point: CGPoint(x: x, y: y)).cgColor)
                context?.fill(CGRect(x: x, y: y, width: self.elementSize, height: self.elementSize))
            }
        }
    }
    
    func getPointForColor(color: UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        var yPos:CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        let xPos = hue * self.bounds.width
        return CGPoint(x: xPos, y: yPos)
    }
    
    func getColorAtPoint(point: CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x: elementSize * CGFloat(Int(point.x / elementSize)),
                               y: elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
