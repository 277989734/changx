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

@end

@implementation creatData

-(void)initArrWith:(NSInteger)index
{
    
//先创建一个二维数独，所有的数独均以这个为模板进行改变,下面的数独需要修改
   
    int seedArray[9][9]={
        {9,7,8,3,1,2,6,4,5},
        {3,1,2,6,4,5,9,7,8},
        {6,4,5,9,7,8,3,1,2},
        {7,8,9,1,2,3,4,5,6},
        {1,2,3,4,5,6,7,8,9},
        {4,5,6,7,8,9,1,2,3},
        {8,9,7,2,3,1,5,6,4},
        {2,3,1,5,6,4,8,9,7},
        {5,6,4,8,9,7,2,3,1}
    };
    
//    生成的b一维数组是0-9的随机数
    int b[9]={0};
    for (int i=0; i<9; ) {
        int arc=arc4random()%9+1;
        int j;
        for (j=0; j<i+1; j++) {
            if (arc==b[j]) {
                break;
            }
        }
        if (j==i+1) {
            
            b[i]=arc;
            i++;
        }
    }
    
//    此时得到的数组就是一个原始矩阵
 
    
//    进行变换，由随机的一维数组进行变换
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            for (int k=0; k<9; k++) {
                if (seedArray[i][j]==b[k]) {
                    seedArray[i][j]=k+1;
                    break;
                }
            }

        }
 
    }

    
//    此时得到的数组就是一次变化后的唯一解矩阵
    
    //再抠出index个元素，然后赋值为0
    for (int i=0; i<index; ) {
        int x=arc4random()%9;
        int y=arc4random()%9;

        if (seedArray[x][y]!=0) {
            seedArray[x][y]=0;
            i++;
        }
    }

//    此时得到的数组就是被抠出index个元素后的矩阵，可以作为题目

    
//    再将c的数组转换为OC的数组
    NSMutableArray  *arr=[NSMutableArray array];
    
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            NSString *num=[NSString stringWithFormat:@"%d",seedArray[i][j]];
            [arr addObject:num];
        }
    }
    NSLog(@"");

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:arr forKey:@"rawData"];
    [defaults synchronize];
    
    
}

//该方法暂时没使用，已经修改为其他算法
//用于判断在横坐标为x，纵坐标为y的位置为v的值的情况下，是否有重复的数
-(BOOL) testx:(int)x y:( int) y z:(int) v arr:(int**)arr
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
