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
    @IBOutlet weak var canvas: UIView!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.canvas.layer.cornerRadius = 3
    }
}
