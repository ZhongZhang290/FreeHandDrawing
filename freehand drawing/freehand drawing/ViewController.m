//
//  ViewController.m
//  freehand drawing
//
//  Created by lm-zz on 05/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import "ViewController.h"
#import "FreeHandDrawingView.h"

@interface ViewController ()

@property (nonatomic, strong) FreeHandDrawingView *freeHandDrawingView;

@end

@implementation ViewController

#pragma mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.freeHandDrawingView];
}

#pragma mark LazyLoading

- (FreeHandDrawingView *)freeHandDrawingView {
    if (!_freeHandDrawingView) {
        _freeHandDrawingView = [[FreeHandDrawingView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _freeHandDrawingView;
}


@end
