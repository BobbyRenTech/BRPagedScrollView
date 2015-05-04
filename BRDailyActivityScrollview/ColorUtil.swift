//
//  ColorUtil.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/4/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class ColorUtil: NSObject {
    // MARK: - Utils
    class func randomColor() -> UIColor {
        let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.brownColor()] as Array
        let index = arc4random_uniform(UInt32(colors.count))
        return colors[Int(index)]
    }
    
    class func blueColor() -> UIColor {
        return UIColor(red: 86/255.0, green: 192/255.0, blue: 232/255.0, alpha: 1)
    }
    
    class func greenColor() -> UIColor {
        return UIColor(red: 157.0/255.0, green: 225.0/255.0, blue: 47.0/255.0, alpha: 1)
    }

}
