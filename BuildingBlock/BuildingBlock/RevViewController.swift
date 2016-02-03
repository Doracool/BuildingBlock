//
//  RevViewController.swift
//  BuildingBlock
//
//  Created by qingyun on 16/2/1.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

import UIKit
import AVFoundation
class RevViewController: UIViewController ,RevGameViewDelegate{

    let margine:CGFloat = 10
    let buttonSize:CGFloat = 48
    let buttonAlpha:CGFloat = 0.9
    let toolBarHeight:CGFloat = 44
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    var RevGameView:RevgameView!
    var RevBgMusicPlayer:AVAudioPlayer!
    var stopBtn:UIButton!
    var RevspeedShow:UILabel!
    var RevscroeShow:UILabel!
    var btn:UIButton!
    var backBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let rect = UIScreen.mainScreen().bounds
        screenWidth = rect.size.width
        screenHeight = rect.size.height
        addButtons()
        addRevToolBar()
        let gameRcet = CGRectMake(rect.origin.x + margine + 4, rect.origin.y + toolBarHeight + 70, rect.size.width - margine * 2 - 9, rect.size.height - buttonSize * 2 - toolBarHeight - 80)
        
        RevGameView = RevgameView(frame: gameRcet)
        RevGameView.delegate = self
        self.view.addSubview(RevGameView)
        RevGameView.RevStartGame()
        
        
        backBtn = UIButton.init(type: UIButtonType.Custom)
        backBtn.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backBtn.setBackgroundImage(UIImage(named: "iconfont-fanhui"), forState: UIControlState.Normal)
        backBtn.setBackgroundImage(UIImage(named: "iconfont-fanhui"), forState: UIControlState.Highlighted)
        
        backBtn.frame.size = (backBtn.currentBackgroundImage?.size)!
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)

        
        btn = UIButton.init(type: UIButtonType.Custom)
        btn.addTarget(self, action: "stopMusic", forControlEvents: UIControlEvents.TouchUpInside)
        btn.setTitle("asd", forState: UIControlState.Normal)
        btn.titleLabel?.alpha = 0
        btn.setBackgroundImage(UIImage(named: "OpenMusic"), forState: UIControlState.Normal)
        btn.frame.size = (btn.currentBackgroundImage?.size)!
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        
        let RevBgMusicUrl = NSBundle.mainBundle().URLForResource("UNnormal", withExtension: "mp3")
        
        do
        {
            try RevBgMusicPlayer = AVAudioPlayer(contentsOfURL: RevBgMusicUrl!)
        }catch
        {
            
        }
        RevBgMusicPlayer.numberOfLoops = -1
        RevBgMusicPlayer.play()
    }

    func addRevToolBar()
    {
        let RevToolBar = UIToolbar(frame: CGRectMake(0, margine + 44 , screenWidth ,toolBarHeight))
        self.view.addSubview(RevToolBar)
        
        let RevSpeedLabel = UILabel()
        RevSpeedLabel.frame = CGRectMake(0, 0, 50, toolBarHeight)
        RevSpeedLabel.text = "速度:"
        let RevSpeedLabelItem = UIBarButtonItem(customView: RevSpeedLabel)
        
        RevspeedShow = UILabel()
        RevspeedShow.frame = CGRectMake(0, 0, 20, toolBarHeight)
        RevspeedShow.textColor = UIColor.redColor()
        let RevSpeedShowItem = UIBarButtonItem(customView: RevspeedShow)
        
        let RevScoreLabel = UILabel()
        RevScoreLabel.frame = CGRectMake(0, 0, 90, toolBarHeight)
        RevScoreLabel.text = "升级分数:"
        let RevScoreLabelItem = UIBarButtonItem(customView: RevScoreLabel)
        
        RevscroeShow = UILabel()
        RevscroeShow.frame = CGRectMake(0, 0, 40, toolBarHeight)
        RevscroeShow.textColor = UIColor.redColor()
        let RevScoreShowItem = UIBarButtonItem(customView: RevscroeShow)
        
        let RevFlexItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
         RevToolBar.items = [RevSpeedLabelItem,RevSpeedShowItem,RevFlexItem,RevScoreLabelItem,RevScoreShowItem]
        
    }
    
    //定义方向
    func addButtons()
    {
        //左
        let leftBtn = UIButton()
        leftBtn.frame = CGRectMake(screenWidth - buttonSize * 3 - margine - 14, screenHeight - buttonSize * 2 - margine, buttonSize * 1.2, buttonSize * 1.2)
        leftBtn.alpha = buttonAlpha
        leftBtn.setBackgroundImage(UIImage(named: "left"), forState: UIControlState.Normal)
        leftBtn.addTarget(self, action: "left:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(leftBtn)
        
        //上
        let upBtn = UIButton()
        upBtn.frame = CGRectMake(margine, screenHeight - buttonSize - margine * 3 + 5, buttonSize * 1.2, buttonSize * 1.2)
        upBtn.alpha = buttonAlpha
        upBtn.setBackgroundImage(UIImage(named: "xuanzhuan"), forState: UIControlState.Normal)
        upBtn.addTarget(self, action: "up:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(upBtn)
        
        //右
        let rightBtn = UIButton()
        rightBtn.frame = CGRectMake(screenWidth - buttonSize  - margine, screenHeight - buttonSize * 2 - margine, buttonSize * 1.2, buttonSize * 1.2)
        rightBtn.alpha = buttonAlpha
        rightBtn.setBackgroundImage(UIImage(named: "right"), forState: UIControlState.Normal)
        rightBtn.addTarget(self, action: "right:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(rightBtn)
        
        //下
        let downBtn = UIButton()
        downBtn.frame = CGRectMake(screenWidth - buttonSize * 2 - margine - 7, screenHeight - buttonSize - margine , buttonSize * 1.2, buttonSize * 1.2)
        downBtn.alpha = buttonAlpha
        downBtn.setBackgroundImage(UIImage(named: "down"), forState: UIControlState.Normal)
        downBtn.addTarget(self, action: "down:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(downBtn)
        
        stopBtn = UIButton.init(type: UIButtonType.Custom)
        stopBtn.frame = CGRectMake(margine * 2 + buttonSize * 2, screenHeight - buttonSize - margine * 2, buttonSize, buttonSize)
        stopBtn.alpha = buttonAlpha
        stopBtn.setTitle("暂停", forState: UIControlState.Normal)
        stopBtn.addTarget(self, action: "stop:", forControlEvents: UIControlEvents.TouchUpInside)
        stopBtn.titleLabel?.textColor = UIColor.clearColor()
        stopBtn.titleLabel?.alpha = 0
        stopBtn.setBackgroundImage(UIImage(named: "stop"), forState: UIControlState.Normal)
        self.view.addSubview(stopBtn)
        
    }
    
    func left(sender:UIButton)
    {
                print("zuo")
       RevGameView.moveLeft()
    }
    func up(sender:UIButton){
                print("up")
       RevGameView.rotate()
    }
    func right(sender:UIButton){
                print("right")
        RevGameView.moveRight()
    }
    func down(sender:UIButton){
                print("down")
        RevGameView.moveUP()
    }
    func stopMusic()
    {
        if btn.titleLabel?.text == "asd"
        {
            RevBgMusicPlayer.pause()
            btn.setImage(UIImage(named: "StopMucic"), forState: UIControlState.Normal)
            btn.setTitle("dsa", forState: UIControlState.Normal)
        }else
        {
            RevBgMusicPlayer.play()
            btn.setImage(UIImage(named: "OpenMusic"), forState: UIControlState.Normal)
            btn.setTitle("asd", forState: UIControlState.Normal)
        }
    }
    
    func stop(sender:UIButton){
        if stopBtn.titleLabel?.text == "暂停"
        {
            stopBtn.setBackgroundImage(UIImage(named: "down"), forState: UIControlState.Normal)
            stopBtn.setTitle("继续", forState: UIControlState.Normal)
            stopBtn.setImage(UIImage(named: "countin"), forState: UIControlState.Normal)
            RevBgMusicPlayer.pause()
            RevGameView.RevGameStop()
        }else
        {
            stopBtn.setBackgroundImage(UIImage(named: "iconfont-fanhui"), forState: UIControlState.Normal)
            stopBtn.setTitle("暂停", forState: UIControlState.Normal)
            stopBtn.setImage(UIImage(named: "stop"), forState: UIControlState.Normal)
            RevBgMusicPlayer.play()
            RevGameView.RevGameStop()
        }

    }
    
    func updataScore(score: Int) {
        self.title = "分数:\(score)"
    }

    func updataSpeed(speed: Int) {
        let string = speed * speed * 200
        self.RevscroeShow.text = "\(string)"

        self.RevspeedShow.text = "\(speed)"
    }
    
    func back()
    {
        RevBgMusicPlayer.pause()
        RevGameView.RevGameStop()
        self.navigationController!.popToRootViewControllerAnimated(true)
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
