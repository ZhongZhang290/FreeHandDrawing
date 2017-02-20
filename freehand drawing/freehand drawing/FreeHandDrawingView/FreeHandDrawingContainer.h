//
//  FreeHandDrawingContainer.h
//  freehand drawing
//
//  Created by lm-zz on 12/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeHandDrawingContainer : UIView

@property (copy, nonatomic) void(^imageBlock)(UIImage *);
@property (copy, nonatomic) void(^msgTypeBlock)(NSInteger);

@end
