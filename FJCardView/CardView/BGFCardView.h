//
//  BGFCardView.h
//  FJTest
//
//  Created by jin fu on 2018/3/8.
//  Copyright © 2018年 Jiuhuar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BGFCardView;
@protocol BGFCardViewDatasouce<NSObject>

- (NSInteger)numberOfCountAtcardView:(BGFCardView *)cardView;

- (UIView *)cardView:(BGFCardView *)cardView atIndex:(NSInteger)index;

@end
@protocol BGFCardViewDelegate<NSObject>

- (void)cardAtIndex:(NSInteger)index;

@end

@interface BGFCardView : UIView

@property (nonatomic, weak) id<BGFCardViewDatasouce> datasouce;

@property (nonatomic, weak) id<BGFCardViewDelegate> delegate;

@property (nonatomic, assign) CGFloat scaleX;

@property (nonatomic, assign) CGFloat scaleY;

- (void)reloadData;
@end
