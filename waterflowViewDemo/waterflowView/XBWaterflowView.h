//
//  XBWaterflowView.h
//  waterflow
//
//  Created by mac on 15/12/23.
//  Copyright © 2015年 zhouxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBWaterflowViewCell.h"

typedef enum {
    XBWaterflowViewTypeTop,
    XBWaterflowViewTypeLeft,
    XBWaterflowViewTypeBottom,
    XBWaterflowViewTypeRight,
    XBWaterflowViewTypeColum, // 列间距
    XBWaterflowViewTypeRow // 行间距
} XBWaterflowViewType;

@class XBWaterflowView;
/**
 *  数据源方法
 */
@protocol XBWaterflowViewDataSource <NSObject>

@required
/**
 *  总共有多少个cell
 */
- (CGFloat)numberOfCellsOnWaterflowView:(XBWaterflowView *)waterflowView;
/**
 *  每个位置的cell
 */
- (XBWaterflowViewCell *)waterflowView:(XBWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index;
@optional
/**
 *  总共有多少列
 */
- (CGFloat)numberOfColumsOnWaterflowView:(XBWaterflowView *)waterflowView;
@end

/**
 *  代理协议
 */
@protocol XBWaterflowViewDelegate <UIScrollViewDelegate>

@optional
/**
 *  每个位置cell的高度
 */
- (CGFloat)waterflowView:(XBWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index;
/**
 *  间距
 */
- (CGFloat)waterflowView:(XBWaterflowView *)waterflowView marginForType:(XBWaterflowViewType)type;

/**
 *  选中index位置的cell
 */
- (void)waterflowView:(XBWaterflowView *)waterflowView didSelectedCellAtIndex:(NSUInteger)index;


@end

@interface XBWaterflowView : UIScrollView
/**
 *  数据源
 */
@property (nonatomic, weak) id <XBWaterflowViewDataSource> dataSource;
/**
 *  代理
 */
@property (nonatomic, weak) id <XBWaterflowViewDelegate> delegate;

/**
 *  刷新数据,向数据源索要数据
 */
- (void)reloadData;
/**
 *  重用
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
/**
 *  cell的宽度
 */
- (CGFloat)cellWidth;

@end
