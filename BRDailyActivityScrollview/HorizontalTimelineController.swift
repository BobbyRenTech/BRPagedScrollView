//
//  HorizontalTimelineController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class HorizontalTimelineController: UIViewController, UIScrollViewDelegate, DayViewDelegate, WeightViewDelegate {

    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var maskingView : UIView!
    @IBOutlet weak var scrollview : UIScrollView!
    
    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var labelDate: UILabel!
    
    var currentActivityController: UIViewController?
    var copyView: UIView?
    var copyFrame: CGRect?
    
    let today = BRDateUtils.beginningOfDate(NSDate(), GMT: false)!
    
    var pagewidth: CGFloat!
    var width: CGFloat!
    var height: CGFloat!
    
    var days: Int!
    
    var dayControllers:NSMutableArray!
    var weekHeaderController:WeekHeaderViewController?
    
    var isSetup:Bool = false
    
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
        if !isSetup {
            self.setGradient() // todo: maybe gradient should be set in dayViewController. but dayViewController doesn't know about WeekHeader's height.
            
            width = self.scrollview.frame.size.width - 2 * BORDER
            height = self.scrollview.frame.size.height - 2 * BORDER
            pagewidth = self.scrollview.frame.size.width
            days = 7 // display one week
            self.populateDays()
            
            let offset = CGPointMake(pagewidth * CGFloat(days-1), 0)
            self.scrollview.setContentOffset(offset, animated: true)
            
            self.loadActivities()
            isSetup = true
        }
    }
    
    func setGradient() {
        let l:CAGradientLayer = CAGradientLayer()
        var frame = self.maskingView.bounds
        frame.origin.y = 0
        l.frame = frame
        l.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
        l.startPoint = CGPointMake(0.5, 0)
        l.endPoint = CGPointMake(0.5, 0.1)
        self.maskingView.layer.mask = l
    }
    
    func populateDays() {
        let weekStart = BRDateUtils.sundayOfWeekForDate(NSDate()).dateByAddingTimeInterval(-7*24*3600)
        for index in 0...days-1 {
            let i = CGFloat(index)
            var frame = self.scrollview.frame as CGRect
            let offset:CGFloat = 1 // on iPhone 6+, if this offset is 0, the very first dayController is very weird
            frame.origin.x = i * pagewidth + offset
            frame.origin.y = offset
            frame.size.width -= BORDER // gives right border 10 pixels for each cell because right cell inset is 0
            
            let dayController = storyboard!.instantiateViewControllerWithIdentifier("DayViewController") as! DayViewController
            // set date for each dayController
            dayController.currentDate = weekStart.dateByAddingTimeInterval(NSTimeInterval(i * 24 * 3600))

            self.addChildViewController(dayController)
            dayController.view.frame = frame
            dayController.delegate = self
            
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
            if self.weekHeaderController != nil {
                self.weekHeaderController!.setCurrentDayOfWeek(dayController.currentDate!)
            }
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EmbedWeekHeader" {
            let controller:WeekHeaderViewController = segue.destinationViewController as! WeekHeaderViewController
            controller.setDateInWeek(NSDate())
            controller.view.backgroundColor = UIColor.clearColor()
            self.weekHeaderController = controller
        }
    }
    
    // MARK: DayViewDelegate
    func didSelectActivityTile(controller: DayViewController, activity: Activity, canvas:UIView, frame: CGRect) {
        let frameInView = controller.view.convertRect(frame, toView: self.view)
        println("Activity: \(activity.text) frame: \(frameInView.origin.x) \(frameInView.origin.y)")
        
        // create a copy of the view
        self.copyView = UIView(frame: frameInView)
        self.copyView!.backgroundColor = canvas.backgroundColor
        self.copyView!.layer.cornerRadius = canvas.layer.cornerRadius
        self.copyView!.layer.borderWidth = canvas.layer.borderWidth
        self.copyView!.layer.borderColor = canvas.layer.borderColor
        self.view.addSubview(self.copyView!)
        self.copyFrame = frameInView

        var final:CGRect = CGRectMake(0, 0, self.view.frame.size.width-20, self.maskingView.frame.size.height + 5)
        final.origin.x = (self.view.frame.size.width - final.size.width)/2
        final.origin.y = self.calendarView.frame.origin.y
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.copyView!.frame = final
            self.maskingView.alpha = 0
        }) { (success) -> Void in
            println("done")
            self.displayActivityDetails(activity)
        }
    }
    
    func displayActivityDetails(activity:Activity) {
        if activity.type == ActivityType.Weight {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("WeightViewController") as! WeightViewController
            self.addChildViewController(controller)
            controller.view.frame = self.copyView!.frame
            self.view.addSubview(controller.view)
            controller.didMoveToParentViewController(self)
            
            controller.delegate = self

            controller.view.backgroundColor = self.copyView!.backgroundColor
            controller.view.layer.cornerRadius = self.copyView!.layer.cornerRadius
            controller.view.layer.borderWidth = self.copyView!.layer.borderWidth
            controller.view.layer.borderColor = self.copyView!.layer.borderColor
            
            self.currentActivityController = controller

            self.copyView!.alpha = 0
        }
    }
    
    // MARK: WeightViewDelegate
    func didEnterWeight(weight: CGFloat) {
        println("new weight: \(weight)")
        self.didCloseEnterWeight()
    }
    
    func didCloseEnterWeight() {
        if self.currentActivityController != nil {
            self.copyView!.alpha = 1
            self.currentActivityController!.view.alpha = 0
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.copyView!.frame = self.copyFrame!
            }, completion: { (success) -> Void in
                self.currentActivityController!.view.removeFromSuperview()
                self.copyView!.removeFromSuperview()
            })
            
            self.maskingView.alpha = 1
        }
    }
    
    // MARK: Activity data
    func loadActivities() {
        // for now, generate a random number of activities
        for index in 0...days-1 {
            let dayController = self.dayControllers[index] as! DayViewController
            let activityCt = 6//arc4random_uniform(6) + 2
            var activitiesArray = [AnyObject]()
            
            activitiesArray.append(self.sponsoredActivity())
            activitiesArray.append(Activity(params: ["type":ActivityType.Weight, "complete":false]))
            activitiesArray.append(Activity(params: ["type":ActivityType.Glucose, "complete":false]))
            activitiesArray.append(Activity(params: ["type":ActivityType.Feet, "complete":false]))
            activitiesArray.append(self.challengeActivity())
            dayController.updateWithActivities(activitiesArray as [AnyObject])
        }
    }
    
    func sponsoredActivity() -> Activity {
        // generate the sponsored CVS activity
        let params: Dictionary<String, Any> = ["type": ActivityType.Sponsored]
        let activity = Activity(params: params)
        return activity
    }
    
    func challengeActivity() -> Activity {
        // generate the sponsored challenge activity
        let params: Dictionary<String, Any> = ["type": ActivityType.Challenge]
        let activity = Activity(params: params)
        return activity
    }
}

