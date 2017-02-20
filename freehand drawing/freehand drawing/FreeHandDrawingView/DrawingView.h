//
//  DrawingView.h
//  freehand drawing
//
//  Created by lm-zz on 05/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawingViewProtocol <NSObject>

- (void)deliverImageToVC:(UIImage *)cropImage;

@end

@interface DrawingView : UIView

@property (nonatomic, weak)id<DrawingViewProtocol> delegate;

@end
