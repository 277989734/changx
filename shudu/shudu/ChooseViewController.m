//
//  ChooseViewController.m
//  shudu
//
//  Created by 常星 on 16/3/5.
//  Copyright © 2016年 常星. All rights reserved.
//

#import "ChooseViewController.h"
#import "NumberViewController.h"


@interface ChooseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    先判断本地有数据否，有的话才能继续上一次
    NSUserDefaults *defaulte=[NSUserDefaults standardUserDefaults];
    if ([defaulte objectForKey:@"rawData"]==nil) {
        
        _continueBtn.hidden=YES;
    }else
    {
        _continueBtn.hidden=NO;

    }
    
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)returnBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)BtnClick:(UIButton *)sender {
    NumberViewController *numberVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NumberViewController"];

    numberVC.index=sender.tag-200;
    [self presentViewController:numberVC animated:YES completion:nil];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
