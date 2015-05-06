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
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
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
    var weekHeaderController:CalendarHeaderWeekViewController?
    var currentDayController:DayViewController?
    
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
            
            for i in 0...days-1 {
                let dayController = self.dayControllers.objectAtIndex(i) as! DayViewController
                if dayController.currentDate == BRDateUtils.beginningOfDate(NSDate(), GMT: false) {
                    let offset = CGPointMake(pagewidth * CGFloat(i), 0)
                    self.scrollview.setContentOffset(offset, animated: true)
                    break
                }
            }
            
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
            
            self.currentDayController = dayController
            
            if dayController.currentDate == BRDateUtils.beginningOfDate(NSDate(), GMT: false) {
                self.labelDate.text = "TODAY"
            }
            else {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MM/dd"
                self.labelDate.text = formatter.stringFromDate(dayController.currentDate!)
            }
            
            if index == 0 {
                self.buttonLeft.enabled = false
            }
            else if index == self.dayControllers.count - 1 {
                self.buttonRight.enabled = false
            }
            else {
                self.buttonLeft.enabled = true
                self.buttonRight.enabled = true
            }
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EmbedCalendarHeader" {
            let controller:CalendarHeaderWeekViewController = segue.destinationViewController as! CalendarHeaderWeekViewController
            controller.setDateInWeek(NSDate())
            controller.view.backgroundColor = UIColor.clearColor()
            self.weekHeaderController = controller
        }
    }
    
    // MARK: - Date navigator
    @IBAction func didClickNavigationButtons(button: UIButton!) {
        var offset: CGPoint;
        if button == self.buttonLeft {
            offset = CGPointMake(self.scrollview.contentOffset.x - pagewidth, self.scrollview.contentOffset.y)
        }
        else {
            offset = CGPointMake(self.scrollview.contentOffset.x + pagewidth, self.scrollview.contentOffset.y)
        }
        button.enabled = false // temporarily disable multiple clicks on it
        self.scrollview.setContentOffset(offset, animated: true)
    }
    
    // MARK: DayViewDelegate
    func didSelectActivityTile(controller: DayViewController, activity: Activity, canvas:UIView, frame: CGRect) {
        self.buttonLeft.enabled = false
        self.buttonRight.enabled = false

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

        var final:CGRect = CGRectMake(0, 0, self.view.frame.size.width-20, self.view.frame.size.height - (self.calendarView.frame.origin.y + self.calendarView.frame.size.height + 10))
        final.origin.x = (self.view.frame.size.width - final.size.width)/2
        final.origin.y = self.calendarView.frame.origin.y + self.calendarView.frame.size.height
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
            controller.delegate = self
            controller.activity = activity

            controller.view.frame = self.copyView!.frame
            self.view.addSubview(controller.view)
            controller.didMoveToParentViewController(self)
            
            controller.view.backgroundColor = self.copyView!.backgroundColor
            controller.view.layer.cornerRadius = self.copyView!.layer.cornerRadius
            controller.view.layer.borderWidth = self.copyView!.layer.borderWidth
            controller.view.layer.borderColor = self.copyView!.layer.borderColor
            
            self.currentActivityController = controller

            self.copyView!.alpha = 0
        }
        else {
            let tap = UITapGestureRecognizer(target: self, action: "closeActivityView")
            self.copyView!.addGestureRecognizer(tap)
        }
    }
    
    func closeActivityView() {
        self.maskingView.alpha = 1
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.copyView!.frame = self.copyFrame!
            }, completion: { (success) -> Void in
                self.copyView!.removeFromSuperview()
                
                self.buttonLeft.enabled = true
                self.buttonRight.enabled = true
        })
    }
    
    // MARK: WeightViewDelegate
    func didEnterWeight(weight: CGFloat) {
        println("new weight: \(weight)")
        if self.currentDayController != nil {
            self.currentDayController!.collectionView.reloadData()
        }
        self.didCloseEnterWeight()
    }
    
    func didCloseEnterWeight() {
        if self.currentActivityController != nil {
            self.copyView!.alpha = 1
            self.currentActivityController!.view.alpha = 0
            
            self.closeActivityView()
            self.currentActivityController!.view.removeFromSuperview()
            
            self.maskingView.alpha = 1
        }
    }
    
    // MARK: Activity data
    func loadActivities() {
        // for now, generate a random number of activities
        for index in 0...days-1 {
            let dayController = self.dayControllers[index] as! DayViewController
            dayController.loadActivities()
        }
    }
}

