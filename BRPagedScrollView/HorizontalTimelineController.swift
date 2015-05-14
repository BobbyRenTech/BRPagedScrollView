//
//  HorizontalTimelineController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 4/27/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class HorizontalTimelineController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var maskingView : UIView!
    @IBOutlet weak var scrollview : UIScrollView!
    
    @IBOutlet weak var constraintContentWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var labelDate: UILabel!
    
    var pagewidth: CGFloat!
    var width: CGFloat!
    var height: CGFloat!
    
    let page:Int = 0
    var pages: Int!
    
    var pageControllers:NSMutableArray! = NSMutableArray()
    var currentPageController:VerticalPageViewController?
    
    var isSetup:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if !isSetup {
            self.setGradient() 
            
            width = self.scrollview.frame.size.width - 2 * BORDER
            height = self.scrollview.frame.size.height - 2 * BORDER
            pagewidth = self.scrollview.frame.size.width
            
            // generates the day controllers
            pages = 7 // display one week
            self.populateDays()
            self.updatePageLabel()
            
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
        for index in 0...pages-1 {
            let i = CGFloat(index)
            var frame = self.scrollview.frame as CGRect
            let offset:CGFloat = 1 // on iPhone 6+, if this offset is 0, the very first page is very weird
            frame.origin.x = i * pagewidth + offset
            frame.origin.y = offset
            frame.size.width -= BORDER // gives right border 10 pixels for each cell because right cell inset is 0
            
            let controller = storyboard!.instantiateViewControllerWithIdentifier("VerticalPageViewController") as! VerticalPageViewController

            // set date for each dayController
            controller.page = index

            self.addChildViewController(controller)
            controller.view.frame = frame
            
            self.scrollview.addSubview(controller.view)
            controller.didMoveToParentViewController(self)

            controller.view.backgroundColor = self.randomColor()
            
            self.pageControllers.addObject(controller)
        }
        self.scrollview.contentSize = CGSizeMake(CGFloat(pages)*pagewidth, height)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.updatePageLabel()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.updatePageLabel()
    }
    
    func updatePageLabel() {
        let center = self.scrollview.contentOffset.x + self.scrollview.frame.size.width/2
        let index = Int(center / pagewidth)
        
        println("scrolled to page \(index)")
        if index >= 0 && index < self.pageControllers.count {
            let controller = self.pageControllers.objectAtIndex(index) as! VerticalPageViewController
            self.currentPageController = controller
            
            self.labelDate.text = "Page \(index+1)"

            if index == 0 {
                self.buttonLeft.enabled = false
            }
            else if index == self.pageControllers.count - 1 {
                self.buttonRight.enabled = false
            }
            else {
                self.buttonLeft.enabled = true
                self.buttonRight.enabled = true
            }
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
    
    func randomColor() -> UIColor {
        let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.brownColor()] as Array
        let index = arc4random_uniform(UInt32(colors.count))
        return colors[Int(index)]
    }

}

