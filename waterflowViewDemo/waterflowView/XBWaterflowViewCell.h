//
//  XBWaterflowViewCell.h
//  waterflow
//
//  Created by mac on 15/12/23.
//  Copyright © 2015年 zhouxubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBWaterflowViewCell : UIView
/**
 *  重用标示符
 */
@property (nonatomic, copy) NSString *identifier;

- (instancetype)initWithReusableIdentifier:(NSString *)identifier;

@end
