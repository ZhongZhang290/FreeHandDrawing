//
//  IHCollectionViewCell.h
//  IHKit
//
//  Created by lm-zz on 05/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IHCollectionViewCell;

@protocol IHColloctionViewCellProtocol <NSObject>

- (void)CollectionViewDidResponseWith:(NSInteger)index;

@end

@interface IHCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<IHColloctionViewCellProtocol> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIButton *cellBtn;

@end
