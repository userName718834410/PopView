//
//  ViewController.m
//  PopViewDemo
//
//  Created by 金现代 on 2019/3/20.
//  Copyright © 2019 王广法. All rights reserved.
//

#import "ViewController.h"
#import "PopView/JXDPopView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.x< 10 || 10 >kScreenWidth-point.x || point.y < 10 || kScreenHeight-point.y< 10) {
        return;
    }
    JXDPopView *popView = [JXDPopView createPopViewWithArrowPoint:point inView:self.view];
    popView.contentStr = @"做梦也想不到我把信写到五线谱上吧？五线谱是偶然来的，你也是偶然来的。不过我给你的信值得写在五线谱里呢。但愿我和你，是一支唱不完的歌。";
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
}
- (NSData *)fun{
    dispatch_semaphore_t match_sema;
    NSData *data;
    match_sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_semaphore_signal(match_sema);
    });
    dispatch_semaphore_wait(match_sema, DISPATCH_TIME_FOREVER);
    return data;
}
@end
