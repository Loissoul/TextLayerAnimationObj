//
//  AnimationShow.m
//  PoemObjcShow
//
//  Created by Lois_pan on 16/4/14.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

#import "PGQAnimationShow.h"

#define  windowY   40

@interface PGQAnimationShow()

//window背景
@property (nonatomic, strong) UIWindow * window;
//渐变色layer
@property (nonatomic, strong) CAGradientLayer * gradientLayer;
//字迹图层
@property (nonatomic, strong) CAShapeLayer * pathLayer;
//字迹动画的时间
@property (nonatomic, assign) NSTimeInterval textAnimationTime;
//window弹出动画的时间
@property (nonatomic, assign) NSTimeInterval windowTime;
//定时器
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation PGQAnimationShow

+ (PGQAnimationShow *)shareInstance {
    static  PGQAnimationShow * sharemanager = nil;
    if (sharemanager == nil){
        sharemanager = [[PGQAnimationShow alloc]init];
    }
    return sharemanager;
}

- (void)showWithMessage:(NSString *)messgae image:(UIImage *)image windowColor:(UIColor *)color {
    _gradientLayer = [[CAGradientLayer alloc] init];
    _pathLayer = [[CAShapeLayer alloc] init];
    _textAnimationTime = 2.0;
    _windowTime = 0.2;
    [self showWindowWithColor:color];
    [self addGradientLayer];
    [self addPathLayerWithMessage:messgae];
    _gradientLayer.mask = _pathLayer;
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(CGRectGetMinX(_pathLayer.frame) - 5 - imageView.image.size.width, 0, imageView.image.size.width, imageView.image.size.height );
    imageView.center = _window.center;
    [_window addSubview:imageView];
}

//Sucess
- (void)showSucessWithMessage:(NSString *)message backColor:(UIColor *)color {
    UIImage * image = [UIImage imageNamed:@""];
    [self showWithMessage:@"download sucessful" image:image windowColor:color];
}

//Loading
- (void)showLoadingWithMessage:(NSString *)message backColor:(UIColor *)color {
    [self showWithMessage:@"Loading" image:nil windowColor:color];
    [_timer invalidate];
    
    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicatorView startAnimating];
    
    activityIndicatorView.frame = CGRectMake(CGRectGetMinX(_pathLayer.frame) - 5 - activityIndicatorView.frame.size.width, 0, activityIndicatorView.frame.size.width, activityIndicatorView.frame.size.height);
    
    [_window addSubview:activityIndicatorView];
}

- (void)showWindowWithColor:(UIColor *)color {
    [_timer invalidate];
    _timer = nil;
    _window = [[UIWindow alloc] init];
    [_pathLayer removeAllAnimations];
    _window.windowLevel = UIWindowLevelAlert;
    _window.backgroundColor = color;
    [self.window makeKeyAndVisible];
    
    _window.frame   = CGRectMake(0, -windowY, [UIScreen mainScreen].bounds.size.width, windowY);
    
    [UIView animateWithDuration:_windowTime animations:^{
        _window.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, windowY);
    }];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_textAnimationTime+1 target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

//window hide
- (void)hide {
    [_timer invalidate];
    _timer = nil;
    if (_window) {
        [UIView animateWithDuration:_windowTime animations:^{
            _window.frame = CGRectMake(0, -windowY, [UIScreen mainScreen].bounds.size.width, windowY);
        } completion:^(BOOL finished) {
            _window = nil;
            [_pathLayer removeAllAnimations];
            [_gradientLayer removeAllAnimations];
        }];
    }
}

//Add GradientLayer
- (void)addGradientLayer {
    int count = 10;
    NSMutableArray * colors = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++) {
        UIColor * color = [UIColor colorWithRed:((200-10*i)/255.0) green:((200-10*i)/255.0) blue:((91-10*i)/255.0) alpha:1.0];
        [colors addObject:(id _Nonnull)color.CGColor];
    }
    
    _gradientLayer.startPoint = CGPointMake(0, 0.5);
    _gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    _gradientLayer.colors = colors;
    _gradientLayer.frame = _window.bounds;
    _gradientLayer.type = kCAGradientLayerAxial;
    [_window.layer addSublayer:_gradientLayer];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.duration = 0.5;
    animation.repeatCount = MAXFLOAT;
    
    NSMutableArray * toColors = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++) {
        
        UIColor * color = [UIColor colorWithRed:((24-2*i)/255.0) green:((24-2*i)/255.0) blue:((24-2*i)/255.0) alpha:1.0];
        [toColors addObject:(id _Nonnull)color.CGColor];
    }
    
    animation.autoreverses = YES;
    animation.toValue = toColors;
    [_gradientLayer addAnimation:animation forKey:@"gradientLayer"];
}


//添加pathlayer
- (void)addPathLayerWithMessage:(NSString *)message {
    UIBezierPath *textPath = [self bezierPathFrom:message];
    _pathLayer.bounds = CGPathGetBoundingBox(textPath.CGPath);
    _pathLayer.position = _gradientLayer.position;
    _pathLayer.geometryFlipped = YES;
    _pathLayer.path = textPath.CGPath;
    _pathLayer.fillColor = nil;
    _pathLayer.lineWidth = 1;
    _pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    
    CABasicAnimation * textAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    textAnimation.duration = _textAnimationTime;
    textAnimation.fromValue = [NSNumber numberWithFloat:0];
    textAnimation.toValue = [NSNumber numberWithFloat:1];
//    textAnimation.delegate = _window;
    
    [_pathLayer addAnimation:textAnimation forKey:@"strokeEnd"];
}

//绘制bezierPath
- (UIBezierPath *)bezierPathFrom:(NSString *)string {
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CTFontRef font = CTFontCreateWithName(CFSTR("SnellRoundhand"), 18.0f, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each run
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        // Get Font for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLyph in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            // Get path of outline
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    return path;
}



@end
