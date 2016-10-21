//
//  BlueTooth.h
//  NEWNEW
//
//  Created by apple on 16/10/21.
//  Copyright © 2016年 孙晓东. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    ISConectTimeOut,
    ISScanSuccess,
    ISScanFailed
}ScanBlueState;//扫描状态

typedef enum {
    SendMessageSuccess,
    SendMessageFailed,
    SendMessageTimeOut
}SendMessageState;//发送数据状态
typedef enum {
    SELECTSERET,
    SELECTTIME,
    SET
}SelectOrSet;//设置或者查询
@interface BlueTooth : NSObject

@property(nonatomic,copy)NSString *whether_Way;//方式
@property(nonatomic,copy)NSString *whether_Body;//包体
@property(nonatomic,copy)NSString *whether_Fill;//是否填充数据
@property (nonatomic)SelectOrSet selectOrSet;//查询还是设置

+ (BlueTooth *)shareInstance;

- (void)scanPeripheral:(void (^)(NSMutableArray *perrpheral,ScanBlueState isSuccess))perNumber;//扫描结果

- (void)sendMessageBlueName:(NSString *)blueName
        withSelectOrSet:(SelectOrSet)selectOrSet
          withSendState:(void(^)(SendMessageState state))sendMessage;//发送数据状态
@end
