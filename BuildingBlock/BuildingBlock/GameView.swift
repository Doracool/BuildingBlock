//
//  GameView.swift
//  BuildingBlock
//
//  Created by qingyun on 16/1/27.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

import UIKit
import AVFoundation

//重新定义 +运算符 使其支持Int + double运算
// 方法名字 参数 返回类型
func + (left: Int , right: Double) ->Double{
    return Double(left) + right
}
//同上重新定义 - 
func - (left: Int , right: Double) ->Double{
    return Double(left) - right
}

//协议
protocol GameViewDelegate
{
    func updataSoure(score:Int)
    func updataSpeed(speed:Int)
}

class GameView: UIView {

    var delegate:GameViewDelegate!
    //行和列
    var THTRIS_ROWS = 22
    let THTRIS_COLS = 15
    let CELL_SIZE :Int
    //绘制网格的笔触的粗细
    let STROKE_WIDTH :Double = 2.0
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
    var curSpeed :Int = 1
    
    //重写init方法
    override init(frame: CGRect) {
        self.blockArr = [
        //第一种 Z
            [
                Block(x: THTRIS_COLS / 2 - 1 , y: 0  ,color :1),
                Block(x: THTRIS_COLS / 2 , y:0 ,color : 1),
                Block(x: THTRIS_COLS / 2 , y:1 ,color : 1),
                Block(x: THTRIS_COLS / 2 + 1 , y:1 ,color : 1)
            ],
        //第二种 反Z
            [
                Block(x: THTRIS_COLS / 2 - 1 , y: 1, color : 2),
                Block(x: THTRIS_COLS / 2 , y: 1,color : 2),
                Block(x: THTRIS_COLS / 2 , y: 0 , color : 2),
                Block(x: THTRIS_COLS / 2 + 1 , y: 0 , color : 2)
            ],
        //第三种 正方形
            [
                Block(x: THTRIS_COLS / 2 - 1 , y: 0 , color : 3),
                Block(x: THTRIS_COLS / 2 , y: 0 ,color : 3),
                Block(x: THTRIS_COLS / 2 , y: 1 ,color : 3),
                Block(x: THTRIS_COLS / 2 - 1 , y: 1 ,color: 3)
            ],
        //第四种 右拐L
            [
                Block(x: THTRIS_COLS / 2 - 1 , y: 0 ,color :4),
                Block(x: THTRIS_COLS / 2 - 1 , y: 1 ,color :4),
                Block(x: THTRIS_COLS / 2 - 1 , y: 2 ,color :4),
                Block(x: THTRIS_COLS / 2 , y: 2 ,color :4)
            ],
        //第五种 左拐L
            [
                Block(x: THTRIS_COLS / 2 , y: 0 ,color :5),
                Block(x: THTRIS_COLS / 2 , y: 1 ,color :5),
                Block(x: THTRIS_COLS / 2 , y: 2 ,color :5),
                Block(x: THTRIS_COLS / 2 - 1 , y: 2 ,color :5)
            ],
        //第六种 竖条
            [
                Block(x: THTRIS_COLS / 2 , y: 0 ,color :6),
                Block(x: THTRIS_COLS / 2 , y: 1 ,color :6),
                Block(x: THTRIS_COLS / 2 , y: 2 ,color :6),
                Block(x: THTRIS_COLS / 2 , y: 3 ,color :6)
            ],
        //第七种 坦克
            [
                Block(x: THTRIS_COLS / 2 , y: 0 , color :7),
                Block(x: THTRIS_COLS / 2 - 1 , y: 1 , color :7),
                Block(x: THTRIS_COLS / 2 , y: 1 , color :7),
                Block(x: THTRIS_COLS / 2 + 1, y: 1 , color :7)
            ]
        ]
        //计算方块的大小
        self.CELL_SIZE = Int(frame.size.width) / THTRIS_COLS
        let shouldH = frame.size.height
        THTRIS_ROWS = Int(shouldH) / CELL_SIZE
        
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
        cresteCells(THTRIS_ROWS, cols: THTRIS_COLS, cellWidth: CELL_SIZE, cellHeight: CELL_SIZE)
        image = UIGraphicsGetImageFromCurrentImageContext()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initTetrisStats()
    {
        let tmpRow = Array(count: THTRIS_COLS, repeatedValue: NO_BLOCK)
        tetris_status = Array(count: THTRIS_ROWS, repeatedValue: tmpRow)
    }
    
    func initBlock()
    {
        //生成一个随机数
        let diceFaceCount: UInt32 = UInt32(blockArr.count)
        let randomRoll = Int(arc4random_uniform(diceFaceCount))
        //随机出数组中的某个元素作为现在正在下落的方块
        currentFall = blockArr[randomRoll]
    }
    
    func cresteCells(rows:Int, cols:Int ,cellWidth :Int ,cellHeight :Int)
    {
        //开始创建路径
        CGContextBeginPath(ctx)
        //绘制横向网格
        for var i = 0 ; i <= THTRIS_ROWS ; i++
        {
            CGContextMoveToPoint(ctx, 0, CGFloat(i * CELL_SIZE))
            CGContextAddLineToPoint(ctx, CGFloat(THTRIS_COLS * CELL_SIZE), CGFloat(i * CELL_SIZE))
        }
        //绘制竖直网格
        for var i = 0 ; i <= THTRIS_COLS ; i++
        {
            CGContextMoveToPoint(ctx, CGFloat(i * CELL_SIZE), 0)
            CGContextAddLineToPoint(ctx, CGFloat(i * CELL_SIZE), CGFloat(THTRIS_ROWS * CELL_SIZE))
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
        for var i = 0 ; i < THTRIS_ROWS ; i++
        {
            for var j = 0 ; j < THTRIS_COLS ; j++
            {
                //有方块的地方绘制颜色
                if tetris_status[i][j] != NO_BLOCK
                {
                    //设置填充的颜色
                    CGContextSetFillColorWithColor(ctx, colors[tetris_status[i][j]])
                    //绘制矩形
                    CGContextFillRect(ctx, CGRectMake(CGFloat(j * CELL_SIZE + STROKE_WIDTH), CGFloat(i * CELL_SIZE + STROKE_WIDTH), CGFloat(CELL_SIZE - STROKE_WIDTH * 2), CGFloat(CELL_SIZE - STROKE_WIDTH * 2)))
                }
                //没有方块的地方绘制白色
                else
                {
                    //设置填充颜色
                    CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
                    //绘制矩形
                    CGContextFillRect(ctx, CGRectMake(CGFloat(j * CELL_SIZE + STROKE_WIDTH), CGFloat(i * CELL_SIZE + STROKE_WIDTH), CGFloat(CELL_SIZE - STROKE_WIDTH * 2), CGFloat(CELL_SIZE - STROKE_WIDTH * 2)))
                }
            }
        }
    }

    
    func moveDown()
    {
        //定义向下的标记
        var canDown = true
        
        //判断当前的滑块是不是可以下滑
        for var i = 0 ; i < currentFall.count ; i++
        {
            //判断时候已经到底了
            if currentFall[i].y >= THTRIS_ROWS - 1
            {
                canDown = false
                break
            }
            //判断下一个是不是有方块
            if tetris_status[currentFall[i].y + 1][currentFall[i].x] != NO_BLOCK
            {
                canDown = false
                break
            }
        }
        if canDown{
        self.drawBlock()
        //将下移前的方块白色
        for var i = 0 ; i < currentFall.count ; i++
        {
            let cur = currentFall[i]
            //设置填充颜色
            CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor);
            //绘制矩形
            CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x * CELL_SIZE + STROKE_WIDTH), CGFloat(cur.y * CELL_SIZE + STROKE_WIDTH), CGFloat(CELL_SIZE - STROKE_WIDTH * 2), CGFloat(CELL_SIZE - STROKE_WIDTH * 2)))
        }
        //遍历每个方块，控制每个方块的坐标加1
        for var i = 0 ; i < currentFall.count ; i++
        {
            currentFall[i].y++
        }
        //将下移的每个方块的背景涂成方块的颜色
        for var i = 0 ; i < currentFall.count ; i++
        {
            let cur = currentFall[i]
            //设置填充颜色
            CGContextSetFillColorWithColor(ctx, colors[cur.color])
            //绘制矩形
            CGContextFillRect(ctx, CGRectMake(CGFloat(cur.x * CELL_SIZE + STROKE_WIDTH), CGFloat(cur.y * CELL_SIZE + STROKE_WIDTH), CGFloat(CELL_SIZE - STROKE_WIDTH * 2), CGFloat(CELL_SIZE - STROKE_WIDTH * 2)))
        }
//        initBlock()
    }
        else
        {
            for var i = 0 ; i < currentFall.count ; i++
            {
                let cur = currentFall[i]
                if cur.y < 2
                {
                    curTimer.invalidate()
                    //显示提示框
                    return
                }
                tetris_status[cur.y][cur.x] = cur.color
            }
            initBlock()
        }
        
        // 获取缓冲区的图片
        image = UIGraphicsGetImageFromCurrentImageContext()
        self.setNeedsDisplay()
    }
    
    func startGame()
    {
        self.curSpeed = 1
        self.delegate.updataSpeed(self.curSpeed)
        self.curScore = 0
        self.delegate.updataSoure(self.curScore)
        
        initTetrisStats()
        
        initBlock()
        
        curTimer = NSTimer.scheduledTimerWithTimeInterval(BASE_SPEED / Double(curSpeed), target: self, selector: "moveDown", userInfo: nil, repeats: true)
    }

}
