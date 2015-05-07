//
//  WeightInputViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/4/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

protocol WeightInputDelegate {
    func didSetWeight(newWeight:CGFloat)
}

class WeightInputViewController: UIViewController {
    @IBOutlet weak var buttonMinus:UIButton!
    @IBOutlet weak var buttonPlus:UIButton!
    @IBOutlet weak var labelWeight:UILabel!
    
    @IBOutlet weak var viewKeyboard:UIView!
    
    var delegate:WeightInputDelegate?
    
    var weight:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateWeight()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeight() {
        if weight != nil {
            self.labelWeight.text = "\(weight!) lbs"
        }
        else {
            self.labelWeight.text = "Enter your weight"
        }
    }

    @IBAction func didPressButton(sender:UIButton!) {
        sender.backgroundColor = ColorUtil.blueColor()
    }
    
    @IBAction func didClickButton(sender:UIButton!) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            sender.backgroundColor = UIColor.clearColor()
        }) { (success) -> Void in
        }
        if sender == self.buttonMinus {
            if weight != nil {
                weight = weight! - 1
            }
        }
        else if sender == self.buttonPlus {
            if weight != nil {
                weight = weight! + 1
            }
        }
        else {
            if weight == nil {
                weight = 0
            }
            
            if sender.tag == -1 {
                // erase
                weight = weight! / 10
            }
            else if sender.tag == 10 {
                // confirm
                self.delegate!.didSetWeight(CGFloat(weight!))
            }
            else {
                weight = weight! * 10
                while weight > 999 {
                    weight = weight! - 1000
                }
                weight = weight! + sender.tag
            }
        }
        
        self.updateWeight()
    }
    
    func setupButtons() {
        var padding:CGFloat = 10
        var width:CGFloat = (self.viewKeyboard.frame.size.width - 2 * padding) / 3
        var height:CGFloat = (self.viewKeyboard.frame.size.height - 3 * padding) / 4
        width = min(width, height)
        var leftOffset = (self.viewKeyboard.frame.size.width - 3 * width - 2 * padding) / 2
        let border:CGFloat = 1
        var row: CGFloat
        var col: CGFloat
        for row = 0; row < 3; row++ {
            for col = 0; col < 3; col++ {
                let val:Int = Int(row * 3 + col + 1)
                let frame = CGRectMake(CGFloat(col) * (width + padding) + leftOffset, CGFloat(row) * (width + padding), width, width)
                let button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                button.frame = frame
                let string = "\(val)" as String
                button.setTitle(string, forState: UIControlState.Normal)
                button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
                button.titleLabel!.font = UIFont.systemFontOfSize(30)
                button.layer.cornerRadius = CGFloat(width/2)
                button.layer.borderWidth = border
                button.layer.borderColor = ColorUtil.blueColor().CGColor
                button.tag = val
                button.addTarget(self, action: "didPressButton:", forControlEvents: UIControlEvents.TouchDown)
                button.addTarget(self, action: "didClickButton:", forControlEvents: UIControlEvents.TouchUpInside)
                self.viewKeyboard.addSubview(button)
            }
        }
        
        // x/cancel
        row = 3
        col = 0
        var frame = CGRectMake(CGFloat(col) * (width + padding) + leftOffset, CGFloat(row) * (width + padding), width, width)
        var button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = frame
        button.setImage(UIImage(named: "iconX"), forState: UIControlState.Normal)
        button.layer.cornerRadius = CGFloat(width/2)
        button.layer.borderWidth = border
        button.layer.borderColor = ColorUtil.blueColor().CGColor
        button.tag = -1
        button.addTarget(self, action: "didClickButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.viewKeyboard.addSubview(button)
        
        // 0
        col = 1
        frame = CGRectMake(CGFloat(col) * (width + padding) + leftOffset, CGFloat(row) * (width + padding), width, width)
        button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = frame
        button.setTitle("0", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button.titleLabel!.font = UIFont.systemFontOfSize(30)
        button.layer.cornerRadius = CGFloat(width/2)
        button.layer.borderWidth = border
        button.layer.borderColor = ColorUtil.blueColor().CGColor
        button.tag = 0
        button.addTarget(self, action: "didClickButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.viewKeyboard.addSubview(button)
        
        // check/confirm
        col = 2
        frame = CGRectMake(CGFloat(col) * (width + padding) + leftOffset, CGFloat(row) * (width + padding), width, width)
        button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.setImage(UIImage(named: "iconCheck"), forState: UIControlState.Normal)
        button.frame = frame
        button.layer.cornerRadius = CGFloat(width/2)
        button.layer.borderWidth = border
        button.layer.borderColor = ColorUtil.blueColor().CGColor
        button.tag = 10
        button.addTarget(self, action: "didClickButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.viewKeyboard.addSubview(button)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
