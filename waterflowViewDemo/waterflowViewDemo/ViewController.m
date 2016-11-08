//
//  ViewController.m
//  waterflowViewDemo
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 zhouxubin. All rights reserved.
//

#import "ViewController.h"
#import "XBWaterflowView.h"

@interface ViewController () <XBWaterflowViewDataSource, XBWaterflowViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 添加瀑布流控件
    XBWaterflowView *waterflowView = [[XBWaterflowView alloc] init];
    waterflowView.dataSource = self;
    waterflowView.delegate = self;
    waterflowView.frame = self.view.bounds;
    [self.view addSubview:waterflowView];
    UIButton *button = [[UIButton alloc] init];
}

#pragma mark - XBWaterflowViewDataSource
// 总共的列数(默认是两列)
- (CGFloat)numberOfColumsOnWaterflowView:(XBWaterflowView *)waterflowView {
    return 3;
}

// cell的个数
- (CGFloat)numberOfCellsOnWaterflowView:(XBWaterflowView *)waterflowView {
    return 50;
}

// 每个index位置的cell
- (XBWaterflowViewCell *)waterflowView:(XBWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index {
    static NSString *reuseIdentifier = @"cell";
    XBWaterflowViewCell *cell = [waterflowView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[XBWaterflowViewCell alloc] init];
        cell.identifier = reuseIdentifier;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(20, 20, 30, 30);
        label.tag = 10;
        [cell addSubview:label];
    }
    UILabel *lb = (UILabel *)[cell viewWithTag:10];
    lb.text = [NSString stringWithFormat:@"%ld", index];
    cell.backgroundColor = [self randomColor];
    
    NSLog(@"%ld====%p", index, &cell);
    return cell;
}

#pragma mark - XBWaterflowViewDelegate
// 每个index位置的高度
- (CGFloat)waterflowView:(XBWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index {
    // 随机高度
    return arc4random_uniform(70) + 50;
}

// 间距(可以设置上,左,下,右,列,行间距)有默认间距
- (CGFloat)waterflowView:(XBWaterflowView *)waterflowView marginForType:(XBWaterflowViewType)type {
    switch (type) {
        case XBWaterflowViewTypeTop: return arc4random_uniform(10);
        case XBWaterflowViewTypeLeft: return arc4random_uniform(10);
        case XBWaterflowViewTypeBottom: return arc4random_uniform(10);
        case XBWaterflowViewTypeRight: return arc4random_uniform(10);
        case XBWaterflowViewTypeColum: return arc4random_uniform(10);
        case XBWaterflowViewTypeRow: return arc4random_uniform(10);
        default: return arc4random_uniform(10);
    }
}

// 点击cell
- (void)waterflowView:(XBWaterflowView *)waterflowView didSelectedCellAtIndex:(NSUInteger)index {
    NSLog(@"%ld", index);
}

// 随机色
- (UIColor *)randomColor {
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
