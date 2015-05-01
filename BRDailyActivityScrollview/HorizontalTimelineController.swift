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
    let today = BRDateUtils.beginningOfDate(NSDate(), GMT: false)
    
    var pagewidth: CGFloat!
    var width: CGFloat!
    var height: CGFloat!
    
    var days: Int!
    
    var dayControllers:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dayControllers = NSMutableArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        width = self.scrollview.frame.size.width - 2 * BORDER
        height = self.scrollview.frame.size.height - 2 * BORDER
        pagewidth = self.scrollview.frame.size.width
        days = Int(arc4random_uniform(5) + 3)
        self.populateDays()
        
        let offset = CGPointMake(pagewidth * CGFloat(days-1), 0)
        self.scrollview.setContentOffset(offset, animated: true)
        
        self.loadActivities()
    }
    
    func populateDays() {
        for index in 0...days-1 {
            let i = CGFloat(index)
            var frame = self.scrollview.frame as CGRect
            frame.origin.x = i * pagewidth + BORDER
            frame.origin.y = 0 // BORDER
            frame.size.width -= 2 * BORDER
            frame.size.height -= 2 * BORDER
            
            let dayController = storyboard!.instantiateViewControllerWithIdentifier("DayViewController") as! DayViewController
            // set date for each dayController
            dayController.currentDate = today.dateByAddingTimeInterval(NSTimeInterval(i * 24 * 3600))

            self.addChildViewController(dayController)
            dayController.view.frame = frame
            
            self.scrollview.addSubview(dayController.view)
            dayController.didMoveToParentViewController(self)
            
            self.dayControllers.addObject(dayController)
        }
        self.scrollview.contentSize = CGSizeMake(CGFloat(days)*pagewidth, height)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.updateCurrentDate()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.updateCurrentDate()
    }
    
    func updateCurrentDate() {
        let center = self.scrollview.contentOffset.x + self.scrollview.frame.size.width/2
        let index = Int(center / pagewidth)
        
        println("scrolled to day \(index)")
        if index >= 0 && index < self.dayControllers.count {
            let dayController = self.dayControllers.objectAtIndex(index) as! DayViewController
            self.labelDate.text = BRDateUtils.yearMonthDayForDate(dayController.currentDate!)
        }
    }
    
    // MARK: Activity data
    func loadActivities() {
        // for now, generate a random number of activities
        let labels = ["Check your weight", "Examine your feet", "Check your glucose", "Take meds", "Eat healthy", "Go exercise", "Get a flu shot"]
        for index in 0...days-1 {
            let dayController = self.dayControllers[index] as! DayViewController
            let activityCt = arc4random_uniform(6) + 2
            var activitiesArray = [AnyObject]()
            
            activitiesArray.append(self.sponsoredActivity())
            for i in 0...activityCt-1 {
                let textIndex = Int(arc4random_uniform(UInt32(labels.count)))
                let text = labels[textIndex] as String
                var type: ActivityType
                if text == "Check your weight" || text == "Take meds" {
                    type = ActivityType.Tall
                }
                else {
                    type = ActivityType.Single
                }
                let activity = Activity(type: type, icon: nil, text: text)
                activitiesArray.append(activity)
            }
            activitiesArray.append(self.challengeActivity())
            dayController.updateWithActivities(activitiesArray as [AnyObject])
        }
    }
    
    func sponsoredActivity() -> Activity {
        // generate the sponsored CVS activity
        let params: NSDictionary = ["type": ActivityTypeWide, "text": "CVS"]
        let activity = Activity(params: params)
        return activity
    }
    
    func challengeActivity() -> Activity {
        // generate the sponsored challenge activity
        let params: NSDictionary = ["type": ActivityTypeWide, "text": "Whole foods challenge"]
        let activity = Activity(params: params)
        return activity
    }
}

