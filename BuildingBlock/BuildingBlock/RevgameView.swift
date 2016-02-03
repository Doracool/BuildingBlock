//
//  RevgameView.swift
//  BuildingBlock
//
//  Created by qingyun on 16/2/1.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

import UIKit
import AVFoundation

//重新定义 +运算符 使其支持Int + double运算
// 方法名字 参数 返回类型
//func + (left: Int , right: Double) ->Double{
//    return Double(left) + right
//}
////同上重新定义 -
//func - (left: Int , right: Double) ->Double{
//    return Double(left) - right
//}

//协议
protocol RevGameViewDelegate
{
    func updataScore(score:Int)
    func updataSpeed(speed:Int)
}

class RevgameView: UIView {

    var delegate:RevGameViewDelegate!
    var thtrisRows = 19
    let thtrisCols = 15
    let cellSize :Int
    //绘制网格的笔触的粗细
    let STROKE_WIDTH :Double = 1.0
    let BASE_SPEED :Double = 0.6
    //没方块为0
    let NO_BLOCK = 0
    var ctx :CGContextRef!
    //定义消除音乐的对象
    var disPlayer: AVAudioPlayer!
    //定义一个实例代表内存中的图片
    var image: UIImage!
    //当前的计时器
    var curTimer: NSTimer!
    
    var currentIndex: Int!
    var RevIsStop:UIButton!
    //定义方块的颜色
    let colors = [UIColor.whiteColor().CGColor,
        UIColor.redColor().CGColor,
        UIColor.greenColor().CGColor,
        UIColor.blueColor().CGColor,
        UIColor.yellowColor().CGColor,
        UIColor.magentaColor().CGColor,
        UIColor.purpleColor().CGColor,
        UIColor.brownColor().CGColor]
    
    //定义几种可能出现的方块组合
    var blockArr: [[Block]]
    
    var tetris_status = [[Int]]()
    var currentFall: [Block]!
    var curScore :Int = 0
    var curSpeed = 1
    
    var canDown = true
    
    //重写init方法
    override init(frame: CGRect) {
        self.blockArr = [
            //第一种 Z
            [
                Block(x: thtrisCols / 2 - 1 , y: 18  ,color :1),
                Block(x: thtrisCols / 2 , y:18 ,color : 1),
                Block(x: thtrisCols / 2 , y:19 ,color : 1),
                Block(x: thtrisCols / 2 + 1 , y:19 ,color : 1)
            ],
            //第二种 反Z
            [
                Block(x: thtrisCols / 2 - 1 , y: 19, color : 2),
                Block(x: thtrisCols / 2 , y: 19,color : 2),
                Block(x: thtrisCols / 2 , y: 18 , color : 2),
                Block(x: thtrisCols / 2 + 1 , y: 18 , color : 2)
            ],
            //第三种 正方形
            [
                Block(x: thtrisCols / 2 - 1 , y: 18 , color : 3),
                Block(x: thtrisCols / 2 , y: 18 ,color : 3),
                Block(x: thtrisCols / 2 , y: 19 ,color : 3),
                Block(x: thtrisCols / 2 - 1 , y: 19 ,color: 3)
            ],
            //第四种 右拐L
            [
                Block(x: thtrisCols / 2 - 1 ,y: 19 ,color :4),
                Block(x: thtrisCols / 2 - 1 , y: 18 ,color :4),
                Block(x: thtrisCols / 2 - 1 , y: 17 ,color :4),
                Block(x: thtrisCols / 2 , y: 17 ,color :4)
            ],
            //第五种 左拐L
            [
                Block(x: thtrisCols / 2 , y: 18 ,color :5),
                Block(x: thtrisCols / 2 , y: 17 ,color :5),
                Block(x: thtrisCols / 2 , y: 16 ,color :5),
                Block(x: thtrisCols / 2 - 1 , y: 16 ,color :5)
            ],
            //第六种 竖条
            [
                Block(x: thtrisCols / 2 , y: 19 ,color :6),
                Block(x: thtrisCols / 2 , y: 18 ,color :6),
                Block(x: thtrisCols / 2 , y: 17 ,color :6),
                Block(x: thtrisCols / 2 , y: 16 ,color :6)
            ],
            //第七种 坦克
            [
                Block(x: thtrisCols / 2 , y: 18 , color :7),
                Block(x: thtrisCols / 2 - 1 , y: 19 , color :7),
                Block(x: thtrisCols / 2 , y: 19 , color :7),
                Block(x: thtrisCols / 2 + 1, y: 19 , color :7)
            ]
        ]
        //计算方块的大小
        self.cellSize = Int(frame.size.width) / thtrisCols
        let shouldH = frame.size.height
        thtrisRows = Int(shouldH) / cellSize
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGrayColor()
        //获取消除的音频
        let disMusicUrl = NSBundle.mainBundle().URLForResource("消除", withExtension: "mp3")
        //创建播放AVAudioPlayer
        do
        {
            try disPlayer = AVAudioPlayer(contentsOfURL: disMusicUrl!)
        }catch
        {
            
        }
        disPlayer.numberOfLoops = 0
        
        //开启在内存中绘图
        UIGraphicsBeginImageContext(self.bounds.size)
        //获取Quartz 2D绘图的CGContextRef对象
        ctx = UIGraphicsGetCurrentContext()
        //填充背景色
        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
        CGContextFillRect(ctx, self.bounds)
        //绘制网格
        cresteCells(thtrisRows, cols: thtrisCols, cellWidth: cellSize, cellHeight: cellSize)
        image = UIGraphicsGetImageFromCurrentImageContext()

}
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTetrisStats()
    {
        RevIsStop = UIButton.init(type: UIButtonType.Custom)
        RevIsStop.setTitle("asd", forState: UIControlState.Normal)
        //把准备加入数组的数据 的数量 和初始值 传入
        let tmpRow = Array(count: thtrisCols, repeatedValue: NO_BLOCK)
        tetris_status = Array(count: thtrisRows, repeatedValue: tmpRow)
    }
    
    func initBlock()
    {
        //生成一个随机数
        let diceFaceCount: UInt32 = UInt32(blockArr.count)
        let randomRoll = Int(arc4random_uniform(diceFaceCount))
        //随机出数组中的某个元素作为现在正在下落的方块
        currentFall = blockArr[randomRoll]
        currentIndex = randomRoll
    }
    

    func cresteCells(rows:Int, cols:Int ,cellWidth :Int ,cellHeight :Int)
    {
        //开始创建路径
        CGContextBeginPath(ctx)
        //绘制横向网格
        for var i = 0 ; i <= thtrisRows ; i++
        {
            CGContextMoveToPoint(ctx, 0, CGFloat(i * cellSize))
            CGContextAddLineToPoint(ctx, CGFloat(thtrisCols * cellSize), CGFloat(i * cellSize))
        }
        //绘制竖直网格
        for var i = 0 ; i <= thtrisCols ; i++
        {
            CGContextMoveToPoint(ctx, CGFloat(i * cellSize), 0)
            CGContextAddLineToPoint(ctx, CGFloat(i * cellSize), CGFloat(thtrisRows * cellSize))
        }
        CGContextClosePath(ctx)
        //设置颜色
        CGContextSetStrokeColorWithColor(ctx, UIColor(red: 0.9,
            green: 0.9, blue: 0.9, alpha: 1).CGColor)
        //设置粗细
        CGContextSetLineWidth(ctx, CGFloat(STROKE_WIDTH))
        //绘制线条
        CGContextStrokePath(ctx)
}
    override func drawRect(rect: CGRect) {
        //获取图形上下文
        _ = UIGraphicsGetCurrentContext()
        //将内存中的image绘制
        image.drawAtPoint(CGPointZero)
    }
    //绘制俄罗斯方块的状态
    func drawBlock()
    {
        for var i = 0 ; i < thtrisRows ; i++
        {
            for var j = 0 ; j < thtrisCols ; j++
            {
                //有方块的地方绘制颜色
                if tetris_status[i][j] != NO_BLOCK
                {
                    //设置填充的颜色
                    CGContextSetFillColorWithColor(ctx, colors[tetris_status[i][j]])
                    //绘制矩形
                    CGContextFillRect(ctx, CGRectMake(CGFloat(j * cellSize + STROKE_WIDTH), CGFloat(i * cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH * 2), CGFloat(cellSize - STROKE_WIDTH * 2)))
                }
                    //没有方块的地方绘制白色
                else
                {
                    //设置填充颜色
                    CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
                    //绘制矩形
                    CGContextFillRect(ctx, CGRectMake(CGFloat(j * cellSize + STROKE_WIDTH), CGFloat(i * cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH * 2), CGFloat(cellSize - STROKE_WIDTH * 2)))
                }
            }
        }
    }
    
    func RevGameStop()
    {
        if RevIsStop.titleLabel?.text == "asd"
        {
            RevIsStop.setTitle("dsa", forState: UIControlState.Normal)
            curTimer.fireDate = NSDate.distantFuture()
        }else
        {
            RevIsStop.setTitle("asd", forState: UIControlState.Normal)
            curTimer.fireDate = NSDate.distantPast()
        }
    }
    
    func moveUP()
    {
        var canUp = true
        
        for var i = 0 ; i < currentFall.count ; i++
        {
            if currentFall[i].y <= 0
            {
                canUp = false
                break
            }
            if tetris_status[currentFall[i].y - 1][currentFall[i].x] != NO_BLOCK
            {
                canUp = false
                break
            }
        }
        if canUp
        {
            self.drawBlock()
            for var i = 0 ; i < currentFall.count ; i++
            {
                let cur = currentFall[i]
                CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
                CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x * cellSize + STROKE_WIDTH), CGFloat(cur.y * cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH * 2), CGFloat(cellSize - STROKE_WIDTH * 2)))
            }
            for var i = 0 ; i < currentFall.count ; i++
            {
                currentFall[i].y--
            }
            for var i = 0 ; i < currentFall.count ; i++
            {
                let cur = currentFall[i]
                CGContextSetFillColorWithColor(ctx, colors[cur.color])
                CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x * cellSize + STROKE_WIDTH ), CGFloat(cur.y * cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH * 2), CGFloat(cellSize - STROKE_WIDTH * 2)))
            }
        }
        else
        {
            for var i = 0 ; i < currentFall.count ; i++
            {
                let cur = currentFall[i]
                if cur.y > thtrisRows - 2
                {
                    curTimer.invalidate()
                    //显示提示框
                    let alert = UIAlertController(title: "提醒", message: "胜败乃兵家常事,大侠请重新来过", preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                        
                    })
                    let contuineAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                        self.RevStartGame()
                    })
                    
                    alert.addAction(cancelAction)
                    alert.addAction(contuineAction)
                    
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                tetris_status[cur.y][cur.x] = cur.color
            }
            
            lineFull()
            initBlock()
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        self.setNeedsDisplay()
    }

    func moveLeft()
    {
        //判断是否可以左移
        var canLeft = true
        
        for var i = 0 ; i < currentFall.count ; i++
        {
            //如果已经移到左边了
            if currentFall[i].x <= 0
            {
                canLeft = false
                break
            }
            //或者有方块
            if tetris_status[currentFall[i].y][currentFall[i].x - 1] != NO_BLOCK
            {
                canLeft = false
                break
            }
        }
        if canLeft
        {
            //可以左移
            self.drawBlock()
            //将左移前的方块涂成白色
            for var i = 0 ; i < currentFall.count ; i++
            {
                let cur = currentFall[i]
                CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
                CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x * cellSize + STROKE_WIDTH), CGFloat(cur.y * cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH * 2), CGFloat(cellSize - STROKE_WIDTH * 2)))
            }
            //左移所有正在下降的方块
            for var i = 0 ; i < currentFall.count ; i++
            {
                currentFall[i].x--
            }
            //将左移的方块渲染颜色
            for var i = 0 ; i < currentFall.count ; i++
            {
                let cur = currentFall[i]
                CGContextSetFillColorWithColor(ctx, colors[cur.color])
                CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x * cellSize + STROKE_WIDTH), CGFloat(cur.y * cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH * 2), CGFloat(cellSize - STROKE_WIDTH * 2)))
            }
            image = UIGraphicsGetImageFromCurrentImageContext()
            self.setNeedsDisplay()
        }
        
    }
    
    func moveRight()
    {
        //判断是否可以右移
        var canRigth = true
        for var i = 0 ; i < currentFall.count ; i++
        {
            //如果已经移动到右边了
            if currentFall[i].x >= thtrisCols - 1
            {
                canRigth = false
                break
            }
            //如果右边有方块不能移动
            if tetris_status[currentFall[i].y][currentFall[i].x + 1] != NO_BLOCK
            {
                canRigth = false
                break
            }
        }
        //能够右移
        if canRigth
        {
            self.drawBlock()
            //将右移前的方块涂成白色
            for var i = 0 ; i < currentFall.count ; i++
            {
                let cur = currentFall[i]
                
                CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
                CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x * cellSize + STROKE_WIDTH), CGFloat(cur.y * cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH * 2), CGFloat(cellSize - STROKE_WIDTH * 2)))
            }
            //右移所有正在下降的方块
            for var i = 0 ; i < currentFall.count ; i++
            {
                currentFall[i].x++
            }
            //将右移的方块渲染颜色
            for var i = 0 ; i < currentFall.count ; i++
            {
                let cur = currentFall[i]
                CGContextSetFillColorWithColor(ctx, colors[cur.color])
                CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x * cellSize + STROKE_WIDTH), CGFloat(cur.y * cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH * 2), CGFloat(cellSize - STROKE_WIDTH * 2)))
            }
            image = UIGraphicsGetImageFromCurrentImageContext()
            self.setNeedsDisplay()
        }
    }
    
    func rotate()
    {
        var canRotate = true
        if currentIndex == 2
        {
            
        }
        else
        {
            for var i = 0 ; i < currentFall.count ; i++
            {
                let preX = currentFall[i].x
                let preY = currentFall[i].y
                
                if i != 2
                {
                    //计算旋转后的坐标
                    let afterRotateX = currentFall[2].x + preY - currentFall[2].y
                    let afterRotateY = currentFall[2].y + currentFall[2].x - preX
                    //如果旋转后的x。y越界或者旋转后的位置已有方块，表明不能旋转
                    if afterRotateX < 0 || afterRotateX > thtrisCols - 1 || afterRotateY < 0 || afterRotateY > thtrisRows - 1||tetris_status[afterRotateY][afterRotateX] != NO_BLOCK
                    {
                        canRotate = false
                        break
                    }
                }
            }
            
            if canRotate
            {
                for var i = 0 ; i < currentFall.count ; i++
                {
                    let cur = currentFall[i]
                    
                    CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
                    CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x*cellSize + STROKE_WIDTH), CGFloat(cur.y*cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH*2), CGFloat(cellSize - STROKE_WIDTH*2)))
                }
                
                for var i = 0 ; i < currentFall.count ; i++
                {
                    let preX = currentFall[i].x
                    let preY = currentFall[i].y
                    
                    if i != 2
                    {
                        currentFall[i].x = currentFall[2].x + preY - currentFall[2].y
                        currentFall[i].y = currentFall[2].y + currentFall[2].x - preX
                    }
                    
                }
                
                for var i = 0 ; i < currentFall.count ; i++
                {
                    let cur = currentFall[i]
                    
                    CGContextSetFillColorWithColor(ctx, colors[cur.color])
                    CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x*cellSize + STROKE_WIDTH), CGFloat(cur.y*cellSize + STROKE_WIDTH), CGFloat(cellSize - STROKE_WIDTH*2), CGFloat(cellSize - STROKE_WIDTH*2)))
                }
                
                image = UIGraphicsGetImageFromCurrentImageContext()
                
                self.setNeedsDisplay()
            }
        }
    }
    

    func lineFull()
    {
        //一次遍历每一行
        for var i = thtrisRows - 1 ; i >= 0 ; i--
        {
            var flag = true
            //遍历当前的每一个单元格
            for var j = 0 ; j < thtrisCols ; j++
            {
                if tetris_status[i][j] == NO_BLOCK
                {
                    flag = false
                    break
                }
            }
            //如果全部由方块
            if flag
            {
                //积分增加10
                curScore += 10
                self.delegate.updataScore(curScore)
                //如果达到升级条件
                if curScore >= curSpeed * curSpeed * 100
                {
                    //速度加快
                    curSpeed += 1
                    self.delegate.updataSpeed(curSpeed)
                    //让原有计时器失效重启记时
                    curTimer.invalidate()
                    curTimer = NSTimer.scheduledTimerWithTimeInterval((BASE_SPEED / Double(curSpeed)), target: self, selector: "moveDown", userInfo: nil, repeats: true)
                }
                //将当前的所有方块上移
                for var j = i ; j < thtrisRows - 1 ; j++
                {
                    for var k = 0 ; k < thtrisCols ; k++
                    {
                        tetris_status[j][k] = tetris_status[j+1][k]
                    }
                }
                //播放消除音乐
//                if !disPlayer.playing
//                {
//                    disPlayer.play()
//                }
            }
        }
    }
    

    
    func RevStartGame()
    {
        self.curSpeed = 1
        self.delegate.updataSpeed(self.curSpeed)
        self.curScore = 0
        self.delegate.updataScore(self.curScore)
        
        initTetrisStats()
        initBlock()
        curTimer = NSTimer.scheduledTimerWithTimeInterval(BASE_SPEED / Double(curSpeed), target: self, selector: "moveUP", userInfo: nil, repeats: true)
    }


}


