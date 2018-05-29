//
//  DemoJumpVC.m
//  Philm
//
//  Created by 陈方方 on 2018/5/25.
//  Copyright © 2018年 yoyo. All rights reserved.
//

#import "DemoJumpVC.h"
#import "demo1.h"
#import "demo2.h"
#import "demo3.h"
#import "demo4.h"
#import "demo5.h"
#import "demo6.h"
#import "demo7.h"

@interface DemoJumpVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_jumpTable;

    NSMutableArray *_jumpsArray;
}
@end

@implementation DemoJumpVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    //给水印数据
    _jumpsArray =
        [NSMutableArray arrayWithObjects:@"让飞机绕摄像头转动", @"检测水平平面和竖直平面",
                                         @"识别标记图像", @"人脸表情识别", @"手势控制模型动画",
                                         @"传送门进入一个 box 里", @"红包雨 SCNGeometry", nil];

    _jumpTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _jumpTable.delegate = self;
    _jumpTable.dataSource = self;
    _jumpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _jumpTable.backgroundColor = [UIColor yellowColor];
    _jumpTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_jumpTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return _jumpsArray.count; }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 64; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *waterIdenti = @"PLJumpCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:waterIdenti];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:waterIdenti];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *imageName = [_jumpsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = imageName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIViewController *jumpVC;
    // jump
    switch (indexPath.row)
    {
        case 0:
            jumpVC = [demo1 new];
            break;
        case 1:
            jumpVC = [demo2 new];
            break;
        case 2:
            jumpVC = [demo3 new];
            break;
        case 3:
            jumpVC = [demo4 new];
            break;
        case 4:
            jumpVC = [demo5 new];
            break;
        case 5:
            jumpVC = [demo6 new];
            break;
        case 6:
            jumpVC = [demo7 new];
            break;
        default:
            break;
    }
    if (jumpVC)
    {
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}

@end
