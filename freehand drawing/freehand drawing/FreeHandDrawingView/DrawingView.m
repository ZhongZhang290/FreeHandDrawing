//
//  DrawingView.m
//  freehand drawing
//
//  Created by lm-zz on 05/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import "DrawingView.h"

#define rad(angle) ((angle) / 180.0 * M_PI)

static const int offset = 15;
static const int maximumCharacterTimeIntercal = 6;
static const CGFloat expectedWidth = 45;

static const CGPoint mid_point(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

static const CGFloat rightRatio(CGFloat width) {
    return (CGFloat) {
        width / expectedWidth
    };
}

@interface DrawingView()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) CGPoint pathPoint;
@property (nonatomic, strong) dispatch_queue_t drawingQueue;
@property (nonatomic, strong) UIImage *drawingImg;
@property (nonatomic, strong) NSMutableArray *pointXArray;
@property (nonatomic, strong) NSMutableArray *pointYArray;
@property (nonatomic, assign) int timerCounter;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation DrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        [self initiateConstVar];
    }
    return self;
}

- (void)initiateConstVar {
    //贝塞尔曲线初始化
    _path = [UIBezierPath bezierPath];
    
    //变量初始化
    _timerCounter = 0;

    _pointXArray = [[NSMutableArray alloc]initWithCapacity:0];
    _pointYArray = [[NSMutableArray alloc]initWithCapacity:0];
   
    //配置线条属性
    _path.lineCapStyle = kCGLineCapSquare;
    _path.lineJoinStyle = kCGLineJoinRound;
    _path.lineWidth = 10.0f;
   
    //自定义queue
    _drawingQueue = dispatch_queue_create("drawingQueue", DISPATCH_QUEUE_CONCURRENT);
}

#pragma mark Re-Draw Layer
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();  //创建一块画布
    if (_path) {
        CGContextAddPath(context, _path.CGPath);
        CGContextSetLineWidth(context, _path.lineWidth);//设置线的宽度
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

#pragma mark UIResponser
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _pathPoint = [touch locationInView:self];
    [_path moveToPoint:_pathPoint];
   
    if (_timer) {
        [self stopTimer];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
   
    dispatch_async(_drawingQueue, ^{
        
        [_pointXArray addObject:[NSNumber numberWithFloat:location.x]];
        [_pointYArray addObject:[NSNumber numberWithFloat:location.y]];
        CGPoint midPoint = mid_point(_pathPoint, location);
        [_path addQuadCurveToPoint:midPoint controlPoint:_pathPoint];
        _pathPoint = [touch locationInView:self];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    });
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 
    _timerCounter = 0;
    [self startTimer];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

#pragma mark 截屏处理
- (void)snapshot {
    
    //整理所有轨迹点
    [self sortArray];
    
    NSNumber *minYNumber = [_pointYArray firstObject];
    NSNumber *minXNumber = [_pointXArray firstObject];
    NSNumber *maxYNumber = [_pointYArray lastObject];
    NSNumber *maxXNumber = [_pointXArray lastObject];
    CGFloat minY = minYNumber.floatValue;
    CGFloat minX = minXNumber.floatValue;
    CGFloat maxY = maxYNumber.floatValue;
    CGFloat maxX = maxXNumber.floatValue;
    
    //裁剪图片
    UIImage *image = [self imageCompressWithSimple:[self croppedImage:[self getImage] InRect:[self getRightDimensionWithFourPointsMinX:minX MaxX:maxX MinY:minY MaxY:maxY]]];
    
    if ([self.delegate respondsToSelector:@selector(deliverImageToVC:)]) {
        [self.delegate deliverImageToVC:image];
    }
    
    //清理数据
    [_path removeAllPoints];
    [self setNeedsDisplay];
    [_pointXArray removeAllObjects];
    [_pointYArray removeAllObjects];
}

#pragma mark -- Resize UIimage

//resize image to newSize and keeping its original aspect ratio
- (UIImage *)scaleImage:(UIImage *)image ToSize:(CGSize)newSize {
    
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / image.size.width;
    CGFloat aspectHeight = newSize.height / image.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    
    scaledImageRect.size.width = image.size.width * aspectRatio;
    scaledImageRect.size.height = image.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//resize image by ratio
- (UIImage*)imageCompressWithSimple:(UIImage*)image {
   
    CGFloat scale = rightRatio(self.frame.size.width);
    CGRect scaledImageRect = CGRectZero;
    
    scaledImageRect.size.width = image.size.width / scale;
    scaledImageRect.size.height = image.size.height / scale;
    UIGraphicsBeginImageContextWithOptions(scaledImageRect.size, NO, 0);
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  
    return scaledImage;
}

- (UIImage *)getImage {
    //这里有三个参数，分别是size、opaque和scale, size就是需要绘制的bitmap尺寸，scale是设置缩放值，其中需要主要的是opaque当为yes时是忽略bitmap中
    //alpha值，如果为NO，则bitmap必须处理透明情况
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    [self drawViewHierarchyInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGRect)getRightDimensionWithFourPointsMinX:(CGFloat)minX MaxX:(CGFloat)maxX MinY:(CGFloat)minY MaxY:(CGFloat)maxY {
    CGFloat fixedMinX = minX == 0 ? 0 : minX - offset;
    CGFloat fixedMinY = minY == 0 ? 0 : minY - offset;
    CGFloat fixedMaxX = maxX == 0 ? 0 : maxX + offset;
    CGFloat fixedMaxY = maxY == 0 ? 0 : maxY + offset;
    
    return  CGRectMake(fixedMinX, fixedMinY, fixedMaxX - fixedMinX, fixedMaxY - fixedMinY);
}

- (CGAffineTransform)orientationTransformedRectOfImage:(UIImage *)img {
    CGAffineTransform rectTransform;
    switch (img.imageOrientation)
    {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}

- (UIImage *)croppedImage:(UIImage*)orignialImage InRect:(CGRect)visibleRect {
    CGAffineTransform rectTransform = [self orientationTransformedRectOfImage:orignialImage];
    visibleRect = CGRectApplyAffineTransform(visibleRect, rectTransform);
    
    //crop image
    CGImageRef imageRef = CGImageCreateWithImageInRect([orignialImage CGImage], visibleRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:orignialImage.scale orientation:orignialImage.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (void)sortArray {
    [_pointXArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *item1 = obj1;
        NSNumber *item2 = obj2;
        return [item1 compare: item2];
    }];
    
    [_pointYArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *item1 = obj1;
        NSNumber *item2 = obj2;
        return [item1 compare: item2];
    }];
}

#pragma mark Timer
- (void)startTimer {
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [self timerCountRepeats];
    });
    dispatch_resume(_timer);
}

- (void)stopTimer {
    dispatch_cancel(_timer);
}

- (void)timerCountRepeats {
    _timerCounter ++;
    if (_timerCounter > maximumCharacterTimeIntercal) {
        [self snapshot];
        [self stopTimer];
    }
}

@end
