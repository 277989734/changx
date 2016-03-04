//
//  NumberViewController.m
//  xiaoGame
//
//  Created by 常星 on 16/3/1.
//  Copyright © 2016年 常星. All rights reserved.
//

#import "NumberViewController.h"
#import "creatData.h"


@interface NumberViewController ()


@property (strong, nonatomic) IBOutlet UIView *BoardView;

@end

@implementation NumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"数独";

    [self creatSuDuData];
    
    
    [self creatUI];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)creatSuDuData
{

    creatData *data=[[creatData alloc]init];

    
    
    [data achieveData];
    
    
}



-(void)creatUI
{
    
    UIView *viewBoard=[[UIView alloc]initWithFrame:CGRectMake(9, 73, self.view.frame.size.width-18, self.view.frame.size.width-18)];
    
    [self.view addSubview:viewBoard];
    

    
    for (int i=0; i<9; i++) {
        
        UIView *viewBG=[[UIView alloc]initWithFrame:CGRectMake(i%3*viewBoard.frame.size.width/3, i/3*viewBoard.frame.size.height/3, viewBoard.frame.size.height/3, viewBoard.frame.size.height/3) ];
        viewBG.layer.masksToBounds=YES;
        viewBG.layer.borderColor=[UIColor blackColor].CGColor;
        viewBG.layer.borderWidth=2;
        [viewBoard addSubview:viewBG];
        for (int j=0; j<9; j++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(j%3*viewBG.frame.size.width/3, j/3*viewBG.frame.size.height/3, viewBG.frame.size.height/3, viewBG.frame.size.height/3) ;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[NSString stringWithFormat:@"%d",arc4random()%9] forState:UIControlStateNormal];
            btn.layer.masksToBounds=YES;
            btn.layer.borderColor=[UIColor blackColor].CGColor;
            btn.layer.borderWidth=1;
            
            
            btn.backgroundColor=[UIColor grayColor];
            [viewBG addSubview:btn];
        }
        
    }



}

-(void)BtnClick:(UIButton *)btn
{

    [btn setTitle:@"123" forState:UIControlStateNormal];
    NSLog(@"123");
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
