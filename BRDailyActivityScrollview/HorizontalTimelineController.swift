//
//  HorizontalTimelineController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class HorizontalTimelineController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollview : UIScrollView!
//    @IBOutlet weak var contentView : UIView!
    
    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var labelDate: UILabel!
    
    let BORDER:CGFloat = 5.0
    
    var appDelegate: AppDelegate!
    var pagewidth: CGFloat!
    var width: CGFloat!
    var height: CGFloat!
    
    var days: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        width = self.scrollview.frame.size.width - 2 * BORDER
        height = self.scrollview.frame.size.height - 2 * BORDER
        pagewidth = self.scrollview.frame.size.width
        days = 10 // arc4random_uniform(5) + 3
        self.populateDays()
        
        let offset = CGPointMake(pagewidth * CGFloat(days-1), 0)
        self.scrollview.setContentOffset(offset, animated: true)
    }

    func populateDays() {
        let today = NSDate()
        for index in 0...days-1 {
            let i = CGFloat(index)
            var frame = self.scrollview.frame as CGRect
            frame.origin.x = i * pagewidth + BORDER
            frame.origin.y = 0 // BORDER
            frame.size.width -= 2 * BORDER
            frame.size.height -= 2 * BORDER
            
            let dayController = storyboard!.instantiateViewControllerWithIdentifier("DayScrollViewController") as! DayScrollViewController
            // set date for each dayController
            dayController.currentDate = today.dateByAddingTimeInterval(NSTimeInterval(i * 24 * 3600))
            dayController.currentCount = index

            self.addChildViewController(dayController)
            dayController.view.frame = frame
            
            self.scrollview.addSubview(dayController.view)
            dayController.didMoveToParentViewController(self)
        }
        
        self.scrollview.contentSize = CGSizeMake(CGFloat(days)*pagewidth, height)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let center = scrollView.contentOffset.x + scrollView.frame.size.width/2
        let index = Int(center / pagewidth)
     
        println("scrolled to day \(index)")
    }
}

