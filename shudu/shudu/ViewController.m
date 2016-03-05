//
//  ViewController.m
//  shudu
//
//  Created by 常星 on 16/3/4.
//  Copyright © 2016年 常星. All rights reserved.
//

#import "ViewController.h"
#import "ChooseViewController.h"
#import "ViewControllerLead.h"

#define INTRODUCE @"游戏简介:在9X9的网格中进行，网格被分为3X3的子网格，目标就是使用1-9之间的数字填满空格，使每个数字在每行、每列和每个子网格中只出现一次。\n      激发你的大脑，快来挑战把！！！"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    主界面
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startBtn:(id)sender {

    ChooseViewController *chooseVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChooseViewController"];
    [self presentViewController:chooseVC animated:YES completion:nil];
}
- (IBAction)guanyu:(id)sender {

    [self showGuanyu];

}

//显示简介
-(void)showGuanyu
{

    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"关于" message:INTRODUCE preferredStyle:UIAlertControllerStyleAlert];
    //代表具有按钮外观及动作的类型的按钮
    //    当点击按钮的时候，会执行的代码块
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    
    //    警告栏出现，并且显示相关按钮属性,要在最后显示
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}




- (IBAction)gameHelp:(id)sender {
    ViewControllerLead *leadVC=[[ViewControllerLead alloc]init];
    [self presentViewController:leadVC animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
