//
//  ViewController.m
//  FJCardView
//
//  Created by jin fu on 2018/4/4.
//  Copyright © 2018年 Jiuhuar. All rights reserved.
//

#import "ViewController.h"
#import "BGFCardView.h"
#import "FJExmpleView.h"

@interface ViewController ()<BGFCardViewDatasouce, BGFCardViewDelegate>

@property (weak, nonatomic) IBOutlet BGFCardView *cardView;

@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self commitView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitView
{
    self.cardView.datasouce = self;
    self.cardView.delegate = self;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat cardWidth = screenWidth-88;
    self.cardView.scaleX = (cardWidth-44)/cardWidth;
    self.cardView.scaleY= self.cardView.scaleX;

    [self instanceData];
}

- (void)instanceData
{
    self.titles = [NSMutableArray new];
    for (NSInteger i = 0 ; i < 10; i++) {
        NSString *indexStr = [NSString stringWithFormat:@"✌️%zd✌️", i];
        [self.titles addObject:indexStr];
    }
    
    [self.cardView reloadData];
}

#pragma mark - BGFCardView
- (NSInteger)numberOfCountAtcardView:(BGFCardView *)cardView
{
    return self.titles.count;
}

- (UIView *)cardView:(BGFCardView *)cardView atIndex:(NSInteger)index
{
    FJExmpleView *view = [[FJExmpleView alloc] init];
    view.indexStr = self.titles[index];
    view.bgColor = index%2?[UIColor yellowColor]: [UIColor brownColor];
    return view;
}

- (void)cardAtIndex:(NSInteger)index
{
    NSLog(@"click show====== %zd",index);
}


@end
