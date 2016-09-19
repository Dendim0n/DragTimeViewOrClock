//
//  ClockView.h
//  simpleClock
//
//  Created by 任岐鸣 on 16/9/16.
//  Copyright © 2016年 Ned. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragImageView.h"

@interface ClockView : UIView

@property (strong, nonatomic) DragImageView *hourHand;
@property (strong, nonatomic) DragImageView *minuteHand;

@property (strong, nonatomic) UIImageView *centerPlanet;

@end
