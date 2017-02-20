//
//  FreeHandDrawingView.m
//  freehand drawing
//
//  Created by lm-zz on 20/02/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import "FreeHandDrawingView.h"
#import "FreeHandDrawingContainer.h"

@interface FreeHandDrawingView()

@property (nonatomic, strong) UITextView *ihTextView;
@property (nonatomic, strong) FreeHandDrawingContainer *containerView;

@end

@implementation FreeHandDrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.ihTextView];
    }
    return self;
}

- (UIView*)ihTextView {
    if (!_ihTextView) {
        _ihTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _ihTextView.backgroundColor = [UIColor whiteColor];
        _ihTextView.font = [UIFont systemFontOfSize:45.0f];
        _ihTextView.inputView = self.containerView;
        _ihTextView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - self.containerView.frame.size.height);
        _ihTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _ihTextView.layer.borderWidth = 0.5f;
    }
    return _ihTextView;
}

- (FreeHandDrawingContainer *)containerView {
    if (!_containerView) {
        _containerView = [[FreeHandDrawingContainer alloc]initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width - 70), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width + 70)];
        
        //配置block回调
        __weak __typeof(self)weakSelf = self;
        _containerView.imageBlock = ^(UIImage *image) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf insertImageToTextView:image];
        };
        
        _containerView.msgTypeBlock = ^(NSInteger msgType) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (msgType == 3) {
                [strongSelf deleteCharactersInTextView];
            } else if (msgType == 1) {
                [strongSelf addASpaceIntoTextView];
            } else if (msgType == 2) {
                [strongSelf startANewLine];
            } else if (msgType == 0) {
                [strongSelf dismissDIYKeyboard];
            }
        };
    }
    return _containerView;
}

#pragma mark Private API
- (void)keepTextViewCursorUpTpDate {
    self.ihTextView.selectedRange = NSMakeRange(self.ihTextView.selectedRange.location + 1, 0);
}

- (void)insertImageToTextView:(UIImage *)image {
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    //使该图片始终居中
    textAttachment.bounds = CGRectMake(0, (scaledImageHeight - image.size.height) / 2, image.size.width, image.size.height);
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [self.ihTextView.textStorage insertAttributedString:attrStringWithImage atIndex:self.ihTextView.selectedRange.location];
    [self keepTextViewCursorUpTpDate];
}

- (void)deleteCharactersInTextView {
    if (self.ihTextView.selectedRange.location > 0) {
        [self.ihTextView.textStorage deleteCharactersInRange:NSMakeRange(self.ihTextView.selectedRange.location - 1, 1)];
        [self keepTextViewCursorUpTpDate];
    }
}

- (void)addASpaceIntoTextView {
    NSString *saveString = @"   ";
    [self.ihTextView insertText:saveString];
}

- (void)startANewLine {
    NSString *saveString = @"\n";
    [self.ihTextView insertText:saveString];
}

- (void)dismissDIYKeyboard {
    [self.ihTextView resignFirstResponder];
}

@end
