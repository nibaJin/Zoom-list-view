//
//  BGFCardView.m
//  FJTest
//
//  Created by jin fu on 2018/3/8.
//  Copyright © 2018年 Jiuhuar. All rights reserved.
//

#import "BGFCardView.h"

@interface BGFCardView ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@property (strong, nonatomic) NSMutableArray *views;

@property (assign, nonatomic) CGFloat width;

@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) NSInteger currentIndex;

@end
@implementation BGFCardView

#pragma mark - instance
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commitView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.mainView setFrame:self.bounds];
    _width = CGRectGetWidth(self.frame);
    _height = CGRectGetHeight(self.frame);
}

- (void)commitView
{
    [self loadFormNib];
    [self addSubview:self.mainView];
    
    // default
    self.scaleX = 0.7;
    self.scaleY = 0.7;
    
    self.currentIndex = 0;
    
    self.scrollerView.delegate = self;
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollerView.showsVerticalScrollIndicator = NO;
    self.scrollerView.clipsToBounds = NO;
    self.scrollerView.pagingEnabled = YES;
}


#pragma mark - data
- (void)reloadData
{
    // clear
    for (UIView *subView in self.scrollerView.subviews) {
        [subView removeFromSuperview];
    }
    _views = [NSMutableArray new];
    
    NSInteger count = 0;
    if ([self.datasouce respondsToSelector:@selector(numberOfCountAtcardView:)]) {
        count = [self.datasouce numberOfCountAtcardView:self];
    }
    for (NSInteger i = 0; i < count; i ++) {
        
        UIView *view = [[UIView alloc] init];
        if ([self.datasouce respondsToSelector:@selector(cardView:atIndex:)]) {
            view = [self.datasouce cardView:self atIndex:i];
        }
        
        [_views addObject:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tap];
        [self.scrollerView addSubview:view];
    }
    
    [self layoutIfNeeded];
    
    [self updateContentView];
}

- (void)updateContentView
{
    self.scrollerView.contentSize = CGSizeMake(_width * _views.count, _height);
    for (NSInteger i = 0; i < _views.count; i ++) {
        CGFloat x = i * _width;
        CGFloat y = 0;
        UIView *view = _views[i];
        view.frame = CGRectMake(x, y, _width, _height);
    }
    [self updateViewsScaleForVisable];
}

#pragma mark - event
- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    NSInteger index = [_views indexOfObject:view];
    if (index != _currentIndex) {
        _currentIndex = index;
        [self.scrollerView setContentOffset:CGPointMake(index*_width, 0) animated:YES];
        if ([self.delegate respondsToSelector:@selector(cardAtIndex:)]) {
            [self.delegate cardAtIndex:index];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollerView) {
        [self updateViewsScaleForVisable];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = self.scrollerView.contentOffset.x / _width;
    if (index != _currentIndex) {
        _currentIndex = index;
        if ([self.delegate respondsToSelector:@selector(cardAtIndex:)]) {
            [self.delegate cardAtIndex:index];
        }
    }
}

#pragma mark - assistant
- (NSArray *)viewsForVisable
{
    NSMutableArray *viewsForVisable = [NSMutableArray new];
    CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat rightWidth = (fullWidth - _width) * 0.5;
    
    CGRect visableRect = CGRectMake(self.scrollerView.contentOffset.x-rightWidth, 0, fullWidth, _height);
    for (UIView *view in _views) {
        if (CGRectIntersectsRect(visableRect, view.frame)) {
            [viewsForVisable addObject:view];
        }
    }
    return viewsForVisable;
}

- (void)updateViewsScaleForVisable
{
    CGFloat centerX = self.scrollerView.contentOffset.x + _width*0.5;
    NSArray *viewsForVisable = [self viewsForVisable];
    for (UIView *view in viewsForVisable) {
        CGFloat viewCenterX = view.center.x;
        CGFloat disTance = ABS(centerX - viewCenterX);
        CGFloat realScaleX = 1- MIN(_width, disTance)/_width * (1-_scaleX);
        CGFloat realScaleY = 1- MIN(_width, disTance)/_width * (1-_scaleY);
        
        view.transform = CGAffineTransformMakeScale(realScaleX, realScaleY);
    }
}

- (void)loadFormNib {
    UINib *nib = [UINib nibWithNibName:@"BGFCardView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //不能响应点击事件
    BOOL canNotResponseEvent = self.hidden || (self.alpha <= 0.01f) || (self.userInteractionEnabled == NO);
    if (canNotResponseEvent) {
        return nil;
    }
    
    // 处理scroller View
    if (!self.scrollerView.clipsToBounds) {
        // 处理scroller view 超出的view
        NSArray *viewsForVisable = [self viewsForVisable];
        if (viewsForVisable.count > 0) {
            CGPoint inScrollerViewPoint = [self convertPoint:point toView:self.scrollerView];
            for (UIView *view in viewsForVisable) {
                if (CGRectContainsPoint(view.frame, inScrollerViewPoint)) {
                    return view;
                }
            }
        }
    }
    
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        UIView *result = [subview hitTest:subPoint withEvent:event];
        if (result) {
            return result;
        }
    }
    
    return nil;
}

@end
