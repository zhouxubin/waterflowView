//
//  XBWaterflowViewCell.m
//  waterflow
//
//  Created by mac on 15/12/23.
//  Copyright © 2015年 zhouxubin. All rights reserved.
//

#import "XBWaterflowViewCell.h"

@implementation XBWaterflowViewCell

- (instancetype)initWithReusableIdentifier:(NSString *)identifier {
    XBWaterflowViewCell *cell = [[XBWaterflowViewCell alloc] init];
    cell.identifier = identifier;
    return cell;
}

@end
