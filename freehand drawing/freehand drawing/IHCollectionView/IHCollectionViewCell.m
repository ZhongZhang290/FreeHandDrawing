//
//  IHCollectionViewCell.m
//  IHKit
//
//  Created by lm-zz on 05/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import "IHCollectionViewCell.h"

@interface IHCollectionViewCell()

@end

@implementation IHCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        [self initCommonViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _cellBtn.frame = self.bounds;
}

- (void)initCommonViews {
    self.cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cellBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_cellBtn addTarget:self action:@selector(onCellClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cellBtn];
}

- (void)onCellClicked {
    if ([self.delegate respondsToSelector:@selector(CollectionViewDidResponseWith:)]) {
        [self.delegate CollectionViewDidResponseWith:self.indexPath.item];
    }
}

@end
