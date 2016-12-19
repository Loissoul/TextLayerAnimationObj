//
//  AnimationShow.h
//  PoemObjcShow
//
//  Created by Lois_pan on 16/4/14.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface PGQAnimationShow : NSObject

+ (PGQAnimationShow *)shareInstance;

- (void)showWithMessage:(NSString *)messgae
                  image:(UIImage *)image
            windowColor:(UIColor *)color;

- (void)showSucessWithMessage:(NSString *)message backColor:(UIColor *)color;
- (void)showLoadingWithMessage:(NSString *)message backColor:(UIColor *)color;

@end
