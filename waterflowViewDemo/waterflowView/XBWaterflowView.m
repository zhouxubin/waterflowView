//
//  XBWaterflowView.m
//  waterflow
//
//  Created by mac on 15/12/23.
//  Copyright © 2015年 zhouxubin. All rights reserved.
//

#define XBWaterflowViewDefaultColum 2
#define XBWaterflowViewDefaultMargin 8
#define XBWaterflowViewDefaultHeight 70

#import "XBWaterflowView.h"

@interface XBWaterflowView ()
/**
 *  存放cell的frame的数组
 */
@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 *  存放cell的字典
 */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;
/**
 *  缓存池
 */
@property (nonatomic, strong) NSMutableSet *reusableCells;

@end

@implementation XBWaterflowView

#pragma mark - 公共接口
- (CGFloat)cellWidth {
    // 总共的列数
    NSUInteger numberOfColums = [self numberOfColums];
    
    CGFloat leftMargin = [self marginForType:XBWaterflowViewTypeLeft];
    CGFloat rightMargin = [self marginForType:XBWaterflowViewTypeRight];
    CGFloat columMargin = [self marginForType:XBWaterflowViewTypeColum];
    // cell的宽度
    CGFloat cellWidth = (self.bounds.size.width - leftMargin - rightMargin - (numberOfColums - 1) * columMargin) / numberOfColums;
    return cellWidth;
}

/**
 *  刷新数据
 */
- (void)reloadData {
    // 刷新数据之前清空之前的数据
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusableCells removeAllObjects];
    
    // 总共cell的个数
    NSUInteger numberOfCells = [self.dataSource numberOfCellsOnWaterflowView:self];
    // 总共的列数
    NSUInteger numberOfColums = [self numberOfColums];
    // 间距
    CGFloat topMargin = [self marginForType:XBWaterflowViewTypeTop];
    CGFloat leftMargin = [self marginForType:XBWaterflowViewTypeLeft];
    CGFloat bottomMargin = [self marginForType:XBWaterflowViewTypeBottom];
    CGFloat columMargin = [self marginForType:XBWaterflowViewTypeColum];
    CGFloat rowMargin = [self marginForType:XBWaterflowViewTypeRow];
    
    // cell的宽度
    CGFloat cellWidth = [self cellWidth];
    
    // 重新计算所有cell的frame
    // 用一个C语言数组来存放每一列的最大Y值
    CGFloat maxYOfColums[numberOfColums];
    // 设置初始值都为0
    for (int i = 0; i < numberOfColums; i++) {
        maxYOfColums[i] = 0.0;
    }
    // 遍历所有的cell
    for (int i = 0; i < numberOfCells; i++) {
        // 最短的那一列
        NSUInteger cellColum = 0;
        // 最短那一列cell的最大Y值
        CGFloat maxYOfCellColum = maxYOfColums[cellColum];
        // 遍历最大Y值数组
        for (int j = 1; j < numberOfColums; j++) {
            if (maxYOfColums[j] < maxYOfCellColum) {
                maxYOfCellColum = maxYOfColums[j];
                cellColum = j;
            }
        }
        
        // 走到这里已经找到最短那一列的最大Y值和所在的列号
        // 向数据源索要i位置cell的高度
        CGFloat cellHeight = [self heightAtIndex:i];
        // 计算cell的frame
        CGFloat cellX = leftMargin + cellColum * (cellWidth + columMargin);
        CGFloat cellY = 0;
        if (maxYOfCellColum == 0.0) { // 首行
            cellY = topMargin;
        }else {
            cellY = maxYOfCellColum + rowMargin;
        }
        
        // 把frame放到数组中
        CGRect frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        [self.cellFrames addObject:[NSValue valueWithCGRect:frame]];
        
        // 更新最大那一列的Y值
        maxYOfColums[cellColum] = CGRectGetMaxY(frame);
    }
    
    // 设置滚动范围
    CGFloat contentH = maxYOfColums[0];
    for (int i = 1; i < numberOfColums; i++) {
        if (maxYOfColums[i] > contentH) {
            contentH = maxYOfColums[i];
        }
    }
    
    contentH += bottomMargin;
    self.contentSize = CGSizeMake(0, contentH);
}

/**
 *  滚动的时候也会调用这个方法
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    // 想数据源索要对应位置的cell,判断是否在屏幕上,如果不在屏幕上,那么就移除
    NSUInteger numberOfCells = self.cellFrames.count;
    for (int i = 0; i < numberOfCells; i++) {
        // 取出I位置的cellframe
        CGRect frame = [self.cellFrames[i] CGRectValue];
        // 从字典中取出对应位置的cell
        XBWaterflowViewCell *cell = self.displayingCells[@(i)];
        // 判断是否在屏幕上
        if ([self isOnScreen:frame]) {
            if (cell == nil) { // 字典中还没有
                cell = [self.dataSource waterflowView:self cellAtIndex:i];
                cell.frame = frame;
                [self addSubview:cell];
                self.displayingCells[@(i)] = cell;
            }
        }else { // 不在屏幕上
            if (cell) { // 如果存在,需要移除
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                // 放入缓存池
                [self.reusableCells addObject:cell];
            }
        }
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    __block XBWaterflowViewCell *myCell = nil;
    // 遍历缓存池
    [self.reusableCells enumerateObjectsUsingBlock:^(XBWaterflowViewCell *cell, BOOL * _Nonnull stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            myCell = cell;
            *stop = YES;
        }
    }];
    // 如果找到了,需要从缓存池中移除
    if (myCell) {
        [self.reusableCells removeObject:myCell];
    }
    return myCell;
}

#pragma mark - 私有方法
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self reloadData];
}

- (BOOL)isOnScreen:(CGRect)frame {
    return (CGRectGetMaxY(frame) > self.contentOffset.y) && (CGRectGetMinY(frame) < self.contentOffset.y + self.bounds.size.height);
}

/**
 *  总共的列数
 */
- (NSUInteger)numberOfColums {
    if ([self.delegate respondsToSelector:@selector(numberOfColumsOnWaterflowView:)]) {
        return [self.dataSource numberOfColumsOnWaterflowView:self];
    }else {
        return XBWaterflowViewDefaultColum;
    }
}
/**
 *  间距
 */
- (CGFloat)marginForType:(XBWaterflowViewType)type {
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        return [self.delegate waterflowView:self marginForType:type];
    }else {
        return XBWaterflowViewDefaultMargin;
    }
}

/**
 *  index位置cell的高度
 */
- (CGFloat)heightAtIndex:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]) {
        return [self.delegate waterflowView:self heightAtIndex:index];
    }else {
        return XBWaterflowViewDefaultHeight;
    }
}

#pragma mark - 事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self.delegate respondsToSelector:@selector(waterflowView:didSelectedCellAtIndex:)]) return;
    
    // 判断点击屏幕的位置是否在cell所在的frame里面
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __block NSNumber *index = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, XBWaterflowViewCell *cell, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(cell.frame, point)) { // 包含这个点
            index = key;
            *stop = YES;
        }
    }];
    
    if (index) {
        [self.delegate waterflowView:self didSelectedCellAtIndex:index.unsignedIntegerValue];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)cellFrames {
    if (!_cellFrames) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells {
    if (!_displayingCells) {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

- (NSMutableSet *)reusableCells {
    if (!_reusableCells) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}

@end
