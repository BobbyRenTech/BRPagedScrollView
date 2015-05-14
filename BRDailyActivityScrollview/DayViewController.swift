//
//  DayViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

let BORDER:CGFloat = 10

class DayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RFQuiltLayoutDelegate, ActivityCellDelegate, WeightViewDelegate {
    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!

    @IBOutlet weak var collectionView: UICollectionView!

    var currentDate: NSDate?
    var activities: NSMutableArray!
    
    var currentActivityController: UIViewController?
    var copyView: UIView?
    var bgView: UIView?
    var copyFrame: CGRect?
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clearColor()
        
        // default date is today
        if currentDate == nil {
            currentDate = BRDateUtils.beginningOfDate(NSDate(), GMT: false)
        }
        
        activities = NSMutableArray()
  
        let layout = self.collectionView.collectionViewLayout as! RFQuiltLayout
        layout.direction = UICollectionViewScrollDirection.Vertical
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let layout = self.collectionView.collectionViewLayout as! RFQuiltLayout
        let GOLDEN_RATIO = 1.618 as CGFloat
        let width = CGFloat((self.view.frame.size.width)/2.0)
        let height = width / GOLDEN_RATIO
        layout.blockPixels = CGSizeMake(width, height)
        
        // because we want dayViewController to fade, the top part of the scrollable area needs to be blank.
        self.collectionView.contentInset = UIEdgeInsetsMake(60, 0, 60, 0)
    }
    
    // MARK: Populating data
    func updateWithActivities(newActivities: [AnyObject]?) {
        if newActivities == nil || newActivities!.count == 0 {
            self.activities.removeAllObjects()
        }
        else {
            self.activities.addObjectsFromArray(newActivities!)
        }
        self.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: ActivityCell;
        let activity = self.activities.objectAtIndex(indexPath.row) as! Activity
        if activity.isTall() {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellTall", forIndexPath: indexPath) as! ActivityCell
        }
        else if activity.isWide() {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellWide", forIndexPath: indexPath) as! ActivityCell
        }
        else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellSingle", forIndexPath: indexPath) as! ActivityCell
        }
        
        cell.delegate = self
        cell.setupWithActivity(activity)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate 
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: ActivityCell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! ActivityCell
        // not used: cell selection has been replaced with gesture handling
        self.didSelectActivityTile(cell)
    }
    
    // MARK: - RFQuiltLayoutDelegate
    func blockSizeForItemAtIndexPath(indexPath: NSIndexPath!) -> CGSize {
        let activity = self.activities.objectAtIndex(indexPath.row) as! Activity
        if activity.isTall() {
            return CGSizeMake(1, 2)
        }
        else if activity.isWide() {
            return CGSizeMake(2, 1)
        }
        else if activity.isHuge() {
            return CGSizeMake(2, 2)
        }
        else {
            return CGSizeMake(1, 1)
        }
    }
    
    func insetsForItemAtIndexPath(indexPath: NSIndexPath!) -> UIEdgeInsets {
        let top:CGFloat = 0
        let left:CGFloat = BORDER
        let bottom:CGFloat = 0 //BORDER
        let right:CGFloat = 0
        return UIEdgeInsetsMake(top, left, bottom, right);
    }
    
    func maxCellWidth() -> CGFloat {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCellWide", forIndexPath: indexPath) as! ActivityCell
        return cell.frame.size.width
    }
    
    // MARK: fake activities
    func loadActivities() {
        var activitiesArray = [AnyObject]()
        
        activitiesArray.append(self.sponsoredActivity())
        activitiesArray.append(Activity(params: ["type":ActivityType.Weight, "date":self.currentDate, "completed":false, "icons":["rewards", "kudos"]]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Glucose, "date":self.currentDate, "completed":false, "icons":["reminders", "messages"]]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Feet, "date":self.currentDate, "completed":true, "icons":["rewards"]]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Feel, "date":self.currentDate, "completed":false, "icons":["lock"]]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Medicine, "date":self.currentDate, "completed":false, "icons":["status"]]))
        activitiesArray.append(Activity(params: ["type":ActivityType.Hunger, "date":self.currentDate, "completed":false, "icons":["lock"]]))
        activitiesArray.append(self.challengeActivity())
        self.updateWithActivities(activitiesArray as [AnyObject])
    }
    
    func sponsoredActivity() -> Activity {
        // generate the sponsored CVS activity
        let params: Dictionary<String, Any> = ["type": ActivityType.Sponsored, "date":self.currentDate,]
        let activity = Activity(params: params)
        return activity
    }
    
    func challengeActivity() -> Activity {
        // generate the sponsored challenge activity
        let params: Dictionary<String, Any> = ["type": ActivityType.Challenge, "date":self.currentDate]
        let activity = Activity(params: params)
        return activity
    }
    
    // MARK: Activity selection
    func didSelectActivityTile(cell:ActivityCell) {
        let canvas = cell.viewBorder
        var frame = collectionView.convertRect(cell.frame, toView: self.view)
        frame.origin.y += 20
        frame.size.height -= 20 // hack: convert cell.viewBorder.frame instead of cell
        let activity:Activity = cell.activity!
        
        let baseView = appDelegate.window!.rootViewController!.view as UIView
        let frameInView = self.view.convertRect(frame, toView: baseView)
        println("Activity: \(activity.text) frame: \(frameInView.origin.x) \(frameInView.origin.y)")
        
        self.bgView = UIView(frame: baseView.frame) as UIView
        self.bgView!.alpha = 0.0
        self.bgView!.backgroundColor = UIColor.blackColor()
        baseView.addSubview(bgView!)
        
        // create a copy of the view
        self.copyView = UIView(frame: frameInView)
        self.copyView!.backgroundColor = canvas.backgroundColor
        self.copyView!.layer.cornerRadius = canvas.layer.cornerRadius
        self.copyView!.layer.borderWidth = canvas.layer.borderWidth
        self.copyView!.layer.borderColor = canvas.layer.borderColor
        baseView.addSubview(self.copyView!)
        self.copyFrame = frameInView
        
        var final:CGRect = CGRectMake(0, 0, baseView.frame.size.width - 20, baseView.frame.size.height - 30)
        final.origin.x = (baseView.frame.size.width - final.size.width)/2
        final.origin.y = 20
        
        let damping:CGFloat = 0.6
        let velocity:CGFloat = 1.1
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 7.0 {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.bgView!.alpha = 0.5
                self.copyView!.frame = final
                self.copyView!.backgroundColor = UIColor.whiteColor()
                }) { (success) -> Void in
                    println("done")
                    self.displayActivityDetails(activity)
            }
        }
        else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.bgView!.alpha = 0.5
                self.copyView!.frame = final
                self.copyView!.backgroundColor = UIColor.whiteColor()
                }) { (success) -> Void in
                    println("done")
                    self.displayActivityDetails(activity)
            }
        }
    }
    
    func displayActivityDetails(activity:Activity) {
        let baseView = appDelegate.window!.rootViewController!.view as UIView
        if activity.type == ActivityType.Weight {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("WeightViewController") as! WeightViewController
            appDelegate.window!.rootViewController!.addChildViewController(controller)
            controller.delegate = self
            controller.activity = activity
            
            controller.view.frame = self.copyView!.frame
            baseView.addSubview(controller.view)
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
        if self.bgView != nil {
            self.bgView!.removeFromSuperview()
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.copyView!.frame = self.copyFrame!
            }, completion: { (success) -> Void in
                self.copyView!.removeFromSuperview()
        })
    }

    // MARK: - Activity delegates
    
    // MARK: WeightViewDelegate
    func didCompleteActivity(activity: Activity!) {
        self.collectionView.reloadData()
        if self.currentActivityController != nil {
            self.copyView!.alpha = 1
            self.currentActivityController!.view.alpha = 0
            
            self.closeActivityView()
            self.currentActivityController!.view.removeFromSuperview()
        }
        let userInfo: [String:[Activity]] = ["activity":[activity]]
        self.notify("activities:updated:forDate", object: self.currentDate, userInfo: userInfo)
    }
}
