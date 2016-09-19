//
//  ViewController.m
//  simpleClock
//
//  Created by 任岐鸣 on 16/9/16.
//  Copyright © 2016年 Ned. All rights reserved.
//

#import "ViewController.h"
#import "ClockView.h"

@interface ViewController ()
@property (nonatomic, strong) ClockView *clockView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic , strong) UIStackView *addAlarmStack;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _clockView = [[ClockView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 50, 200, 200)];
    [_clockView setUserInteractionEnabled:YES];
    [self.view addSubview:_clockView];
    _clockView.backgroundColor = [UIColor clearColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ;
}

@end
