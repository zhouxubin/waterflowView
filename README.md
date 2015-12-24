# waterflowView
一个简单的瀑布流控件,基本用法和tableview一样

// 添加瀑布流控件
    XBWaterflowView *waterflowView = [[XBWaterflowView alloc] init];
    waterflowView.dataSource = self;
    waterflowView.delegate = self;
    waterflowView.frame = self.view.bounds;
    [self.view addSubview:waterflowView];
    
    @required 实现数据源方法
/**
 *  总共有多少个cell
 */
- (CGFloat)numberOfCellsOnWaterflowView:(XBWaterflowView *)waterflowView;
/**
 *  每个位置的cell
 */
- (XBWaterflowViewCell *)waterflowView:(XBWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index;
