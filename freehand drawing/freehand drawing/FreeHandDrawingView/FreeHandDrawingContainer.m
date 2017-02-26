//
//  FreeHandDrawingContainer.m
//  freehand drawing
//
//  Created by lm-zz on 12/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import "FreeHandDrawingContainer.h"
#import "DrawingView.h"
#import "ToolBarView.h"
#import "UIColor+IH.h"

@interface FreeHandDrawingContainer()<DrawingViewProtocol, ToolBarViewDelegate>

@property (nonatomic, strong) ToolBarView *toolView;
@property (nonatomic, strong) DrawingView *drawingView;
@property (nonatomic, strong) UIView *freeHandDrawingBgView;

@end

@implementation FreeHandDrawingContainer


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor ih_colorWithRGB:0xe6e6e6];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    [self addSubview:self.toolView];
    [self addSubview:self.freeHandDrawingBgView];
    [self.freeHandDrawingBgView addSubview:[self createCustomImageView]];
    [self.freeHandDrawingBgView addSubview:self.drawingView];
}

- (UIImageView *)createCustomImageView {
    
    NSString *imagePathName = [NSString stringWithFormat:@"Resources.bundle/inputBackground.png"];
    UIImage *customBgImage = [UIImage imageNamed:imagePathName];
    
    UIImageView *customImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _freeHandDrawingBgView.frame.size.width, _freeHandDrawingBgView.frame.size.height)];
    [customImageView setImage:customBgImage];
    customImageView.userInteractionEnabled = YES;
    
    return customImageView;
}

#pragma mark setter 
- (ToolBarView *)toolView {
    if (!_toolView) {
        _toolView = [[ToolBarView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        _toolView.backgroundColor = [UIColor clearColor];
        _toolView.delegate = self;
    }
    return _toolView;
}

- (UIView *)freeHandDrawingBgView {
    if (!_freeHandDrawingBgView) {
        _freeHandDrawingBgView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_toolView.frame), _toolView.frame.size.width - 20, _toolView.frame.size.width - 20)];
        _freeHandDrawingBgView.backgroundColor = [UIColor whiteColor];
    }
    return _freeHandDrawingBgView;
}

- (DrawingView *)drawingView {
    if (!_drawingView) {
        _drawingView = [[DrawingView alloc]initWithFrame:CGRectMake(0, 0, _freeHandDrawingBgView.frame.size.width, _freeHandDrawingBgView.frame.size.width)];
        _drawingView.delegate = self;
        _drawingView.backgroundColor = [UIColor clearColor];
    }
    return _drawingView;
}

#pragma mark FreeHandDrawingViewDelegate
- (void)deliverImageToVC:(UIImage *)cropImage {
    if (self.imageBlock) {
        self.imageBlock(cropImage);
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark ToolBarDelegate
- (void)passMessageOutside:(ToolBarViewMessageType)msg_type {
    if (self.msgTypeBlock) {
        self.msgTypeBlock(msg_type);
    }
}

@end
