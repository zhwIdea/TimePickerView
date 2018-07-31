//
//  TimeQueryView.h
//  LocatorWatch
//
//  Created by hongwei Zheng on 2018/7/12.
//  Copyright © 2018年 hongwei Zheng. All rights reserved.
//  时间段查询

#import <UIKit/UIKit.h>

typedef void (^closeBlock) (UIButton *btn);

@interface TimeQueryView : UIView

//关闭按钮
@property(nonatomic,copy)closeBlock closeBtnBlock;

@end
