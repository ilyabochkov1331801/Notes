//
//  ColorCellView.swift
//  Notes
//
//  Created by Илья Бочков  on 2/6/20.
//  Copyright © 2020 Илья Бочков . All rights reserved.
//

import UIKit

@IBDesignable
class ColorCellView: UIView {
    
    @IBInspectable var isSelected: Bool = false
    var shapePosition: CGPoint = .zero
    var shapeSize: CGFloat = 30
    var borderWidth: CGFloat = 2
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = borderWidth
        if isSelected {
            let xShift = 3 * rect.width / 5
            let yShift: CGFloat = 5
            shapePosition = CGPoint(x: rect.minX + xShift, y: yShift)
            shapeSize = rect.width / 4
            let path = makeFlagPath(in: CGRect(origin: shapePosition,
                                    size: CGSize(width: shapeSize,
                                                 height: shapeSize)))
            path.stroke()
        }
    }
    
    func isPointInView(point: CGPoint) -> Bool {
        return point.x < frame.maxX && point.x > frame.minX && point.y < frame.maxY && point.y > frame.minY
    }
    
    private func makeFlagPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.maxRadiusOfCircle,
            startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true
        )
        let shift = shapeSize / 4
        path.move(to: CGPoint(x: rect.midX - shift, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + shift))
        path.addLine(to: CGPoint(x: rect.midX + shift, y: rect.midY - shift))
        return path
    }
    
}
