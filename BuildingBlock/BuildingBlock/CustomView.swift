//
//  CustomView.swift
//  BuildingBlock
//
//  Created by qingyun on 16/1/30.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

import UIKit

class CustomView: UIView {

    var curX:CGFloat = 0
    var curY:CGFloat = 0
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:AnyObject = (touches as NSSet).anyObject()!
        let lastTouch = touch.locationInView(self)
        
        curX = lastTouch.x
        curY = lastTouch.y
        
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(ctx, UIColor.redColor().CGColor)
        CGContextFillRect(ctx, CGRectMake(curX-10, curY-10, 20, 20))
    }
}
