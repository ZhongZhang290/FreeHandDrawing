//
//  IHCollectionView.m
//  IHKit
//
//  Created by lm-zz on 05/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import "IHCollectionView.h"
#import "IHCollectionViewFlowLayout.h"
#import "IHCollectionViewCell.h"

static NSString * const IHCollectionViewCellReuseIdentifier = @"IHCollectionViewCellReuseIdentifier";

@interface IHCollectionView()<IHColloctionViewCellProtocol>

@property (nonatomic, strong)UICollectionView *ihCollectionView;

@end

@implementation IHCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommonViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initCommonViews];
    }
    return self;
}

- (void)initCommonViews {
    IHCollectionViewFlowLayout* ihFlowLayout = [[IHCollectionViewFlowLayout alloc]init];
    ihFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _ihCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height) collectionViewLayout:ihFlowLayout];
    _ihCollectionView.delegate = self;
    _ihCollectionView.dataSource = self;
    _ihCollectionView.showsHorizontalScrollIndicator = NO;
    _ihCollectionView.backgroundColor = [UIColor clearColor];
    [_ihCollectionView registerClass:[IHCollectionViewCell class] forCellWithReuseIdentifier:IHCollectionViewCellReuseIdentifier];
    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_ihCollectionView addGestureRecognizer:longGesture];
    [self addSubview:_ihCollectionView];
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [_ihCollectionView indexPathForItemAtPoint:[longGesture locationInView:_ihCollectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [_ihCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [_ihCollectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:_ihCollectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [_ihCollectionView endInteractiveMovement];
            break;
        default:
            [_ihCollectionView cancelInteractiveMovement];
            break;
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //交换资源数组中移动item和目标位置item的资源位置
    [self.normalArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    [self.pressedArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IHCollectionViewCell *cell = (IHCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:IHCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    [cell.cellBtn setImage:self.normalArray[indexPath.row]  forState:UIControlStateNormal];
    [cell.cellBtn setImage:self.pressedArray[indexPath.row] forState:UIControlStateHighlighted];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 38);
}

#pragma mark - IHColloctionViewCellDelegate
- (void)addDataSource:(NSArray *)subData toOrgDataSource:(NSMutableArray *)orgData {
    for (NSObject *subObj in subData) {
        if ([orgData containsObject:subObj]) {
            continue;
        }
        [orgData addObject:subObj];
    }
}

#pragma mark CollectionViewDelegate
- (void)CollectionViewDidResponseWith:(NSInteger)index {
    if (self.didSelectClick) {
        self.didSelectClick(index);
    }
}

@end
