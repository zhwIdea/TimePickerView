//
//  TimeQueryView.m
//  LocatorWatch
//
//  Created by hongwei Zheng on 2018/7/12.
//  Copyright © 2018年 hongwei Zheng. All rights reserved.
//

#import "TimeQueryView.h"
#import "Masonry.h"
@interface TimeQueryView(){
    UIView        *popView;
    UIDatePicker  *datePickerView;
    UIView        *whiteView;
    NSString      *dateString;
    UILabel       *startTimeLab;//开始日期
    UILabel       *endTimeLab;//结束日期
    BOOL isSelect; //判断选择起始时间和截止时间
}
@end

@implementation TimeQueryView



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self popView];
    }
    return self;
}


//关闭按钮
-(void)closeBtn:(UIButton *)btn{
    if (self.closeBtnBlock) {
        self.closeBtnBlock(btn);
    }
}

#pragma mark ==== 选择起始日期 ====
-(void)startBtn:(UIButton *)sender{
    [self initDatePicker];
    isSelect = YES;
}

#pragma mark ==== 选择结束日期 ====
-(void)endBtn:(UIButton *)sender{
    [self initDatePicker];
    isSelect = NO;
}

#pragma mark =========== 取消日期 =========
-(void)cancelBtn:(UIButton *)btn{
    [whiteView removeFromSuperview];
    [datePickerView removeFromSuperview];
}


#pragma mark =========== 确定日期 =========
-(void)sureBtn:(UIButton *)btn{
    [whiteView removeFromSuperview];
    [datePickerView removeFromSuperview];
   
    //获取当天的时间
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";
    NSTimeZone *nowZone1=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:nowZone1];
    NSString  *timeStr1=[formatter stringFromDate:nowDate];
    
    //设置选中的时间格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateString = [dateFormatter stringFromDate:datePickerView.date];
  //  NSLog(@"dateString==== %@",dateString);
    
    NSDate *toadyDate = [dateFormatter dateFromString:timeStr1];
    NSLog(@"toadyDate=======:%@",toadyDate);
    
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
   //比较当天时间和选择的时间
    NSDateComponents *cmps = [calendar components:unit fromDate:toadyDate toDate:datePickerView.date options:0];
    //NSLog(@"选择时间:%@",cmps);
    if (cmps.year>0 ||cmps.month>0 || cmps.day>0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能选择未来的时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
       NSLog(@"dateString==== %@",dateString);
        if (isSelect) {
            //起始日期
            startTimeLab.text = dateString;
        }else{
            //开始日期
            endTimeLab.text = dateString;
        }
    }
    
    
}

#pragma mark  ==== 查询 ====
-(void)queryBtn:(UIButton *)sender{
    if (startTimeLab.text.length == 0 || endTimeLab.text.length == 0) {
        if (startTimeLab.text.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择起始日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择结束日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginDate = [inputFormatter dateFromString:startTimeLab.text];
    NSDate *endDate = [inputFormatter dateFromString:endTimeLab.text];
    NSLog(@"起始时间 = %@,截止时间 = %@ ", beginDate,endDate);
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *cmps = [calendar components:unit fromDate:beginDate toDate:endDate options:0];
    NSLog(@"cmps==== %@",cmps);
    
    if (cmps.year < 0 || cmps.month < 0 || cmps.day < 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"起始日期不能大于结束日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        NSLog(@"开始查询=======");
    }
    
}


#pragma mark ========= 时间选择器 ==========
-(void)initDatePicker{
    datePickerView  = [[UIDatePicker alloc]init];
    datePickerView.frame = CGRectMake(0, 100, self.frame.size.width, 160);
    datePickerView.backgroundColor = [UIColor lightGrayColor];
    [popView addSubview:datePickerView];
    datePickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    // 设置当前显示时间
    [datePickerView setDate:[NSDate date] animated:YES];
    
    //白色容器view
    whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview: whiteView];
    [whiteView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(datePickerView.mas_top);
        make.left.right.mas_equalTo(datePickerView);
        make.height.mas_equalTo(35);
    }];
    
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [whiteView  addSubview:cancelBtn];
 
    //确定
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [whiteView  addSubview:sureBtn];
  
   
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView .mas_left).offset(15) ;
        make.centerY.mas_equalTo(whiteView .mas_centerY);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(whiteView.mas_centerY);
        make.right.mas_equalTo(whiteView.mas_right).offset(-15);
    }];
    
}




-(void)popView{
    popView = [[UIView alloc] init];
    popView.backgroundColor = [UIColor whiteColor];
    popView.frame = self.bounds;
    popView.layer.cornerRadius = 3;
    [self addSubview:popView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"时间段查询";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [popView addSubview:titleLabel];
    
    //关闭按钮
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"timeClose"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [popView addSubview:lineView];
    
    //起始日期
    UILabel *startLab = [[UILabel alloc] init];
    startLab.text = @"起始日期:";
    startLab.textColor = [UIColor blackColor];
    startLab.font = [UIFont systemFontOfSize:13];
    [popView addSubview:startLab];
    
    UIButton *startBtn = [[UIButton alloc] init];
    startBtn.layer.cornerRadius = 6;
    startBtn.layer.borderWidth = 1;
    startBtn.tag = 20;
    startBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [startBtn addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:startBtn];
    
    startTimeLab = [[UILabel alloc] init];
    startTimeLab.textColor = [UIColor blackColor];
    startTimeLab.font = [UIFont systemFontOfSize:12];
    [startBtn addSubview:startTimeLab];
    
    UIImageView *staRightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JTDown"]];
    [startBtn addSubview:staRightImg];
    
    //结束日期
    UILabel *endLab = [[UILabel alloc] init];
    endLab.text = @"结束日期:";
    endLab.textColor = [UIColor blackColor];
    endLab.font = [UIFont systemFontOfSize:13];
    [popView addSubview:endLab];
    
    UIButton *endBtn = [[UIButton alloc] init];
    endBtn.layer.cornerRadius = 6;
    endBtn.layer.borderWidth = 1;
    endBtn.tag = 21;
    endBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [endBtn addTarget:self action:@selector(endBtn:) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:endBtn];
    
    endTimeLab = [[UILabel alloc] init];
    endTimeLab.textColor = [UIColor blackColor];
    endTimeLab.font = [UIFont systemFontOfSize:12];
    [startBtn addSubview:endTimeLab];
    
    UIImageView *endRightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JTDown"]];
    [endBtn addSubview:endRightImg];
    
    //查询
    UIButton *queryBtn = [[UIButton alloc] init];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    queryBtn.titleLabel.textColor = [UIColor whiteColor];
    [queryBtn addTarget:self action:@selector(queryBtn:) forControlEvents:UIControlEventTouchUpInside];
    queryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    queryBtn.backgroundColor = [UIColor blueColor];
    queryBtn.layer.cornerRadius = 12;
    [popView addSubview:queryBtn];
   
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popView.mas_top).offset(10);
        make.centerX.equalTo(popView.mas_centerX);
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(popView.mas_top).offset(10);
       make.right.equalTo(popView.mas_right).offset(-15);
       make.size.mas_equalTo(CGSizeMake(20, 14));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(popView);
        make.height.mas_equalTo(@0.5);
    }];
    [startLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(25);
        make.left.equalTo(popView.mas_left).offset(50);
    }];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startLab.mas_right).offset(15);
        make.centerY.equalTo(startLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    [startTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startBtn.mas_left).offset(8);
        make.centerY.equalTo(startBtn.mas_centerY);
    }];
    [staRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(startBtn.mas_right).offset(-5);
        make.centerY.equalTo(startBtn.mas_centerY);
    }];
    [endLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(startLab.mas_bottom).offset(30);
        make.left.equalTo(popView.mas_left).offset(50);
    }];
    [endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endLab.mas_right).offset(15);
        make.centerY.equalTo(endLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    [endTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endBtn.mas_left).offset(8);
        make.centerY.equalTo(endBtn.mas_centerY);
    }];
    [endRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(endBtn.mas_right).offset(-5);
        make.centerY.equalTo(endBtn.mas_centerY);
    }];
    [queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(popView.mas_bottom).offset(-18);
        make.centerX.equalTo(popView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70,30));
    }];
    
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
