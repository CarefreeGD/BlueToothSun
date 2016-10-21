//
//  BlueTooth.m
//  NEWNEW
//
//  Created by apple on 16/10/21.
//  Copyright © 2016年 孙晓东. All rights reserved.
//

#import "BlueTooth.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSString+DealWithData.h"
#import "SVProgressHUD.h"
typedef void (^peripheralNumber)(NSMutableArray *Temp,ScanBlueState isSuccess);
typedef void (^SendMessageST)(SendMessageState state);
@interface BlueTooth()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong)CBCentralManager *centralManager;//中心
@property (nonatomic,strong)CBPeripheral *peripheral;//外设
@property (nonatomic,strong)NSMutableArray *showArray;//返回数组

@property (nonatomic,copy)peripheralNumber peripheralNumber;
@property (nonatomic,copy)SendMessageST sendMessageST;

@property (nonatomic)BOOL isScanOrConnect;//扫描还是链接
@property (nonatomic,copy)NSString *blueToothName;//蓝牙名字
@end


@implementation BlueTooth

+ (BlueTooth *)shareInstance {
    static BlueTooth *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}
- (instancetype)init {
    if (self = [super init]) {
        self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@NO}];
        self.showArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)scanPeripheral:(void (^)(NSMutableArray *perrpheral,ScanBlueState isSuccess))perNumber {
    if (self.centralManager) {
        NSLog(@"开始扫描");
        if (self.showArray.count != 0) {
            [self.showArray removeAllObjects];
        }
        self.isScanOrConnect = YES;
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        self.peripheralNumber = perNumber;
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timestopAction:) userInfo:nil repeats:NO];
    }

}

- (void)sendMessageBlueName:(NSString *)blueName
        withSelectOrSet:(SelectOrSet)selectOrSet
          withSendState:(void(^)(SendMessageState state))sendMessage {
    if (self.centralManager) {
        NSLog(@"开始扫描");
        self.isScanOrConnect = NO;
        self.blueToothName = blueName;
        self.selectOrSet = selectOrSet;
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        self.sendMessageST = sendMessage;
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timestopAction:) userInfo:nil repeats:NO];
    }
}


#pragma mark - 定时器
- (void)timestopAction:(NSTimer *)timer {
    if (self.showArray.count > 0) {
        self.peripheralNumber(self.showArray,ISScanSuccess);
    }else {
        self.peripheralNumber(nil,ISConectTimeOut);
    }
    [self.centralManager stopScan];
    [timer invalidate];
    timer = nil;
    NSLog(@"停止计时");
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central == self.centralManager) {
        switch (central.state) {
            case CBCentralManagerStatePoweredOn:
                NSLog(@"BLE已经打开");
                break;
            default:
                NSLog(@"此设备未打开蓝牙功能，请打开蓝牙");
                break;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@",[NSString stringWithFormat:@"发现蓝牙设备:%@",advertisementData[@"kCBAdvDataLocalName"]]);
    if (![self.showArray containsObject:[NSString stringWithFormat:@"%@",advertisementData[@"kCBAdvDataLocalName"]]]) {
        [self.showArray addObject:[NSString stringWithFormat:@"%@",advertisementData[@"kCBAdvDataLocalName"]]];
    }
    //链接外围设备
    if (!self.isScanOrConnect) {
        if ([advertisementData[@"kCBAdvDataLocalName"] isEqualToString:self.blueToothName]) {
            NSLog(@"%@",[NSString stringWithFormat:@"准备链接蓝牙设备:%@",advertisementData[@"kCBAdvDataLocalName"]]);
            [central stopScan];
            [central connectPeripheral:peripheral options:nil];
            self.peripheral = peripheral;
        }
    }
    
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    if (central == self.centralManager) {
        //设置外围设备的代理为当前试图控制器
        peripheral.delegate = self;
        [peripheral discoverServices:nil];
         NSLog(@"链接外围设备成功...");
    }
}
//链接外围设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"链接外围设备失败");
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (peripheral == self.peripheral) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE2"]]) {
                //订阅返回值
                [peripheral readValueForCharacteristic:characteristic];
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE3"]]) {
                NSLog(@"准备修改...");
                NSString *hexString = [NSString dislocation_xor:self.whether_Way withData:self.whether_Body andWhetherFill:self.whether_Fill];
                NSData *data2;
                if (self.selectOrSet == SELECTSERET) {
                    data2 = [NSString header_or_end_sendMessage:hexString withBytes:9];
                }else if(self.selectOrSet == SELECTTIME){
                    data2 = [NSString header_or_end_sendMessage:hexString withBytes:9];
                }else {
                    data2 = [NSString eighteen_Check:hexString];
                }
                NSLog(@"%@",data2);
                NSData *data1 = [NSString header_or_end_sendMessage:@"02" withBytes:1];
                NSData *data3 = [NSString header_or_end_sendMessage:@"03" withBytes:1];
                NSArray *array = @[data1,data2,data3];
                
                for (int j = 0; j < 2; j++) {
                    for (int i = 0; i<3; i++) {
                        [peripheral writeValue:array[i] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    }
                }
                NSLog(@"修改成功");
                self.sendMessageST(SendMessageSuccess);
//                [self.centralManager cancelPeripheralConnection:peripheral];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"---返回值:%@---",characteristic.value);
//    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"返回值:%@",characteristic.value]];
}
// 发现未连接时，及时连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    //    [self.centralManager connectPeripheral:peripheral options:nil];
}

@end
