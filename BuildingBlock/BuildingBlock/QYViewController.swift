//
//  QYViewController.swift
//  BuildingBlock
//
//  Created by qingyun on 16/2/2.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

import UIKit

class QYViewController: UINavigationController {

    
    var backBtn = UIButton!()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0
        {

            backBtn = UIButton.init(type: UIButtonType.Custom)
            backBtn.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
            backBtn.setBackgroundImage(UIImage(named: "iconfont-fanhui"), forState: UIControlState.Normal)
            backBtn.setBackgroundImage(UIImage(named: "iconfont-fanhui"), forState: UIControlState.Highlighted)
            
            backBtn.frame.size = (backBtn.currentBackgroundImage?.size)!
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        }
//        [super.pushViewController(viewContriller, animated: animated)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
