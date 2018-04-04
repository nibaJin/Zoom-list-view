//
//  FJExmpleView.m
//  FJCardView
//
//  Created by jin fu on 2018/4/4.
//  Copyright © 2018年 Jiuhuar. All rights reserved.
//

#import "FJExmpleView.h"

@interface FJExmpleView ()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation FJExmpleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

- (void)configSubView
{
    [self loadContentView];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

- (void)loadContentView
{
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}

- (void)setIndexStr:(NSString *)indexStr
{
    _indexStr = indexStr;
    self.indexLabel.text = indexStr;
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.contentView.backgroundColor = bgColor;
}

@end
