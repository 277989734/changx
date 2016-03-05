//
//  MyView.m
//  yindao
//
//  Created by 常星 on 16/1/4.
//  Copyright © 2016年 常星. All rights reserved.
//

#import "MyView.h"




@interface MyView ()
@property (nonatomic,assign)CGRect frame;
@property(nonatomic,copy)NSString *imagename;
@end
@implementation MyView

- (instancetype)initWithFrame:(CGRect)frame andWithimageName:(NSString *)imagename
{
    if (self=[super init]) {
        _frame=frame;
        _imagename=imagename;
        [self creatview];
    }
    return self;
}
-(void)creatview
{

    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:_imagename]];
    image.frame=_frame;
    [self addSubview:image];



}


@end
