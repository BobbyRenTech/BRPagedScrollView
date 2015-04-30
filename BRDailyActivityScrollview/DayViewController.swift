//
//  DayViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RFQuiltLayoutDelegate {
    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!

    @IBOutlet weak var collectionView: UICollectionView!

    var currentDate: NSDate?
    var activities: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let appDelegate = UIApplication.sharedApplication().delegate!
        
        // default date is today
        if currentDate == nil {
            currentDate = NSDate()
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
        let width = self.view.frame.size.width - 20
        layout.blockPixels = CGSizeMake(width/2.0, width/2.0)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        // Configure the cell
        cell.contentView.backgroundColor = self.randomColor()
        
        return cell
    }
    
    // MARK: - RFQuiltLayoutDelegate
    func blockSizeForItemAtIndexPath(indexPath: NSIndexPath!) -> CGSize {
        return CGSizeMake(1, 1);
    }
    
    func insetsForItemAtIndexPath(indexPath: NSIndexPath!) -> UIEdgeInsets {
        let border = 5 as CGFloat
        return UIEdgeInsetsMake(border, border, border, border);
    }
  
    // MARK: - Utils
    func randomColor() -> UIColor {
        let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.brownColor()] as Array
        let index = arc4random_uniform(UInt32(colors.count))
        return colors[Int(index)]
    }
}
