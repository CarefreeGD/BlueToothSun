//
//  ViewController.m
//  LanYa
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 孙晓东. All rights reserved.
//

#import "ViewController.h"
#import "BlueTooth.h"
#import "Masonry.h"
#import "TableViewController.h"
#import "MJRefresh.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)BlueTooth *blueTooth;
@end

@implementation ViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = @"下拉";
    self.blueTooth = [BlueTooth shareInstance];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.blueTooth scanPeripheral:^(NSMutableArray *perrpheral,ScanBlueState isSuccess) {
            if (isSuccess == ISScanSuccess) {
                [self.tableView.mj_header endRefreshing];
                self.dataSource = perrpheral;
                [self.tableView reloadData];
            }else if(isSuccess == ISConectTimeOut){
                [self.tableView.mj_header endRefreshing];
            }
        }];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellMark = @"cellMark";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMark];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellMark];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"蓝牙设备:%@",self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewController *table = [[TableViewController alloc] init];
    table.blueToothName = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:table animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
