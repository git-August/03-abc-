//
//  ViewController.m
//  03-图片浏览器课后习题
//
//  Created by Ibokan on 15/3/29.
//  Copyright (c) 2015年 Ibokan. All rights reserved.
//

#import "ViewController.h"
#define iconWH 50
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#pragma mark 使用老师的思路来捋一捋程序
#pragma mark第一步,添加image,出现错误如下:需要用到的类是UIImageView,而不是UIImage
    //理解一下,这个UIImageView相当于你拖过去的那个控件！！！里面放的UIImage
    //    UIImage * img1 = [[UIImage alloc] init];
    //    img1 = [UIImage imageNamed:@"011.gif"];
    /*ERROR重复代码,效率低
    UIImageView * img1 = [[UIImageView alloc] init];//初始化到self.view中
    img1.image = [UIImage imageNamed:@"011.gif"];
    img1.frame = CGRectMake(0, 0, 50, 50);//rect想象成空间坐标，就是把上面的图片放置的地方
    [self.view addSubview:img1];//又犯了一个错误，应该放到viewload中，刚才放到了segment触发中。。。*/
    /*ERROR程序的移植修改起来多
    CGFloat marginX = firsticonX;
    CGFloat marginY = firsticonY;
#pragma mark 第三步,使用for循环解决重复的函数,i控制行,j控制列;首先确定第一个icon的坐标,剩下的icon坐标就可以确定
    int num = 0;
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 2; j++) {
            
            [self addiconfunc:(num++) andrectX:(marginX * (j + 1) + (iconWH * j))andrectY:(marginY * (i + 1) + (iconWH * i))];
        }
    }*/
    
    [self iconArrangement:(2) andIsAddImgView:YES andAddIconNum:10];
    
}

#pragma mark 第四步,再次构造函数
- (void)iconArrangement:(int)columns andIsAddImgView:(BOOL)imgview andAddIconNum:(int)num{
    #pragma mark 第三步,利用列数作为改变图片排列的唯一参数,for循环解决重复函数
//    int columns = 2;
    
    CGFloat margin = (self.view.frame.size.width - columns * iconWH) / (columns + 1);
    CGFloat firsticonY = 100;//此值固定
    CGFloat firsticonX = margin;
    CGFloat iconTwoPointDistance = margin + iconWH;
    for (int i = 0; i < num; i++) {//i值控制着图标个数,若是view did构造的少于此处i值，sigabrt!!!
        //抽象化概念,任一行任一列的坐标公式
        int iconRow = i / columns;
        int iconCol = i % columns;
        CGFloat iconX = firsticonX + iconCol * iconTwoPointDistance;//列变x变,行变y变
        CGFloat iconY = firsticonY + iconRow * iconTwoPointDistance;
//#warning 如何重构代码?只传一个参数便能判断是否添加uiimageview控件
        if (imgview == YES) {
            if (i != (num - 1)) {
                [self addiconByaddimageview:i andrectX:(iconX) andrectY:(iconY)];//这句的功能是添加UIImageView控件,每执行一次就添加一次
            }
            else if (i == (num - 1)) {
                UIButton * addIconbtn = [[UIButton alloc] init];
                [addIconbtn setTitle:@"⊞" forState:UIControlStateNormal];
                [addIconbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                addIconbtn.titleLabel.font = [UIFont systemFontOfSize:44];
                addIconbtn.backgroundColor = [UIColor whiteColor];
                addIconbtn.frame = CGRectMake(iconX, iconY ,iconWH ,iconWH);
//                UIControl * addctrlbtn = [[UIControl alloc] init];
                [addIconbtn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];//UIButton继承自UIControl!!!监听控制器上的点击事件
                [self.view addSubview:addIconbtn];
//                [self targetForAction:@selector(btnclick:) withSender:addIconbtn];
            }
        }
        else {
            UIView * imageview = self.view.subviews[i + 1];//如果use autolayout不去掉勾选,出现UILAYOUT2个
            //        NSLog(@"%@",imageview.class);
            //修改控件位置(RECT)三部曲:读改写
            CGRect tempFrame = imageview.frame;
            tempFrame.origin = CGPointMake(iconX, iconY);
            imageview.frame = tempFrame;
        }

    }
    
}
- (void)btnclick: (UIButton *)sender{
//    NSLog(@"你点击我干啥?");
//    NSLog(@"%@",self.view.subviews[((int)sender.frame.origin.x % 9)]);
    [self.view insertSubview:self.view.subviews[((int)sender.frame.origin.x % 9)] aboveSubview:self.view.subviews[10]];//第十张是UIButton
//    [self.view.subviews 
    [self addiconByaddimageview:1 andrectX:sender.frame.origin.x andrectY:sender.frame.origin.y];
    CGRect tempframe  = [self.view.subviews[((int)sender.frame.origin.x % 9)] frame];
    tempframe.origin.x += 50;
    if (tempframe.origin.x >= 200) {
        tempframe.origin.x = 50;
        tempframe.origin.y += 50;
    }
    sender.frame = tempframe;
//    int columns = (int)sender.selectedSegmen

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 第二步,构造函数,解决重复出现的语句
- (void)addiconByaddimageview:(int) num andrectX:(CGFloat)x andrectY:(CGFloat)y{
    UIImageView * imgview = [[UIImageView alloc] init];
    NSString * iconname = [NSString stringWithFormat:@"01%d.gif",(num + 1)];
    imgview.image = [UIImage imageNamed:iconname];
    imgview.frame = CGRectMake(x, y, iconWH, iconWH);
    [self.view addSubview:imgview];
}
#pragma mark 03-图片浏览器课后习题，带加号的图片排列
- (IBAction)showRowIcon:(UISegmentedControl *)sender {
#pragma mark 注释部分没有排列成功
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    int columns = (int)sender.selectedSegmentIndex + 2;
    [self iconArrangement:columns andIsAddImgView:NO andAddIconNum:10];
    [UIView commitAnimations];
}

@end
