//
//  XYWebCheckLog.m
//  XYDebugTools
//
//  Created by LUOHUA_Think on 2018/8/7.
//

#import "XYWebCheckLog.h"
#import "WLBWebLogManager.h"

@interface XYWebCheckLog ()

@property (nonatomic, strong) NSMutableArray * logList;

@end

@implementation XYWebCheckLog

+ (instancetype)shared
{
    static dispatch_once_t onceToken;

    static XYWebCheckLog *shared;

    dispatch_once(&onceToken, ^{
        shared = [[XYWebCheckLog alloc] init];
        shared.logList = [NSMutableArray arrayWithCapacity:1000];
    });

    return shared;
}
//
//
//- (NSMutableArray *)logs
//{
//    if(!_logs)
//    {
//        _logs = [[NSMutableArray alloc] init];
//    }
//
//    return _logs;
//}
//
//- (NSString *)eventLogsWithChannel:(NSString *)channel filterKey:(NSString *)filterKey {
//
//    NSMutableString * mutableString = [NSMutableString string];
//    [self.logList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSMutableString * item = [NSMutableString string];
//        [item appendFormat:@"【%@】", obj[@"time"]];
//        [item appendFormat:@"【EventID : <font color='red'>%@</font>】", obj[@"eventID"]];
//        [item appendFormat:@"【Channel : %@】", obj[@"channel"]];
//        [item appendString:@"</br>&nbsp&nbsp&nbsp&nbsp{</br>"];
//        NSDictionary * dictParam = obj[@"dictParams"];
//        [dictParam enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
//            [item appendFormat:@"&nbsp&nbsp&nbsp&nbsp%@ : %@</br>", key, obj];
//        }];
//
//        [item appendString:@"</br>&nbsp&nbsp&nbsp&nbsp}"];
//
//        BOOL needItem = YES;
//        if ([channel isEqualToString:@"All"] == NO && channel && [obj[@"channel"] isEqualToString:channel] == NO) {
//            needItem = NO;
//        }
//
//        if (filterKey.length > 0 && [item containsString:filterKey] == NO) {
//            needItem = NO;
//        }
//        if (needItem) {
//            [mutableString appendFormat:@"%@</br></br></br>", item];
//        }
//    }];
//
//    return mutableString;
//}
//
- (void)logEventID:(NSString *)eventID params:(NSDictionary *)dictParams channel:(NSString *)channel {
    
    NSMutableString * item = [NSMutableString string];
    [item appendString:@"</br>&nbsp&nbsp&nbsp&nbsp{</br>"];
    NSDictionary * dictParam = dictParams;
    [dictParam enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        [item appendFormat:@"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp%@ : %@</br>", key, obj];
    }];
    
    [item appendString:@"</br>&nbsp&nbsp&nbsp&nbsp}</br></br>"];

    [[WLBWebLogManager sharedManager] sendEventWithChannel:channel eventName:eventID content:item parameters:dictParam];
}

- (void)logWithContent:(NSString *)content {
    [[WLBWebLogManager sharedManager] sendLogWithContent:content];
}
//{

//
//    [self.logList addObject:@{@"eventID" : eventID, @"dictParams" : dictParams, @"channel" : channel, @"time" : }];
//    return ;
//
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
//    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond;
//
//    NSDateComponents *comps  = [calendar components:unitFlags fromDate:[NSDate date]];
//
//    NSString *time = [NSString stringWithFormat:@"%02ld/%02ld, %02ld:%02ld:%02ld:%@", (long)comps.month, (long)comps.day, (long)comps.hour, (long)comps.minute, (long)comps.second, [[NSString stringWithFormat:@"%02ld", (long)comps.nanosecond] substringToIndex:2]];
//
//    NSMutableString *format = [[NSMutableString alloc] init];
//    NSArray *keys = [dictParams allKeys];
//    for(NSString *key in keys)
//    {
//        id value = [dictParams valueForKey:key];
//
//        if([value isKindOfClass:[NSString class]])
//        {
//            NSString *tempValueStr = (NSString *)value;
//            [format appendString:@"&nbsp;&nbsp;&nbsp;"];
//            [format appendString:key];
//            [format appendString:@":"];
//            [format appendString:tempValueStr];
//            [format appendString:@"</br>"];
//        }
//
//        if([value isKindOfClass:[NSNumber class]])
//        {
//            NSNumber *tempValueStr = (NSNumber *)value;
//            [format appendString:@"&nbsp;&nbsp;&nbsp;"];
//            [format appendString:key];
//            [format appendString:@":"];
//            [format appendString:tempValueStr.stringValue];
//            [format appendString:@"</br>"];
//        }
//    }
//
//    NSString *logStr = [NSString stringWithFormat:@"</br>【%@】【%@】埋点内容------</br>%@", time, eventID, format];
//
//    [[XYWebCheckLog shared].logs addObject:logStr];
//}

@end
