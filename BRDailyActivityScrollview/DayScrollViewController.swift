//
//  DayScrollViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class DayScrollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RFQuiltLayoutDelegate {
    let reuseIdentifier = "ActivityCell"

    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!

    @IBOutlet weak var collectionView: UICollectionView!

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
  
        let layout = self.collectionView.collectionViewLayout as! RFQuiltLayout
        layout.direction = UICollectionViewScrollDirection.Vertical
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.updateContentSize()

        let layout = self.collectionView.collectionViewLayout as! RFQuiltLayout
        let width = self.view.frame.size.width - 20
        layout.blockPixels = CGSizeMake(width/2.0, width/2.0)
    }
    
    func updateContentSize() {
        self.constraintContentWidth.constant = self.view.frame.size.width;
        self.constraintContentHeight.constant = self.view.frame.size.height;//self.labelText.frame.origin.y + self.labelText.frame.size.height + 20;
//        self.contentView.needsUpdateConstraints()
//        self.contentView.layoutIfNeeded()
    }

    func randomColor() -> UIColor {
//        return UIColor.blackColor()
        let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.brownColor()] as Array
        let index = arc4random_uniform(UInt32(colors.count))
        return colors[Int(index)]
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        // Configure the cell
        cell.contentView.backgroundColor = self.randomColor()
        
        return cell
    }
    
    // MARK: - RFQuiltLayout
    func blockSizeForItemAtIndexPath(indexPath: NSIndexPath!) -> CGSize {
        return CGSizeMake(1, 1);
    }
    
    func insetsForItemAtIndexPath(indexPath: NSIndexPath!) -> UIEdgeInsets {
        let border = 5 as CGFloat
        return UIEdgeInsetsMake(border, border, border, border);
    }
  
}
