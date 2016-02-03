//
//  BeginVC.swift
//  BuildingBlock
//
//  Created by qingyun on 16/2/1.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

import UIKit

class BeginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "模式选择"
        _ = UIImageView!()
        
        addBGView()
        addViewInSubView()
    }

    func addBGView()
    {
        let imgView = UIImageView()
        imgView.frame = self.view.frame
        imgView.image = UIImage(named: "view")
        self.view.addSubview(imgView)
    }
    
    func addViewInSubView()
    {
        let normalBtn = UIButton()
        normalBtn.frame = CGRectMake(100, 100, 100, 100)
        normalBtn.setTitle("正常", forState: UIControlState.Normal)
        normalBtn.addTarget(self, action: "normalChoose", forControlEvents: UIControlEvents.TouchUpInside)
        normalBtn.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
        normalBtn.layer.borderWidth = 2
        normalBtn.layer.cornerRadius = 10
        normalBtn.layer.masksToBounds = true
        normalBtn.layer.backgroundColor = UIColor.redColor().CGColor
        
        self.view.addSubview(normalBtn)
        
        let unNormalBtn = UIButton()
        unNormalBtn.frame = CGRectMake(100, 300, 100, 100)
        unNormalBtn.setTitle("镜像", forState: UIControlState.Normal)
        unNormalBtn.addTarget(self, action: "unNormalChoose", forControlEvents: UIControlEvents.TouchUpInside)
        unNormalBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.view.addSubview(unNormalBtn)
    }
    
    
    func normalChoose()
    {
        let normal = ViewController()
        self.navigationController!.pushViewController(normal, animated: true)
    }
    
    func unNormalChoose()
    {
        let unNormal = RevViewController()
        self.navigationController!.pushViewController(unNormal, animated: true)
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
