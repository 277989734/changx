//
//  creatData.m
//  xiaoGame
//
//  Created by 常星 on 16/3/1.
//  Copyright © 2016年 常星. All rights reserved.
//

#import "creatData.h"
#define  K 3

@interface creatData ()
{

    int arr[9][9];

}
@end

@implementation creatData

-(void)initArr
{
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            
            arr[i][j]=10;
            
        }
        
    }

    
    
    
    
    
    
}

-(void )achieveData
{
    [self initArr];
//   先将第一行设置成不同的0-9数据
    for (int i=0; i<8; ) {
        int arc=arc4random()%9;
        int j;
        for (j=0; j<9; j++) {
            if (arc==arr[0][j]) {
                break;
            }
        }
        if (j==9) {
            
            arr[0][i]=arc;
            i++;
        }
    }
    
    
    NSLog(@"12323123123123123123");

}




//用于判断在横坐标为x，纵坐标为y的位置为v的值的情况下，是否有重复的数
-(BOOL) testx:(int)x y:( int) y z:(int) v
{
    int _x = x / K * K;
    int _y = y / K * K;
    //测试3 * 3矩阵内是否有重复的数
    for(int i = _x; i <=_x+K-1; i++)
        for(int j = _y; j <= _y + K-1; j++)
            if(arr[i][j] == v)
                return false;
    //测试横向、纵向是否有重复的数
//    此处为全盘扫描便于后面使用
    
//    左
    for(int j = 0; j <=y-1; j++)
        if(arr[x][j] == v )
            return false;
//    右
    for(int j = y+1; j <K*K; j++)
        if(arr[x][j] == v )
            return false;
//    上
    for(int i=0;i<=x-1;i++)
        if(arr[i][y]==v)
            return false;
//    下
    for(int i=x+1;i<K*K;i++)
        if(arr[i][y]==v)
            return false;
    return true;


}





@end
