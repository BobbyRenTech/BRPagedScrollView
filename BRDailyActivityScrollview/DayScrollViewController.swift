//
//  DayScrollViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class DayScrollViewController: UIViewController {
    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    var currentCount: Int?
    
    var currentDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = self.randomColor()
        
        let appDelegate = UIApplication.sharedApplication().delegate!
        
        // default date is today
        if currentDate == nil {
            currentDate = NSDate()
        }
        if currentCount == nil {
            currentCount = -1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.scrollView.frame.size.width = self.view.frame.size.width;
        self.scrollView.frame.size.height = self.view.frame.size.height;
        
        self.updateContentSize()

        println("view: \(self.view.frame.origin.x) \(self.view.frame.origin.y) \(self.view.frame.size.width) \(self.view.frame.size.height)")
        println("scrollview: \(self.scrollView.frame.origin.x) \(self.scrollView.frame.origin.y) \(self.scrollView.frame.size.width) \(self.scrollView.frame.size.height)")
        println("contentview: \(self.contentView.frame.origin.x) \(self.contentView.frame.origin.y) \(self.contentView.frame.size.width) \(self.contentView.frame.size.height)")
        println("text: \(self.labelText.frame.origin.x) \(self.labelText.frame.origin.y) \(self.labelText.frame.size.width) \(self.labelText.frame.size.height)")
        
//        if currentCount != nil {
            labelCount.text = "\(currentCount!)"
//        }
    }
    
    func updateContentSize() {
        self.constraintContentWidth.constant = self.view.frame.size.width;
        self.constraintContentHeight.constant = self.labelText.frame.origin.y + self.labelText.frame.size.height + 20;
        self.contentView.needsUpdateConstraints()
        self.contentView.layoutIfNeeded()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func randomColor() -> UIColor {
//        return UIColor.blackColor()
        let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.brownColor()] as Array
        let index = arc4random_uniform(UInt32(colors.count))
        return colors[Int(index)]
    }
}
