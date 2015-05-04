//
//  ActivityCell.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/1/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit
import QuartzCore

class ActivityCell: UICollectionViewCell {
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
    }
    
    func setupWithActivity(activity:Activity) {
        self.layer.borderWidth = 4
        self.layer.borderColor = self.greenColor().CGColor
        self.backgroundColor = UIColor.whiteColor()
        self.labelText.text = activity.text
    }
    
    // MARK: - Utils
    func randomColor() -> UIColor {
        let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.brownColor()] as Array
        let index = arc4random_uniform(UInt32(colors.count))
        return colors[Int(index)]
    }

    func blueColor() -> UIColor {
        return UIColor(red: 86/255.0, green: 192/255.0, blue: 232/255.0, alpha: 1)
    }

    func greenColor() -> UIColor {
        return UIColor(red: 157.0/255.0, green: 225.0/255.0, blue: 47.0/255.0, alpha: 1)
    }
}
