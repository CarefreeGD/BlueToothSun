//
//  NSString+DealWithData.m
//  BlueToothName
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 孙晓东. All rights reserved.
//

#import "NSString+DealWithData.h"

@implementation NSString (DealWithData)
+ (NSData *)center_sendMessage:(NSString *)fromString {
    // 将16进制数据转化成Byte 数组
    NSString *heString = fromString;
    NSString *headString = @"";
    NSString *endString = @"";
    NSMutableString *hexString = [NSMutableString stringWithCapacity:0];
    [hexString appendString:endString];
    [hexString insertString:heString atIndex:0];
    [hexString insertString:headString atIndex:0];
    int j=0;
    Byte bytes[20];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位（高位*16）
        int int_ch1;
        if(hex_char1 >= '0' &&hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   ////0 的Ascll - 48
        else if(hex_char1 >= 'A' &&hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;//// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16;//// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位（低位）
        int int_ch2;
        if(hex_char2 >= '0' &&hex_char2 <='9')
            int_ch2 = (hex_char2-48);//// 0 的Ascll - 48
        else if(hex_char2 >= 'A' &&hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:20];
    return newData;
}
+ (NSData *)eighteen_Check:(NSString *)string {
    NSString *hexString = string;
    NSString *temp = [NSString stringWithFormat:@""];
    NSString *secondStr = @"AAAAAAAAAAAAAAAAAA";
    
    for(int i=0 ;i<[hexString length];i++)
    {
        int int_ch;
        int int_se;
        int int_temp;
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位（高位*16）
        int int_ch1;
        if(hex_char1 >= '0' &&hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   ////0 的Ascll - 48
        else if(hex_char1 >= 'A' &&hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;//// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16;//// a 的Ascll - 97
        
        unichar hex_char3 = [secondStr characterAtIndex:i]; ////两位16进制数中的第一位（高位*16）
        int int_ch3;
        if(hex_char3 >= '0' &&hex_char3 <='9')
            int_ch3 = (hex_char3-48)*16;   ////0 的Ascll - 48
        else if(hex_char3 >= 'A' &&hex_char3 <='F')
            int_ch3 = (hex_char3-55)*16;//// A 的Ascll - 65
        else
            int_ch3 = (hex_char3-87)*16;//// a 的Ascll - 97
        
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位（低位）
        int int_ch2;
        if(hex_char2 >= '0' &&hex_char2 <='9')
            int_ch2 = (hex_char2-48);//// 0 的Ascll - 48
        else if(hex_char2 >= 'A' &&hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        
        unichar hex_char4 = [secondStr characterAtIndex:i]; ///两位16进制数中的第二位（低位）
        int int_ch4;
        if(hex_char4 >= '0' &&hex_char4 <='9')
            int_ch4 = (hex_char4-48);//// 0 的Ascll - 48
        else if(hex_char4 >= 'A' &&hex_char4 <='F')
            int_ch4 = hex_char4-55; //// A 的Ascll - 65
        else
            int_ch4 = hex_char4-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        int_se = int_ch3+int_ch4;
        int_temp = int_ch^int_se;
        
        
        NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",int_temp]];
        NSString *zhongjian = [self fillToZero:hexString];
        NSString *zhongjian2 = [zhongjian uppercaseString];
        temp = [temp stringByAppendingString:zhongjian2];
        
    }
    
    NSString *temp1 = [NSString stringWithFormat:@"%@",temp];
    NSData *data1 = [temp1 dataUsingEncoding:NSUTF8StringEncoding];
    
    return data1;
}

+ (NSString *)fillToZero:(NSString *)zero {
    if (zero.length == 1) {
        NSString *sttttt = [NSString stringWithFormat:@"0%@",zero];
        return sttttt;
    }else
        return zero;
}


+ (NSString *)dislocation_xor:(NSString *)headWay
           withData:(NSString *)centerData
     andWhetherFill:(NSString *)fillString {
    int temp = 0;
    NSString *hexString = [NSString stringWithFormat:@"%@%@%@",headWay,centerData,fillString];
    int j=0;
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位（高位*16）
        
        int int_ch1;
        if(hex_char1 >= '0' &&hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   ////0 的Ascll - 48
        else if(hex_char1 >= 'A' &&hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;//// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16;//// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位（低位）
        int int_ch2;
        if(hex_char2 >= '0' &&hex_char2 <='9')
            int_ch2 = (hex_char2-48);//// 0 的Ascll - 48
        else if(hex_char2 >= 'A' &&hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        
        temp = temp ^ int_ch;
        
        ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSString *tempString = [NSString stringWithFormat:@"%1x",temp];
    NSString *new = [tempString uppercaseString];
    NSString *uppcase;
    if (new.length == 1) {
        uppcase = [NSString stringWithFormat:@"%@%@%@0%@",headWay,centerData,fillString,new];
    }else {
        uppcase = [NSString stringWithFormat:@"%@%@%@%@",headWay,centerData,fillString,new];
    }
    NSLog(@"拼接后的字符串：－－%@",uppcase);
    return uppcase;
}

+ (NSData *)header_or_end_sendMessage:(NSString *)string withBytes:(int)bytesCount {
    NSString *hexString = string;
    int j=0;
    Byte bytes[bytesCount];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;
        
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' &&hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' &&hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if(hex_char2 >= '0' &&hex_char2 <='9')
            int_ch2 = (hex_char2-48);
        else if(hex_char1 >= 'A' &&hex_char1 <='F')
            int_ch2 = hex_char2-55;
        else
            int_ch2 = hex_char2-87;
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:bytesCount];
    
    return newData;
}

@end
