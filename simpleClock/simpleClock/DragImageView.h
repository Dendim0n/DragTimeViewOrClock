//
//  DragImageView.h
//  simpleClock
//
//  Created by 任岐鸣 on 16/9/16.
//  Copyright © 2016年 Ned. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragImageView : UIImageView
{
    CGPoint startLocation;
}

@property (nonatomic) NSInteger radius;
@property (nonatomic,copy) dispatch_block_t dragBeganBlock;
@property (nonatomic,copy) dispatch_block_t dragBlock;
@property (nonatomic,copy) dispatch_block_t dragEndedBlock;
@property (nonatomic) NSInteger time;
@end
