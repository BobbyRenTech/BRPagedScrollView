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

    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = self.randomColor()

        /*
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let width = appDelegate.window!.frame.size.width
        let height = appDelegate.window!.frame.size.height
        
        self.constraintContentWidth.constant = width;
        self.constraintContentHeight.constant = height;

        self.contentView.setNeedsUpdateConstraints()
        self.contentView.layoutIfNeeded()
*/
//        println("initial scroll: \(scrollView.frame.origin.x) \(scrollView.frame.origin.y) \(scrollView.frame.size.width) \(scrollView.frame.size.height)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        println("view: \(self.view.frame.origin.x) \(self.view.frame.origin.y) \(self.view.frame.size.width) \(self.view.frame.size.height)")
        /*
        println("appeared scroll: \(scrollView.frame.origin.x) \(scrollView.frame.origin.y) \(scrollView.frame.size.width) \(scrollView.frame.size.height)")
        println("content: \(contentView.frame.origin.x) \(contentView.frame.origin.y) \(contentView.frame.size.width) \(contentView.frame.size.height)")
        println("cell: \(labelText.frame.origin.x) \(labelText.frame.origin.y) \(labelText.frame.size.width) \(labelText.frame.size.height)")
*/
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
