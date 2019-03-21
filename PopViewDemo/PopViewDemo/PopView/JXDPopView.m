//
//  JXDPopView.m
//  JxdEimV2
//
//  Created by 金现代 on 2019/3/20.
//  Copyright © 2019 山东金现代. All rights reserved.
//

#import "JXDPopView.h"

@interface JXDPopView ()
@property(nonatomic, strong)UILabel *popContent;
@property(nonatomic, strong)UIScrollView *popBackView;
@property(nonatomic, assign)CGPoint arrowPoint;
@property(nonatomic, strong)UIView *arrowView;
@property(nonatomic, assign)PopViewArrowDirection arrowDirection;

#define popViewCornerRadius 5.f
#define arrowHeight 10.f
#define popViewBackColor [UIColor lightGrayColor]
#define MinPadding 80
#define MinTopPadding (iphoneX ? 40.f : 20.f)
#define popViewPadding 15
@end

@implementation JXDPopView

+ (JXDPopView *)createPopViewWithArrowPoint:(CGPoint)arrowPoint inView:(UIView *)superView{
    JXDPopView *popView = [[JXDPopView alloc] initWithFrame:superView.bounds];
    popView.backgroundColor = [UIColor clearColor];
    popView.arrowPoint = arrowPoint;
    if (popView) {
        [popView arrowDirectionByPoint:arrowPoint inViewFrame:superView.bounds];
        [popView setupUI];
        [superView addSubview:popView];
    }
    
    return popView;
}

- (void)setupUI{
    
    [self addSubview:self.arrowView];
    self.popBackView = [[UIScrollView alloc] init];
    self.popBackView.layer.cornerRadius = popViewCornerRadius;
    self.popBackView.layer.masksToBounds = YES;
    self.popBackView.backgroundColor = popViewBackColor;
    [self addSubview:self.popBackView];
    _popBackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.numberOfLines = 0;
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.popBackView addSubview:textLabel];
    self.popContent = textLabel;
    
}
- (UIView *)arrowView{
    if (_arrowView == nil) {
        UIView *arrowView = [[UIView alloc] init];
        arrowView.backgroundColor = popViewBackColor;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        if (_arrowDirection == PopViewArrowDirectionTop) {
            arrowView.frame = CGRectMake(_arrowPoint.x-arrowHeight/2, _arrowPoint.y, arrowHeight, arrowHeight);
            [path moveToPoint:CGPointMake(arrowHeight/2, 0)];
            [path addLineToPoint:CGPointMake(arrowHeight, arrowHeight)];
            [path addLineToPoint:CGPointMake(0, arrowHeight)];
            [path addLineToPoint:CGPointMake(arrowHeight/2, 0)];
            layer.path = path.CGPath;
            
        }else if (_arrowDirection == PopViewArrowDirectionBottom){
            arrowView.frame = CGRectMake(_arrowPoint.x-arrowHeight/2, _arrowPoint.y-arrowHeight, arrowHeight, arrowHeight);
            [path moveToPoint:CGPointMake(arrowHeight/2, arrowHeight)];
            [path addLineToPoint:CGPointMake(arrowHeight, 0)];
            [path addLineToPoint:CGPointMake(0,0)];
            [path addLineToPoint:CGPointMake(arrowHeight/2, arrowHeight)];
            layer.path = path.CGPath;
        }else if (_arrowDirection == PopViewArrowDirectionLeft){
            arrowView.frame = CGRectMake(_arrowPoint.x, _arrowPoint.y-arrowHeight/2, arrowHeight, arrowHeight);
            [path moveToPoint:CGPointMake(0, arrowHeight*.5)];
            [path addLineToPoint:CGPointMake(arrowHeight, arrowHeight)];
            [path addLineToPoint:CGPointMake(arrowHeight, 0)];
            [path addLineToPoint:CGPointMake(0, arrowHeight*.5)];
            layer.path = path.CGPath;
        }else if (_arrowDirection == PopViewArrowDirectionRight){
            arrowView.frame = CGRectMake(_arrowPoint.x-arrowHeight, _arrowPoint.y-arrowHeight/2, arrowHeight, arrowHeight);
            [path moveToPoint:CGPointMake(arrowHeight, arrowHeight*.5)];
            [path addLineToPoint:CGPointMake(0, arrowHeight)];
            [path addLineToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(arrowHeight, arrowHeight*.5)];
            layer.path = path.CGPath;
            
        }
        layer.frame = arrowView.bounds;
        arrowView.layer.mask = layer;
        _arrowView = arrowView;
    }
    return _arrowView;
}
- (void)configLayout{
    CGFloat  popViewMaxWidth = kSize(200);
    if (self.arrowDirection == PopViewArrowDirectionLeft) {
        if (kScreenWidth-_arrowPoint.x-arrowHeight > popViewPadding + kSize(200) + popViewCornerRadius*2) {
            popViewMaxWidth = kSize(200);
        }else popViewMaxWidth = kScreenWidth-_arrowPoint.x-popViewPadding-arrowHeight-popViewCornerRadius*2;
    }else if(self.arrowDirection == PopViewArrowDirectionRight){
        if (_arrowPoint.x > popViewPadding + kSize(200) + popViewCornerRadius*2) {
            popViewMaxWidth = kSize(200);
        }else popViewMaxWidth = _arrowPoint.x-popViewPadding-arrowHeight-popViewCornerRadius*2;
    }
    
    CGSize textSize = [self.popContent sizeThatFits:CGSizeMake(popViewMaxWidth, MAXFLOAT)];
    CGFloat  popViewMaxHeight = textSize.height+popViewCornerRadius*2;
    popViewMaxWidth = textSize.width+popViewCornerRadius*2;
    self.popBackView.contentSize = CGSizeMake(popViewMaxWidth, popViewMaxHeight);
    [_popBackView addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:popViewMaxWidth]];
    [_popBackView addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:popViewMaxHeight]];
    if (_arrowDirection == PopViewArrowDirectionTop) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.arrowView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        if (_arrowPoint.x >= (popViewMaxWidth/2.f) && _arrowPoint.x <= (kScreenWidth-(popViewMaxWidth/2.f))) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.arrowView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        }else if(_arrowPoint.x < (popViewMaxWidth/2.f)){
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:popViewPadding]];
        }else [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-popViewPadding]];
        
    }else if (_arrowDirection == PopViewArrowDirectionBottom){
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.arrowView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        if (_arrowPoint.x >= (popViewMaxWidth/2.f) && _arrowPoint.x <= (kScreenWidth-(popViewMaxWidth/2.f))) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.arrowView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            
        }else if(_arrowPoint.x < (popViewMaxWidth/2.f)){
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:popViewPadding]];
        }else [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-popViewPadding]];
        
    }else{
        if (_arrowDirection == PopViewArrowDirectionRight) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.arrowView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        }else if (_arrowDirection == PopViewArrowDirectionLeft){
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.arrowView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        }
        
        if (_arrowPoint.y >= popViewMaxHeight/2.0 + MinPadding && _arrowPoint.y <= self.bounds.size.height -popViewMaxHeight/2.0-popViewPadding) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.arrowView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        }else if(_arrowPoint.y < popViewMaxHeight/2.0 + MinPadding){
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:MinTopPadding-popViewCornerRadius*2]];
        }else {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_popBackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-popViewPadding]];
        }
    }
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_popContent attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.popBackView attribute:NSLayoutAttributeTop multiplier:1 constant:popViewCornerRadius];
    NSLayoutConstraint *leftopConstraint = [NSLayoutConstraint constraintWithItem:_popContent attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.popBackView attribute:NSLayoutAttributeLeft multiplier:1 constant:popViewCornerRadius];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_popContent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:textSize.width];
    //NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_popContent attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.popBackView attribute:NSLayoutAttributeBottom multiplier:1 constant:-popViewCornerRadius];
    
    [_popBackView addConstraint:topConstraint];
    [_popBackView addConstraint:leftopConstraint];
    [_popContent addConstraint:rightConstraint];
    //[_popBackView addConstraint:bottomConstraint];
    
    
    
    [self setNeedsLayout];
}
- (void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    self.popContent.text = contentStr;
    [self configLayout];
}
#pragma mark privateMethod
- (void)arrowDirectionByPoint:(CGPoint)arowPoint inViewFrame:(CGRect)frame{
    
    if ((arowPoint.y >= MinPadding + popViewCornerRadius) && (arowPoint.y <= (frame.size.height-MinPadding-popViewCornerRadius))) {
        if (arowPoint.x < frame.size.width/2) {
            self.arrowDirection = PopViewArrowDirectionLeft;
        }else self.arrowDirection = PopViewArrowDirectionRight;
    }else if (arowPoint.y < MinPadding+popViewCornerRadius){
        self.arrowDirection = PopViewArrowDirectionTop;
    }else self.arrowDirection = PopViewArrowDirectionBottom;
    
}


@end
