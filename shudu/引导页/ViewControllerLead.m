//
//  ViewControllerLead.m
//  knownNews
//
//  Created by 常星 on 16/2/24.
//  Copyright © 2016年 常星. All rights reserved.
//

#import "ViewControllerLead.h"
#import "MyView.h"


@interface ViewControllerLead ()<UIScrollViewDelegate>

{
    NSArray *arr;

}
@end

@implementation ViewControllerLead

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr=@[@"bg1",@"bg2",@"bg3",@"bg4"];
    
    [self creatscroll];
    [self creatpage];
    
    
    
    
    // Do any additional setup after loading the view.
}



-(void)creatscroll
{
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    scroll.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:scroll];
    
    for (int i=0; i<arr.count; i++) {
        
        
            MyView *view=[[MyView alloc]initWithFrame:CGRectMake(i*(scroll.frame.size.width), 0, scroll.frame.size.width, scroll.frame.size.height) andWithimageName:arr[i]];
            
            [scroll addSubview:view];
      
        
    }
    scroll.contentSize=CGSizeMake(arr.count*(scroll.frame.size.width), 0);
    
//    scroll.contentOffset=CGPointMake(scroll.frame.size.width, 0);
    
    scroll.pagingEnabled=YES;
    
    scroll.delegate=self;
    
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    
        [self dismissViewControllerAnimated:YES completion:nil];
   

    
}


-(void)creatpage
{
    UIPageControl *page=[[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height*6.0/7.0, 80, 30)];
    page.numberOfPages=arr.count;
    page.tag=300;
    page.backgroundColor=[UIColor grayColor];
    
    [page.layer setCornerRadius:15];
    [self.view addSubview:page];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPageControl *page=[self.view viewWithTag:300];
    NSInteger count=scrollView.contentOffset.x/scrollView.frame.size.width;

    page.currentPage=count;
    
    if (count==3) {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self.view addGestureRecognizer:tap];
        tap.numberOfTouchesRequired=1;
        tap.numberOfTapsRequired=1;
        
    }
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
