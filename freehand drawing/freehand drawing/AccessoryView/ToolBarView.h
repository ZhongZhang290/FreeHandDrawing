//
//  ToolBarView.h
//  freehand drawing
//
//  Created by lm-zz on 13/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ToolBarViewMessageType) {
    UIToolbarMessageTypeInputMethod = 0,
    UIToolbarMessageTypeSpace,
    UIToolbarMessageTypeEnter,
    UIToolbarMessageTypeDelete,
};

@protocol ToolBarViewDelegate <NSObject>

- (void)passMessageOutside:(ToolBarViewMessageType)msg_type;

@end

@interface ToolBarView : UIView

@property (nonatomic, weak) id<ToolBarViewDelegate> delegate;

@end
