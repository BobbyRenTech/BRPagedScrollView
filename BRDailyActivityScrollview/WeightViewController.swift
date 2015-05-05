//
//  WeightViewController.swift
//  BRDailyActivityScrollview
//
//  Created by Bobby Ren on 5/4/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

protocol WeightViewDelegate {
    func didEnterWeight(weight:CGFloat)
    func didCloseEnterWeight()
}


class WeightViewController: UIViewController, WeightInputDelegate {
    
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var viewContent: UIView!

    var activity: Activity?

    weak var inputController: WeightInputViewController?

    var delegate: WeightViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewContent.layer.borderColor = ColorUtil.blueColor().CGColor
        self.viewContent.layer.borderWidth = 1
        self.viewContent.layer.backgroundColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.inputController!.setupButtons()
    }
    
    @IBAction func done() {
        if self.delegate != nil {
            self.delegate!.didCloseEnterWeight()
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EmbedWeightInput" {
            let controller = segue.destinationViewController as! WeightInputViewController
            controller.delegate = self
            self.inputController = controller
            if self.activity!.weight != nil {
                self.inputController!.weight = Int(self.activity!.weight!)
            }
        }
    }

    // MARK: - WeightInputDelegate
    func didSetWeight(newWeight: CGFloat) {
        self.activity!.didCompleteWeight(newWeight)
        self.delegate!.didEnterWeight(self.activity!.weight!)
    }
}
