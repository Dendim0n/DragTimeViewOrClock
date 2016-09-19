//
//  ClockView.m
//  simpleClock
//
//  Created by 任岐鸣 on 16/9/16.
//  Copyright © 2016年 Ned. All rights reserved.
//

#import "ClockView.h"

#define kMinuteHandLength 90.0
#define kHourHandLength 70.0

#define selfRect CGRectMake(0,0,self.frame.size.width,self.frame.size.height)

#define selfCenter CGPointMake(self.frame.size.width / 2,self.frame.size.width / 2)

#define WEAKSELF  __weak __typeof(self)weakSelf = self;

@interface ClockView()

@property (nonatomic , strong) NSTimer *clockTimer;

@property (nonatomic) CGPoint centerPoint;
@property (atomic) NSInteger hour;
@property (atomic) NSInteger minute;
@property (atomic) NSInteger second;

@property (atomic,strong) UILabel *timeLabel;

@end

@implementation ClockView

static inline NSInteger getSecondMinusOne(NSInteger second) {
    if (second == 0) {
        return 59;
    } else {
        return second - 1;
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setClock];
        _centerPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    }
    return self;
}

-(void)setClock{
    
    [self drawCircle];
    
    _minuteHand = [[DragImageView alloc] initWithImage:[UIImage imageNamed:@"Planet1_smallYel"]];
    _minuteHand.radius = kMinuteHandLength;
    _hourHand = [[DragImageView alloc] initWithImage:[UIImage imageNamed:@"Planet1_smallBlue"]];
    _hourHand.radius = kHourHandLength;
    _centerPlanet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Planet1_BigYel"]];
    [_centerPlanet setUserInteractionEnabled:YES];
    
    [self addSubview:_centerPlanet];
    [self addSubview:_minuteHand];
    [self addSubview:_hourHand];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _timeLabel.center = selfCenter;
    _timeLabel.numberOfLines = 0;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor grayColor];
    [self addSubview:_timeLabel];
    
    WEAKSELF
    _minuteHand.dragBeganBlock = ^{
        [weakSelf.clockTimer invalidate];
    };
    _hourHand.dragBeganBlock = _minuteHand.dragBeganBlock;
    _minuteHand.dragBlock = ^{
        _timeLabel.text = [NSString stringWithFormat: @"%d:%d:%d",_hour,_minute,weakSelf.minuteHand.time];
    };
    _hourHand.dragBlock = ^{
        _timeLabel.text = [NSString stringWithFormat: @"%d:%d:%d",_hour,weakSelf.hourHand.time,_second];
    };

    _minuteHand.dragEndedBlock = ^{
        
        //        double startAngle,endAngle;
        //        startAngle = (2 * M_PI) / 60 * getSecondMinusOne(_hourHand.time) - M_PI_2;
        //        endAngle = (2 * M_PI) / 60 * getSecondMinusOne(_second) - M_PI_2;
        //
        //        UIBezierPath *path = [UIBezierPath bezierPath];
        //        [path addArcWithCenter:_centerPoint radius:kMinuteHandLength startAngle:startAngle endAngle:endAngle clockwise:(endAngle - startAngle) < M_PI];
        //
        //        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        //        pathAnimation.calculationMode = kCAAnimationPaced;
        //        pathAnimation.fillMode = kCAFillModeForwards;
        //        pathAnimation.removedOnCompletion = NO;
        //        pathAnimation.duration = 0.1;
        //        pathAnimation.repeatCount = 0;
        //        pathAnimation.path = path.CGPath;
        //        [_minuteHand.layer addAnimation:pathAnimation forKey:@"hourPath"];
        NSDate *currentTime = [NSDate date];
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
        comps = [currentCalendar components:unitFlags fromDate:currentTime];
        
        NSInteger second = [comps second];
        NSInteger minute = [comps minute];
        NSInteger hour = [comps hour];
        [weakSelf setTime:hour Minute:minute Second:second Animatable:NO];
        
        weakSelf.clockTimer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(getCurrentTime) userInfo:nil repeats:99999];
        
        [[NSRunLoop currentRunLoop]addTimer:weakSelf.clockTimer forMode:NSDefaultRunLoopMode];
    };
    
    _hourHand.dragEndedBlock = _minuteHand.dragEndedBlock;
    
    _centerPlanet.frame = CGRectMake(self.frame.size.width / 2 - 35, self.frame.size.height / 2 - 35, 70, 70);
    _minuteHand.frame = CGRectMake(20, 20, 18, 18);
    _minuteHand.contentMode = UIViewContentModeCenter;
    _hourHand.frame = CGRectMake(40, 40, 17, 17);
    _minuteHand.center = selfCenter;
    _hourHand.center = selfCenter;
    
    _clockTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(getCurrentTime) userInfo:nil repeats:99999];
    
    [[NSRunLoop currentRunLoop]addTimer:_clockTimer forMode:NSDefaultRunLoopMode];
}

-(void)getCurrentTime{
    NSDate *currentTime = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    comps = [currentCalendar components:unitFlags fromDate:currentTime];
    
    NSInteger second = [comps second];
    NSInteger minute = [comps minute];
    NSInteger hour = [comps hour];
    
    NSLog(@"%ld : %ld : %ld",(long)hour,(long)minute,(long)second);
    
    
    [self setTime:hour Minute:minute Second:second Animatable:YES];
}
-(void)setTime:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second Animatable:(BOOL)animatable{
    
    _second = second;
    _hour = hour;
//    if (!_hourHand.dragBlock) {
        _minute = minute;
//    }
    
    _timeLabel.text = [NSString stringWithFormat: @"%d:%d:%d",_hour,_minute,_second];
    
    double dx_Second,dy_Second,dx_Minute,dy_Minute;
    
    dx_Second = kMinuteHandLength * cos((2 * M_PI) / 60 * getSecondMinusOne(second) - M_PI_2);
    dy_Second = kMinuteHandLength * sin((2 * M_PI) / 60 * getSecondMinusOne(second) - M_PI_2);
    
    dx_Minute = kHourHandLength * cos((2 * M_PI) / 60 * getSecondMinusOne(minute) - M_PI_2);
    dy_Minute = kHourHandLength * sin((2 * M_PI) / 60 * getSecondMinusOne(minute) - M_PI_2);
    //    NSLog(@"dx:%f,dy:%f",dx_Second,dy_Second);
    if (animatable) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear animations:^{
            _minuteHand.center = CGPointMake(self.center.x + dx_Second - self.frame.origin.x, self.center.y + dy_Second - self.frame.origin.y);
            _hourHand.center = CGPointMake(self.center.x + dx_Minute - self.frame.origin.x, self.center.y + dy_Minute - self.frame.origin.y);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        _minuteHand.center = CGPointMake(self.center.x + dx_Second - self.frame.origin.x, self.center.y + dy_Second - self.frame.origin.y);
        _hourHand.center = CGPointMake(self.center.x + dx_Minute - self.frame.origin.x, self.center.y + dy_Minute - self.frame.origin.y);
    }
}
-(void)drawCircle{
    
    CGRect frame = selfRect;
    frame.origin = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    CAShapeLayer *hourLayer = [CAShapeLayer layer];
    
    hourLayer.frame = frame;
    //    hourLayer.position = ;
    hourLayer.strokeColor = [UIColor yellowColor].CGColor;
    hourLayer.fillColor = [UIColor clearColor].CGColor;
    hourLayer.lineWidth = 2.0f;
    CAShapeLayer *minuteLayer = [CAShapeLayer layer];
    minuteLayer.frame = frame;
    minuteLayer.strokeColor = [UIColor blueColor].CGColor;
    minuteLayer.fillColor = [UIColor clearColor].CGColor;
    minuteLayer.lineWidth = 2.0f;
    
    UIBezierPath *hourCircle = [UIBezierPath bezierPath];
    //    [hourCircle moveToPoint:_centerPoint];
    [hourCircle addArcWithCenter:_centerPoint radius:kHourHandLength startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    UIBezierPath *minuteCircle = [UIBezierPath bezierPath];
    //    [minuteCircle moveToPoint:_centerPoint];
    [minuteCircle addArcWithCenter:_centerPoint radius:kMinuteHandLength startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    hourLayer.path = hourCircle.CGPath;
    minuteLayer.path = minuteCircle.CGPath;
    
    hourLayer.strokeStart = 0;
    hourLayer.strokeEnd = 1;
    
    minuteLayer.strokeStart = 0;
    minuteLayer.strokeEnd = 1.0f;
    
    [self.layer addSublayer:hourLayer];
    [self.layer addSublayer:minuteLayer];
}

@end
