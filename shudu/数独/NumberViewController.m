//
//  NumberViewController.m
//  xiaoGame
//
//  Created by 常星 on 16/3/1.
//  Copyright © 2016年 常星. All rights reserved.
//

#import "NumberViewController.h"
#import "creatData.h"
#import "TPKeyboardAvoidingScrollView.h"


#define  K 3

@interface NumberViewController ()<UITextFieldDelegate>

{
    TPKeyboardAvoidingScrollView *scrollView;
    NSMutableArray *arr;//数独数据，会随着点击改变而改变
    NSArray *rawData;//原始数独数据，用于判断需不需要变红
    UIButton *chooseButton;//被用户点击的button
    UIView *viewChooseBG;//点击button之后出现的选择视图
    UIView *viewBoard;//按钮button所在的视图

    NSMutableDictionary *dict;//用于填写每个位置的备注信息
    
    NSTimer *timer;//用于计时
    NSInteger timerTime;//保存时间
    NSString *title;
    NSArray *arrTitle;
}
@property (strong, nonatomic) IBOutlet UIView *BoardView;

@end

@implementation NumberViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"数独";

    arrTitle=@[@"数独 - 简单",@"数独 - 一般",@"数独 - 困难"];
    
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
    if (self.index==0) {//继续上一次
        NSUserDefaults *defaulte=[NSUserDefaults standardUserDefaults];
        rawData=[defaulte objectForKey:@"rawData"];
        NSArray *arrSub=[defaulte objectForKey:@"arr"];
        if (arrSub==nil) {
            arr=[NSMutableArray arrayWithArray:rawData];
        }else{
            arr=[NSMutableArray arrayWithArray:arrSub];
        }
        dict=[defaulte objectForKey:@"dict"];
        if (dict==nil) {
            dict=[NSMutableDictionary dictionary];

        }
        
//        这里增加时间显示
        NSNumber *num=[defaulte objectForKey:@"timer"];
        if (num==nil) {
            
            timerTime=0;
        }else
        {
            timerTime=[num integerValue];
        
        }
        title=[defaulte objectForKey:@"title"];
        
    }else//重新开始
    {
        creatData *data=[[creatData alloc]init];
        [data initArrWith:(30+self.index*8-8)];
//        [data initArrWith:(3)];//实验使用

        NSUserDefaults *defaulte=[NSUserDefaults standardUserDefaults];
        rawData=[defaulte objectForKey:@"rawData"];
        arr=[NSMutableArray arrayWithArray:rawData];
        dict=[NSMutableDictionary dictionary];
        title=arrTitle[self.index-1];
        timerTime=0;
    }
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];

    
}

-(void)timerStart
{

    timerTime+=1;
    UILabel *labelTime=[scrollView viewWithTag:250];
    labelTime.text=[NSString stringWithFormat:@"%ld:%ld:%ld",timerTime/(60*60),timerTime/60,timerTime%60];
}


-(void)viewWillDisappear:(BOOL)animated
{
//页面将要消失的时候保存2个数组，1个字典
    NSUserDefaults *defaulte=[NSUserDefaults standardUserDefaults];
    [defaulte setObject:rawData forKey:@"rawData"];
    [defaulte setObject:arr forKey:@"arr"];
    [defaulte setObject:dict forKey:@"dict"];
    [defaulte setInteger:timerTime forKey:@"timer"];
    [defaulte setObject:title forKey:@"title"];
    [defaulte synchronize];


}

-(void)creatUI
{
    
    scrollView=[[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
    
//    创建一个标题

    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 20)];
    label.textAlignment=1;
    label.font=[UIFont systemFontOfSize:19];
    
    label.text=title;
    
    [scrollView addSubview:label];


    
//    创建主视图，显示数独棋盘
    [self creatUIViewBoard];
//    创建点击视图，显示备注
    [self creatViewChoose];
  
//    创建最底部的视图框，用于返回等操作
    [self creatTimerView];
    
}

-(void)creatUIViewBoard
{

    
    //    创建数独矩阵视图
    
    viewBoard=[[UIView alloc]initWithFrame:CGRectMake(9, 73, self.view.frame.size.width-18, self.view.frame.size.width-18)];
    [scrollView addSubview:viewBoard];
    
    
    
    //    思路1
    /*这样创建的视图button虽然好处理外框线，但是不便于后续的横、竖、框的完整性判断
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
     [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [btn setTitleShadowColor:[UIColor yellowColor] forState:UIControlStateSelected];
     btn.tag=300+i*9+j;
     if ([arr[i*9+j] isEqualToString:@"0"]) {
     btn.backgroundColor=[UIColor whiteColor];
     
     }else
     {
     [btn setTitle:arr[i*9+j] forState:UIControlStateNormal];
     btn.backgroundColor=[UIColor colorWithRed:174.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:0.8];
     btn.userInteractionEnabled=NO;
     }
     btn.layer.masksToBounds=YES;
     btn.layer.borderColor=[UIColor blackColor].CGColor;
     btn.layer.borderWidth=1;
     [viewBG addSubview:btn];
     }
     
     }
     */
    
    //    思路2,这样不便于创建外框线，但是方便做判断
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(j*viewBoard.frame.size.width/9, i*viewBoard.frame.size.height/9, viewBoard.frame.size.height/9, viewBoard.frame.size.height/9) ;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleShadowColor:[UIColor yellowColor] forState:UIControlStateSelected];
            btn.tag=300+i*9+j;
            if ([rawData[i*9+j] isEqualToString:@"0"]) {
                btn.backgroundColor=[UIColor whiteColor];
                if (![arr[i*9+j] isEqualToString:@"0"]) {
                    [btn setTitle:arr[i*9+j] forState:UIControlStateNormal];
                    [self testWithCoordinate:(i*9+j) withNum:arr[i*9+j]];
                    
                }
            }else
            {
                [btn setTitle:rawData[i*9+j] forState:UIControlStateNormal];
                btn.backgroundColor=[UIColor colorWithRed:174.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:0.8];
                btn.userInteractionEnabled=NO;
            }
            btn.layer.masksToBounds=YES;
            btn.layer.borderColor=[UIColor blackColor].CGColor;
            btn.layer.borderWidth=1;
            [viewBoard addSubview:btn];
            
        }
    }
}

-(void)creatViewChoose
{

    
    //    创建点击空格的反应视图
    viewChooseBG=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewBoard.frame), self.view.frame.size.width, 150.0/736.0*self.view.frame.size.height)];
    
    [scrollView addSubview:viewChooseBG];
    viewChooseBG.userInteractionEnabled=YES;
    viewChooseBG.hidden=YES;
    
    for (int i=0; i<3; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(CGRectGetMinX(viewBoard.frame)+i*(self.view.frame.size.width-19)/3.0,5, (self.view.frame.size.width-19)/3.0, viewChooseBG.frame.size.height/3.0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        if (i==0) {
            button.backgroundColor=[UIColor whiteColor];
            [button setTitle:@"不确定" forState:UIControlStateNormal];
        }else if (i==1)
        {
            button.backgroundColor=[UIColor grayColor];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            
        }else
        {
            button.backgroundColor=[UIColor colorWithRed:69.0/255.0 green:175.0/255.0 blue:250.0/255.0 alpha:1];
            [button setTitle:@"待定" forState:UIControlStateNormal];
            
        }
        button.tag=100+i;
        [viewChooseBG addSubview:button];
        [button addTarget:self action:@selector(colorChoose:) forControlEvents:UIControlEventTouchUpInside];
    }
    //    创建数字button
    
    for (int i=0; i<9; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(CGRectGetMinX(viewBoard.frame)+i*(self.view.frame.size.width-19)/9.0,5+viewChooseBG.frame.size.height/3.0,( self.view.frame.size.width-19)/9.0, viewChooseBG.frame.size.height/3.0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.backgroundColor=[UIColor whiteColor];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        
        button.tag=200+i;
        [viewChooseBG addSubview:button];
        [button addTarget:self action:@selector(numberChoose:) forControlEvents:UIControlEventTouchUpInside];
    }
    //    增加一个可以自己写备注的功能,
    UIButton *buttonSave=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonSave.backgroundColor=[UIColor grayColor];
    [buttonSave setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buttonSave.frame=CGRectMake(CGRectGetMinX(viewBoard.frame), 5+2.0*viewChooseBG.frame.size.height/3.0, 2.0*( self.view.frame.size.width-19)/9.0, viewChooseBG.frame.size.height/3.0);
    buttonSave.tag=150;
    [buttonSave addTarget:self action:@selector(btnSave:) forControlEvents:UIControlEventTouchUpInside];
    [viewChooseBG addSubview:buttonSave];
    
    UITextField *remark=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttonSave.frame), CGRectGetMinY(buttonSave.frame), 7.0*( self.view.frame.size.width-19)/9.0, viewChooseBG.frame.size.height/3.0)];
    remark.tag=180;
    remark.borderStyle=3;
    remark.delegate=self;
    [viewChooseBG addSubview:remark];


}
-(void)creatTimerView
{

    UIButton *buttonReturn=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonReturn.frame=CGRectMake(9,scrollView.frame.size.height-50, 4.0*( self.view.frame.size.width-19)/9.0, 30);
    [buttonReturn setTitle:@"返回" forState:UIControlStateNormal];
    [buttonReturn setImage:[UIImage imageNamed:@"tab_home1"] forState:UIControlStateNormal];
    [buttonReturn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonReturn addTarget:self action:@selector(returnBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:buttonReturn];

    
    UILabel *labelTime=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttonReturn.frame), CGRectGetMinY(buttonReturn.frame), 5.0*( self.view.frame.size.width-19)/9.0, 30)];
    labelTime.tag=250;
    labelTime.textAlignment=1;
//    下次从这里继续
    
    labelTime.text=[NSString stringWithFormat:@"%ld:%ld:%ld",timerTime/(60*60),timerTime/60,timerTime%60];
    [scrollView addSubview:labelTime];
    
    
}

-(void)returnBtn
{

    [self dismissViewControllerAnimated:YES completion:nil];

}


//textfield的协议事件，当用于开始编辑的时候，执行
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"当已经开始编辑的时候");
    UIButton *buttonSave=[viewChooseBG viewWithTag:150];
    
    buttonSave.userInteractionEnabled=YES;
    [buttonSave setTitle:@"保存" forState:UIControlStateNormal];
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"当已经结束编辑的时候");

}





-(void)btnSave:(UIButton *)btn
{
    UITextField *remark=[viewChooseBG viewWithTag:180];
    [dict setObject:remark.text forKey:[NSString stringWithFormat:@"%ld", chooseButton.tag]];

    [btn setTitle:@"已保存" forState:UIControlStateNormal];
}

-(void)colorChoose:(UIButton *)colorbtn
{
    NSInteger i=colorbtn.tag-100;
    if (i==0) {
        chooseButton.backgroundColor=[UIColor whiteColor];
        [chooseButton setTitle:@"" forState:UIControlStateNormal];
        [arr replaceObjectAtIndex:chooseButton.tag-300 withObject:@"0"];

        
    }else if (i==1)
    {
        chooseButton.backgroundColor=[UIColor grayColor];
        
    }else
    {
        chooseButton.backgroundColor=[UIColor colorWithRed:69.0/255.0 green:175.0/255.0 blue:250.0/255.0 alpha:1];
        
    }


}

-(void)numberChoose:(UIButton *)numberbtn
{
    
    viewChooseBG.hidden=YES;
    chooseButton.selected=NO;
    NSString *num=[NSString stringWithFormat:@"%ld",numberbtn.tag-200+1];
    [chooseButton setTitle:num forState:UIControlStateNormal];
    
    

    //    此处有bug，如果你首先输入对的值，然后再修改成错的，就不能进入循环中判断了，所有还是得先将数据加入数组中再进行判断
    [arr replaceObjectAtIndex:chooseButton.tag-300 withObject:num];
  

    [self testWithCoordinate:chooseButton.tag-300 withNum:num];

    

//    此处进行判断，由于进行判断的时候需要分情况进行颜色标注，如果返回值的话，需要分的情况就有8种，不便于在这个方法里面实现，所有在进行判断的方法里面进行操作
//    如果为yes，说明是正确的，如果为no，说明是错误的，有重复
    /*
        if ([self testWithCoordinate:chooseButton.tag-300 withNum:num]) {
            //    下面这句话是先将输入的数装入矩阵中，进行判断，如果先判断，再装入，就可以避免与自己相比
            [arr replaceObjectAtIndex:chooseButton.tag-300 withObject:num];
            
        }else//说明是有冲突的，需要将起冲突的行列，小矩阵变红
        {
        
        
        
        }
    
*/
    
}

-(void)BtnClick:(UIButton *)btn
{
    
    chooseButton.selected=NO;
    viewChooseBG.hidden=NO;
    chooseButton=btn;
    chooseButton.selected=!chooseButton.selected;
    NSLog(@"123");
    
    UIButton *buttonSave=[viewChooseBG viewWithTag:150];
    UITextField *remark=[viewChooseBG viewWithTag:180];

//    同时显示出备注栏
    NSString *remarktext=[dict objectForKey:[NSString stringWithFormat:@"%ld",chooseButton.tag]];
    if (remarktext==nil||[remarktext isEqualToString:@""]) {
        [buttonSave setTitle:@"备注" forState:UIControlStateNormal];
        remark.text=@"";
        buttonSave.userInteractionEnabled=NO;
    }else
    {
        buttonSave.userInteractionEnabled=YES;
        [buttonSave setTitle:@"保存" forState:UIControlStateNormal];
        remark.text=remarktext;
    
    }
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    viewChooseBG.hidden=YES;

}

//每次点击之后都要进行判断，如果出现相同就要警告颜色变红，没有就变为白，还不能将用户已经点击的颜色进行改变

//每次点击都全盘扫描会好很多
//用于判断在横坐标为x，纵坐标为y的位置为v的值的情况下，是否有重复的数
-(void)testWithCoordinate:(NSInteger )coordinate withNum:(NSString *)num
{
//    用3个标示符分别代表横、竖、小矩阵
    NSInteger flag1=0;
    NSInteger flag2=0;
    NSInteger flag3=0;

//    得到输入的坐标在整个棋盘的横纵坐标
    NSInteger x=coordinate/9;
    NSInteger y=coordinate%9;

//    得到输入的坐标所在的小棋盘的起始坐标
    NSInteger _x = x / K * K;
    NSInteger _y = y / K * K;
    //测试3 * 3矩阵内是否有重复的数，还要排除
    for(NSInteger i = _x; i <=_x+K-1; i++)
        for(NSInteger j = _y; j <= _y + K-1; j++)
            if([arr[i*9+j] isEqualToString: num]&&(i*9+j!=coordinate))//需要修改
            {
                flag1+=1;
                
            }
//    先初始置为白，然后如果出现相同再置为红，防止出现变红后不能回正的现象
    for(NSInteger i = _x; i <=_x+K-1; i++)
        for(NSInteger j = _y; j <= _y + K-1; j++)
            if([rawData[i*9+j] isEqualToString:@"0"])
            {
                UIButton *btn=[viewBoard viewWithTag:300+i*9+j];
                btn.backgroundColor=[UIColor whiteColor];
            }

    //    不需要排除本身的比较
    //    横
    for(NSInteger j = 0; j <K*K; j++)
        if([arr[x*9+j] isEqualToString: num] &&(x*9+j!=coordinate))
        {
            flag2+=1;

        }
    for(NSInteger j = 0; j <K*K; j++)
        if([rawData[x*9+j] isEqualToString:@"0"])
        {
            UIButton *btn=[viewBoard viewWithTag:300+x*9+j];
            btn.backgroundColor=[UIColor whiteColor];
        }

    
    
    
    //    竖
    
    for(NSInteger i = 0;i<K*K;i++)
        if([arr[i*9+y]isEqualToString: num]&&(i*9+y!=coordinate))
        {
            flag3+=1;

        }
    for(NSInteger i = 0;i<K*K;i++)
        if([rawData[i*9+y] isEqualToString:@"0"])
        {
            UIButton *btn=[viewBoard viewWithTag:300+i*9+y];
            btn.backgroundColor=[UIColor whiteColor];
        }

    
    
    
    if (flag1==1) {
        //说明小矩阵需要将无原始数据的位置变红,3个置红的操作应该放在最后
        for(NSInteger i = _x; i <=_x+K-1; i++)
            for(NSInteger j = _y; j <= _y + K-1; j++)
                if([rawData[i*9+j] isEqualToString:@"0"])
                {
                    UIButton *btn=[viewBoard viewWithTag:300+i*9+j];
                    btn.backgroundColor=[UIColor redColor];
                }
        
    }
    if (flag2==1) {
        //说明横需要将无原始数据的位置变红
        for(NSInteger j = 0; j <K*K; j++)
            if([rawData[x*9+j] isEqualToString:@"0"])
            {
                UIButton *btn=[viewBoard viewWithTag:300+x*9+j];
                btn.backgroundColor=[UIColor redColor];
            }
        
    }
    
    if (flag3==1) {
        //说明列需要将无原始数据的位置变红
        for(NSInteger i = 0;i<K*K;i++)
            if([rawData[i*9+y] isEqualToString:@"0"])
            {
                UIButton *btn=[viewBoard viewWithTag:300+i*9+y];
                btn.backgroundColor=[UIColor redColor];
            }
        
    }
    
    
    
//   这里判断是否结束，arr里面没有一个0的时候，就说明结束了
    int i;
    for (i=0; i<arr.count; i++) {
        if ([arr[i] isEqualToString:@"0"]) {
            break;
        }
    }
    if (i==arr.count) {
//        说明结束了，赢了
        if (timer!=nil) {
            [timer invalidate];
            timer = nil;
        }
        [self showWin];
    }
    
    
    
    
//    if (flag==0) {
//        [arr replaceObjectAtIndex:coordinate withObject:num];
//
//    }

    
//下面的方法是跳过本身进行比较，如果我是后装入然后进行比较的话，就不需要排除本身了
/*思路1
    //测试横向、纵向是否有重复的数
    //    此处为全盘扫描便于后面使用
    
    //    左
    for(int j = 0; j <=y-1; j++)
        if(arr[x][j] == num )
            return NO;
    //    右
    for(NSInteger j = y+1; j <K*K; j++)
        if(arr[x][j] == num )
            return NO;
    //    上
    for(NSInteger i=0;i<=x-1;i++)
        if(arr[i][y]== num)
            return NO;
    //    下
    for(NSInteger i=x+1;i<K*K;i++)
        if(arr[i][y]== num)
            return NO;
    return YES;
    
*/

}


//显示简介
-(void)showWin
{
    
    NSString *introdece=[NSString stringWithFormat:@"您总共花费时间为:%ld:%ld:%ld \n 祝贺您",timerTime/(60*60),timerTime/60,timerTime%60];
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"胜利" message:introdece preferredStyle:UIAlertControllerStyleAlert];
    //代表具有按钮外观及动作的类型的按钮
    //    当点击按钮的时候，会执行的代码块
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    
    //    警告栏出现，并且显示相关按钮属性,要在最后显示
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}



-(BOOL)testWithLine:(NSInteger)x withqueue:( NSInteger) y withNum:(NSString *) v
{
    NSInteger _x = x / K * K;
    NSInteger _y = y / K * K;
    //测试3 * 3矩阵内是否有重复的数
    for(NSInteger i = _x; i <=_x+K-1; i++)
        for(NSInteger j = _y; j <= _y + K-1; j++)
            if(arr[i][j] == v)//需要修改
                return false;
    //测试横向、纵向是否有重复的数
    //    此处为全盘扫描便于后面使用
    
    //    左
    for(int j = 0; j <=y-1; j++)
        if(arr[x][j] == v )
            return false;
    //    右
    for(NSInteger j = y+1; j <K*K; j++)
        if(arr[x][j] == v )
            return false;
    //    上
    for(NSInteger i=0;i<=x-1;i++)
        if(arr[i][y]==v)
            return false;
    //    下
    for(NSInteger i=x+1;i<K*K;i++)
        if(arr[i][y]==v)
            return false;
    return true;
    
    
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
