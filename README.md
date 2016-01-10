# waterflowView
一个简单的瀑布流控件,基本用法和tableview一样

![Resize icon](https://github.com/zhouxubin/waterflowView/blob/master/waterflowView.gif)

// 添加瀑布流控件

XBWaterflowView *waterflowView = [[XBWaterflowView alloc] init];

waterflowView.dataSource = self;

waterflowView.delegate = self;

waterflowView.frame = self.view.bounds;

[self.view addSubview:waterflowView];

---
    
@required 实现数据源方法

/** *  总共有多少个cell */
 
- (CGFloat)numberOfCellsOnWaterflowView:(XBWaterflowView *)waterflowView;

/** *  每个位置的cell */
 
- (XBWaterflowViewCell *)waterflowView:(XBWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index;

@optional

/** *  总共有多少列 */

- (CGFloat)numberOfColumsOnWaterflowView:(XBWaterflowView *)waterflowView;
 
---

可选代理方法

/** *  每个位置cell的高度 * /

- (CGFloat)waterflowView:(XBWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index;
 
/** *  间距 * /

- (CGFloat)waterflowView:(XBWaterflowView *)waterflowView marginForType:(XBWaterflowViewType)type;

/** *  选中index位置的cell * /

- (void)waterflowView:(XBWaterflowView *)waterflowView didSelectedCellAtIndex:(NSUInteger)index;
