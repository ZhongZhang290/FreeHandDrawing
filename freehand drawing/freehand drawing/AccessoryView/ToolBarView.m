//
//  ToolBarView.m
//  freehand drawing
//
//  Created by lm-zz on 13/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import "ToolBarView.h"
#import "IHCollectionView.h"
#import "DXPopover.h"

static const NSInteger Kkeyboard = 0;
static const NSInteger Kspace = 1;
static const NSInteger Kenter = 2;
static const NSInteger Kcolor = 3;
static const NSInteger Kpen = 4;
static const NSInteger Kdelete = 5;

@interface ToolBarView()

@property (nonatomic, strong)IHCollectionView *collectionView;
@property (nonatomic, strong)DXPopover *lineWidthView;

@end

@implementation ToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    [self addSubview:self.collectionView];
    [self createBtnsImage];
    
}

#pragma mark setter
- (IHCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[IHCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _collectionView.backgroundColor = [UIColor clearColor];
        __weak __typeof(self)weakSelf = self;
        _collectionView.didSelectClick = ^(NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf collectionViewDidResponseWithIndex:index];
        };
    }
    return _collectionView;
}

- (DXPopover *)lineWidthView {
    if (!_lineWidthView) {
        _lineWidthView = [DXPopover popover];
    }
    return _lineWidthView;
}

#pragma mark Private API

- (void)createBtnsImage {
    
    NSMutableArray *normalImageArrays = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray *pressedImageArrays = [[NSMutableArray alloc]initWithCapacity:0];
    
    UIImage *keyboardNormal = [UIImage imageNamed:@"Resources.bundle/keyboardBtnNormal.png"];
    UIImage *keyboardPressed = [UIImage imageNamed:@"Resources.bundle/keyboardBtnPressed.png"];
    
    UIImage *spaceNormal = [UIImage imageNamed:@"Resources.bundle/spaceBtnNormal.png"];
    UIImage *spacePressed = [UIImage imageNamed:@"Resources.bundle/spaceBtnPressed.png"];
    
    UIImage *enterNormal = [UIImage imageNamed:@"Resources.bundle/enterBtnNormal.png"];
    UIImage *enterPressed = [UIImage imageNamed:@"Resources.bundle/enterBtnPressed.png"];
    
    UIImage *colorNormal = [UIImage imageNamed:@"Resources.bundle/colorBtnNormal.png"];
    UIImage *colorPressed = [UIImage imageNamed:@"Resources.bundle/colorBtnPressed.png"];
    
    UIImage *penNormal = [UIImage imageNamed:@"Resources.bundle/penBtnNormal.png"];
    UIImage *penPressed = [UIImage imageNamed:@"Resources.bundle/penBtnPressed.png"];
    
    UIImage *deleteNormal = [UIImage imageNamed:@"Resources.bundle/deleteBtnNormal.png"];
    UIImage *deletePressed = [UIImage imageNamed:@"Resources.bundle/deleteBtnPressed.png"];
    
//    UIImage *commaNormal = [UIImage imageNamed:@"Resources.bundle/commaNormal.png"];
//    UIImage *commaPressed = [UIImage imageNamed:@"Resources.bundle/commaPressed.png"];
//    
//    UIImage *periodNormal = [UIImage imageNamed:@"Resources.bundle/periodNormal.png"];
//    UIImage *periodPressed = [UIImage imageNamed:@"Resources.bundle/periodPressed.png"];
    
    [normalImageArrays addObject:keyboardNormal];
    [pressedImageArrays addObject:keyboardPressed];
   
    [normalImageArrays addObject:spaceNormal];
    [pressedImageArrays addObject:spacePressed];
    
    [normalImageArrays addObject:enterNormal];
    [pressedImageArrays addObject:enterPressed];
    
    [normalImageArrays addObject:colorNormal];
    [pressedImageArrays addObject:colorPressed];
    
    [normalImageArrays addObject:penNormal];
    [pressedImageArrays addObject:penPressed];
    
    [normalImageArrays addObject:deleteNormal];
    [pressedImageArrays addObject:deletePressed];
    
//    [normalImageArrays addObject:commaNormal];
//    [pressedImageArrays addObject:commaPressed];
//    
//    [normalImageArrays addObject:periodNormal];
//    [pressedImageArrays addObject:periodPressed];
    
    [_collectionView setNormalArray:normalImageArrays];
    [_collectionView setPressedArray:pressedImageArrays];
}

- (void)collectionViewDidResponseWithIndex:(NSInteger)index {
    switch (index) {
        case Kkeyboard:
            [self crateMsg:UIToolbarMessageTypeInputMethod];
            break;
        case Kspace:
            [self crateMsg:UIToolbarMessageTypeSpace];
            break;
        case Kenter:
            [self crateMsg:UIToolbarMessageTypeEnter];
            break;
        case Kcolor:
            
            break;
        case Kpen:{
            
            UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
            newView.backgroundColor = [UIColor redColor];
            
            [self.lineWidthView showAtPoint:CGPointMake(50, 100) popoverPostion:DXPopoverPositionUp withContentView:newView inView:[[UIApplication sharedApplication].delegate window]];
        }
            break;
        case Kdelete:
            [self crateMsg:UIToolbarMessageTypeDelete];
            break;
            
        default:
            break;
    }
}

- (void)crateMsg:(NSInteger)msg_type {
    if ([self.delegate respondsToSelector:@selector(passMessageOutside:)]) {
        [self.delegate passMessageOutside:msg_type];
    }
}


@end

