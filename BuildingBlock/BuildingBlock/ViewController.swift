//
//  ViewController.swift
//  BuildingBlock
//
//  Created by qingyun on 16/1/27.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController ,GameViewDelegate {
    // let 定义常量 var定义变量
    //定义边距
    let MARGINE:CGFloat = 10
    //按钮的大小
    let BUTTON_SIZE:CGFloat = 48
    //按钮的透明度
    let BUTTON_ALPHA:CGFloat = 0.4
    //tabbar的高度
    let TOOLBAR_HEIGHT:CGFloat = 44
    //屏幕的宽度
    //隐式解析 在可选类型的后边 加上 ! 就不用在使用时在后边加 ! 了  如果解析类型后边跟的是? 则在使用是需要解包 在后边加上 !
    var screenWidth:CGFloat!
    //屏幕的高度
    var screenHeight:CGFloat!
    
    var gameView:GameView!
    //播放音乐的方法库
    var bgMusicPlayer:AVAudioPlayer!
    //速度的label
    var speedShow:UILabel!
    //分数的label
    var scoreShow:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景颜色
        self.view.backgroundColor = UIColor.whiteColor()
        //设置大小
        let rect = UIScreen.mainScreen().bounds
        screenWidth = rect.size.width
        screenHeight = rect.size.height
        addToolBar()
        let gameRect = CGRectMake(rect.origin.x + MARGINE, rect.origin.y + TOOLBAR_HEIGHT + 2 * MARGINE, rect.size.width - MARGINE * 2, rect.size.height - BUTTON_SIZE * 2 - TOOLBAR_HEIGHT)
        gameView = GameView(frame: gameRect)
        gameView.delegate = self
        self.view.addSubview(gameView)
        
        
        //添加背景音乐
        let bgMusicUrl = NSBundle.mainBundle().URLForResource("bgMusic", withExtension: "mp3")
        gameView.startGame()
        
        addButtons()
        do
        {
            try bgMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicUrl!)//解包
        }catch
        {
            
        }
        bgMusicPlayer.numberOfLoops = -1
        bgMusicPlayer.play()
    }

    
    //添加toolbar
    func addToolBar()
    {
        let toolBar = UIToolbar(frame: CGRectMake(0,MARGINE*2,screenWidth,TOOLBAR_HEIGHT))
        self.view.addSubview(toolBar)
        
        //创建 一个显示速度的标签
        let speedLabel = UILabel()
        speedLabel.frame = CGRectMake(0, 0, 50, TOOLBAR_HEIGHT)
        speedLabel.text = "速度:"
        let speedLabelItem = UIBarButtonItem(customView: speedLabel)
        
        //创建第二个显示速度值的标签
        speedShow = UILabel()
        speedShow.frame = CGRectMake(0, 0, 20, TOOLBAR_HEIGHT)
        speedShow.textColor = UIColor.redColor()
        let speedShowItem = UIBarButtonItem(customView: speedShow)
        
        //创建第三个显示当前积分的标签
        let scoreLabel = UILabel()
        scoreLabel.frame = CGRectMake(0, 0, 90, TOOLBAR_HEIGHT)
        scoreLabel.text = "当前积分:"
        let scoreLabelItem = UIBarButtonItem(customView: scoreLabel)
        
        //创建第四个显示积分值的标签
        scoreShow = UILabel()
        scoreShow.frame = CGRectMake(0, 0, 40, TOOLBAR_HEIGHT)
        scoreShow.textColor = UIColor.redColor()
        let scoreShowItem = UIBarButtonItem(customView: scoreShow)
        
        let flexItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.items = [speedLabelItem,speedShowItem,flexItem,scoreLabelItem,scoreShowItem]
        
    }
    
    
    //定义方向
    func addButtons()
    {
        //左
        let leftBtn = UIButton()
        leftBtn.frame = CGRectMake(screenWidth - BUTTON_SIZE * 3 - MARGINE, screenHeight - BUTTON_SIZE - MARGINE, BUTTON_SIZE, BUTTON_SIZE)
        leftBtn.alpha = BUTTON_ALPHA
        leftBtn.setTitle("⬅️", forState: UIControlState.Normal)
        leftBtn.addTarget(self, action: "left:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(leftBtn)
        
        //上
        let upBtn = UIButton()
        upBtn.frame = CGRectMake(screenWidth - BUTTON_SIZE * 2 - MARGINE, screenHeight - BUTTON_SIZE * 2 - MARGINE, BUTTON_SIZE, BUTTON_SIZE)
        upBtn.alpha = BUTTON_ALPHA
        upBtn.setTitle("⬆️", forState: UIControlState.Normal)
        upBtn.addTarget(self, action: "up:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(upBtn)
        
        //右
        let rightBtn = UIButton()
        rightBtn.frame = CGRectMake(screenWidth - BUTTON_SIZE - MARGINE, screenHeight - BUTTON_SIZE - MARGINE, BUTTON_SIZE, BUTTON_SIZE)
        rightBtn.alpha = BUTTON_ALPHA
        rightBtn.setTitle("➡️", forState: UIControlState.Normal)
        rightBtn.addTarget(self, action: "right:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(rightBtn)
        
        //下
        let downBtn = UIButton()
        downBtn.frame = CGRectMake(screenWidth - BUTTON_SIZE * 2 - MARGINE, screenHeight - BUTTON_SIZE - MARGINE, BUTTON_SIZE, BUTTON_SIZE)
        downBtn.alpha = BUTTON_ALPHA
        downBtn.setTitle("⬇️", forState: UIControlState.Normal)
        downBtn.addTarget(self, action: "down:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(downBtn)
        
    }
    
    func left(sender:UIButton)
    {
//        print("zuo")
        gameView.moveLeft()
    }
    func up(sender:UIButton){
//        print("up")
        gameView.rotate()
    }
    func right(sender:UIButton){
//        print("right")
        gameView.moveRight()
    }
    func down(sender:UIButton){
//        print("down")
        gameView.moveDown()
    }
    
    func updataScore(score: Int) {
        self.scoreShow.text = "\(score)"
    }
    
    func updataSpeed(speed: Int) {
        self.speedShow.text = "\(speed)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

