//
//  IHCollectionView.h
//  IHKit
//
//  Created by lm-zz on 05/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHCollectionView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (copy, nonatomic) void(^didSelectClick)(NSInteger index);
@property (nonatomic, strong)NSMutableArray *normalArray;
@property (nonatomic, strong)NSMutableArray *pressedArray;

@end
