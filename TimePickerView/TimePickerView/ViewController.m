//
//  ViewController.m
//  TimePickerView
//
//  Created by hongwei Zheng on 2018/7/31.
//  Copyright © 2018年 hongwei Zheng. All rights reserved.
//

#import "ViewController.h"
#import "TimeQueryView.h"

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property(nonatomic,strong)UIView        *maskView;
@property(nonatomic,strong)TimeQueryView *queryView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createQueryBtn];
}

//添加遮罩
-(void)createMaskView{
    _maskView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.6;
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap)];
    [_maskView addGestureRecognizer:tap];
}


#pragma mark === 点击空白处、移除遮罩和弹框 ===
-(void)maskTap{
    [self.maskView removeFromSuperview];
    [self.queryView removeFromSuperview];
    self.maskView = nil;
    self.queryView = nil;
}


#pragma mark ==== 时间段查询 ====
-(void)queryBtn:(UIButton *)sender{
    //加载遮罩
    [self createMaskView];
    //加载时间段弹出框
    _queryView = [[TimeQueryView alloc] initWithFrame:CGRectMake(15, kHeight - 260, kWidth - 30, 260)];
    [[UIApplication sharedApplication].keyWindow addSubview:_queryView];
    WS(weakSelf);
    //点击关闭按钮、移除遮罩和弹框
    _queryView.closeBtnBlock = ^(UIButton *btn) {
        [weakSelf.maskView removeFromSuperview];
        [weakSelf.queryView removeFromSuperview];
        weakSelf.maskView = nil;
        weakSelf.queryView = nil;
    };
}



#pragma mark ==== 时间段查询 ====
-(void)createQueryBtn{
    UIButton *queryBtn = [[UIButton alloc] init];
    queryBtn.layer.cornerRadius = 5;
    queryBtn.frame = CGRectMake(130, 200, 100, 40);
    queryBtn.backgroundColor = [UIColor blueColor];
    [queryBtn setTitle:@"时间段查询" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    queryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [queryBtn addTarget:self action:@selector(queryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryBtn];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
