//
//  JXDPopView.h
//  JxdEimV2
//
//  Created by 金现代 on 2019/3/20.
//  Copyright © 2019 山东金现代. All rights reserved.
//

#import <UIKit/UIKit.h>
//屏幕宽度
#define kScreenWidth             [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define kScreenHeight            [[UIScreen mainScreen] bounds].size.height

#define iphoneX CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen]currentMode].size)

#define StatusBarAndNavigationBarHeight  (iphoneX ? 88.f : 64.f)


#define kSize(x)                 ((x) * kScreenWidth / 375)
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PopViewArrowDirection) {
    PopViewArrowDirectionLeft,
    PopViewArrowDirectionRight,
    PopViewArrowDirectionTop,
    PopViewArrowDirectionBottom
};

@interface JXDPopView : UIView
@property(nonatomic, strong)NSString *contentStr;

+ (JXDPopView *)createPopViewWithArrowPoint:(CGPoint)arrowPoint inView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END
