//
//  DragImageView.m
//  simpleClock
//
//  Created by 任岐鸣 on 16/9/16.
//  Copyright © 2016年 Ned. All rights reserved.
//

#import "DragImageView.h"

#define kMinuteHandLength 90.0
#define kHourHandLength 70.0

@interface DragImageView()



@end


@implementation DragImageView

- (id) initWithImage: (UIImage *) anImage
{
    if (self = [super initWithImage:anImage])
        self.userInteractionEnabled = YES;
    _radius = 0;
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Calculate and store offset, and pop view into front if needed
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
    if (_dragBeganBlock) {
        self.dragBeganBlock();
    }
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint centerInSuperView = CGPointMake(self.superview.bounds.size.width / 2, self.superview.bounds.size.height / 2);
    
    // Calculate offset
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGPoint ptInSuperView = [[touches anyObject] locationInView:self.superview];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);

    // Bound movement into parent bounds
    float halfx = CGRectGetMidX(self.bounds);
    newcenter.x = MAX(halfx, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);

//    if (_radius != 0) {
//        double currentRadius = sqrt((newcenter.x - centerInSuperView.x) * (newcenter.x - centerInSuperView.x) + (newcenter.y - centerInSuperView.y) * (newcenter.y - centerInSuperView.y));
//        double newRatio = currentRadius / 50.0;
//        double newX = (newcenter.x - centerInSuperView.x) / newRatio + newcenter.x;
//        double newY = (newcenter.y - centerInSuperView.y) / newRatio + newcenter.y;
//        newcenter.x = newX;
//        newcenter.y = newY;
//    }
    
    if (_radius != 0) {
        double currentRadius = sqrt(pow((ptInSuperView.x - centerInSuperView.x),2) + pow((ptInSuperView.y - centerInSuperView.y),2));
        
        double currentDX = ptInSuperView.x - centerInSuperView.x;
        double currentDY = ptInSuperView.y - centerInSuperView.y;
        
        
        
        double newX = _radius * currentDX/currentRadius + centerInSuperView.x;
        
        double newY = _radius * currentDY/currentRadius + centerInSuperView.y;
        
        NSLog(@"%f",currentRadius);
        newcenter.x = newX;
        newcenter.y = newY;
        
        _time = asin(currentDX/currentRadius) / (2 * M_PI) * 60;
        
        if (newX > centerInSuperView.x && newY > centerInSuperView.y) {
            _time = -_time;
            _time += 30; //15~30
        } else if (newX > centerInSuperView.x && newY < centerInSuperView.y) {
            //do nothing //0~15
        } else if (newX < centerInSuperView.x && newY < centerInSuperView.y) {
            _time += 60; //45~60
        } else if (newX < centerInSuperView.x && newY > centerInSuperView.y) {
            _time = -_time;
            _time += 30; //30~45
        }
        
        if (_dragBlock) {
            self.dragBlock();
        }
    }

    
    // Set new location
    self.center = newcenter;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_dragEndedBlock) {
        self.dragEndedBlock();
    }
}
@end
