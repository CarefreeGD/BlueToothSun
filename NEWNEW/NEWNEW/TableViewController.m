//
//  TableViewController.m
//  BlueToothName
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 孙晓东. All rights reserved.
//

#import "TableViewController.h"
#import "BlueTooth.h"
#import "RKAlertView.h"
#import "SVProgressHUD.h"
@interface TableViewController ()
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)BlueTooth *bHelper;
@end

@implementation TableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.title = [NSString stringWithFormat:@"蓝牙设备:%@",self.blueToothName];
    self.dataArr = [NSMutableArray arrayWithObjects:@"设置密钥",@"设置时间",@"查询密钥",@"查询时间",@"修改名字", nil];
    self.bHelper = [BlueTooth shareInstance];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开门" style:UIBarButtonItemStyleDone target:self action:@selector(openDoor:)];
}
- (void)openDoor:(UIBarButtonItem *)sender {
    self.bHelper.whether_Way = @"51";
    self.bHelper.whether_Body = self.blueToothName;
    self.bHelper.whether_Fill = @"ABC00000";
    [self.bHelper sendMessageBlueName:self.blueToothName withSelectOrSet:SET withSendState:^(SendMessageState state) {
        if (state == SendMessageSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"开门成功!"];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellMark = @"Acell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMark];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellMark];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [RKAlertView showAlertPlainTextWithTitle:@"提示框" message:@"请输入要设置的密钥" cancelTitle:@"取消" confirmTitle:@"确认" alertViewStyle:UIAlertViewStylePlainTextInput confrimBlock:^(UIAlertView *alertView) {
            NSLog(@"确认了输入：%@",[alertView textFieldAtIndex:0].text);
            self.bHelper.whether_Way = @"AB";
            self.bHelper.whether_Body = [alertView textFieldAtIndex:0].text;
            self.bHelper.whether_Fill = @"ABC000";
            [self.bHelper sendMessageBlueName:self.blueToothName withSelectOrSet:SET withSendState:^(SendMessageState state) {
                if (state == SendMessageSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"设置密钥成功!"];
                }
            }];
        } cancelBlock:^{
            
        }];
    }else if (indexPath.row == 1) {
        self.bHelper.whether_Way = @"AC";
        self.bHelper.whether_Body = [self getCurrentTime];
        self.bHelper.whether_Fill = @"";
        [self.bHelper sendMessageBlueName:self.blueToothName withSelectOrSet:SET withSendState:^(SendMessageState state) {
            if (state == SendMessageSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"设置时间成功!"];
            }
        }];
    }else if (indexPath.row == 2) {
        self.bHelper.whether_Way = @"BB";
        self.bHelper.whether_Body = @"000000";
        self.bHelper.whether_Fill = @"00000000";
        [self.bHelper sendMessageBlueName:self.blueToothName withSelectOrSet:SET withSendState:^(SendMessageState state) {
            NSLog(@"状态:%d",state);
        }];
    }else if (indexPath.row == 3) {
        self.bHelper.whether_Way = @"CC";
        self.bHelper.whether_Body = @"000000";
        self.bHelper.whether_Fill = @"00000000";
        [self.bHelper sendMessageBlueName:self.blueToothName withSelectOrSet:SET withSendState:^(SendMessageState state) {
            NSLog(@"状态:%d",state);
        }];
    }else if (indexPath.row == 4) {
        [RKAlertView showAlertPlainTextWithTitle:@"提示框" message:@"请输入要修改的名字" cancelTitle:@"取消" confirmTitle:@"确认" alertViewStyle:UIAlertViewStylePlainTextInput confrimBlock:^(UIAlertView *alertView) {
            NSLog(@"确认了输入：%@",[alertView textFieldAtIndex:0].text);
            self.bHelper.whether_Way = @"AA";
            self.bHelper.whether_Body = [alertView textFieldAtIndex:0].text;
            self.bHelper.whether_Fill = @"ABC00000";
            [self.bHelper sendMessageBlueName:self.blueToothName withSelectOrSet:SET withSendState:^(SendMessageState state) {
                if (state == SendMessageSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"修改成功!"];
                }
            }];
        } cancelBlock:^{ 
            
        }];
    }
}


- (NSString *)getCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:date];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:date];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:date];
    [formatter setDateFormat:@"HH"];
    NSString *hour = [formatter stringFromDate:date];
    [formatter setDateFormat:@"mm"];
    NSString *minute = [formatter stringFromDate:date];
    [formatter setDateFormat:@"ss"];
    NSString *second = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",year,month,day,hour,minute,second];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
