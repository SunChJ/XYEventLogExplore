//
//  WLBWebLogDatasource.m
//  Expecta
//
//  Created by irobbin on 2019/3/16.
//

#import "WLBWebLogDatasource.h"
#import "XYEventCheckManager.h"
#import <YYModel/YYModel.h>

@interface WLBWebLogDatasource ()

@property (nonatomic, strong) NSMutableArray * eventList;
@property (nonatomic, strong) NSMutableArray * logList;

@end

@implementation WLBWebLogDatasource

- (instancetype)init {
    self = [super init];
    if (self) {
        _eventList = [NSMutableArray arrayWithCapacity:100];
        _logList = [NSMutableArray arrayWithCapacity:100];
    }
    return self;
}

- (NSArray *)getLogs {
    __block NSArray * logs;
    @synchronized (self) {
        logs = [self.logList copy];
        
        [self.logList removeAllObjects];
    }
    
    return logs;
}

- (NSArray *)getEvents {
    __block NSArray * logs;
    @synchronized (self) {
        logs = [self.eventList copy];
        
        [self.eventList removeAllObjects];
    }
    
    return logs;
}

- (void)addLogWithContent:(NSString *)content {
    @synchronized (self) {
        static NSDateFormatter * formatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        });
        [self.logList addObject:@{@"channel" : @"DeviceLog",
                                  @"content" : content,
                                  @"time" : [formatter stringFromDate:[NSDate date]]}];
    }
}

- (void)addEventWithChannel:(NSString *)channel eventName:(NSString *)eventName content:(NSString *)content parameters:(NSDictionary *)parameters {
    @synchronized (self) {
        static NSDateFormatter * formatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        });
        [self.eventList addObject:@{@"channel" : channel,
                                  @"event" : eventName,
                                  @"content" : content,
                                  @"time" : [formatter stringFromDate:[NSDate date]]}];
        
        [[XYEventCheckManager sharedInstance] addEventWithChannel:channel eventName:eventName content:content parameters:parameters];
    }
}

- (NSDictionary *)getTotalMap {
    return [self getJsonDataWithModelArray:[XYEventCheckManager sharedInstance].eventList];
}

- (NSDictionary *)getCorectMap {
    return [self getJsonDataWithModelArray:[XYEventCheckManager sharedInstance].alreadyShootList];
}

- (NSDictionary *)getLeftMap {
    return [self getJsonDataWithModelArray:[XYEventCheckManager sharedInstance].notShootList];
}

- (NSDictionary *)getErrorMap {
    return [self getJsonDataWithModelArray:[XYEventCheckManager sharedInstance].shootButParameterErrorList];
}

- (NSDictionary *)getJsonDataWithModelArray:(NSArray<XYEventModel *> *)modelArray {
    NSMutableDictionary * jsonDic = [NSMutableDictionary dictionaryWithCapacity:modelArray.count];
    
//    NSMutableArray * jsonData = [NSMutableArray arrayWithCapacity:modelArray.count];
    [modelArray enumerateObjectsUsingBlock:^(XYEventModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        jsonDic[obj.event_id] = [obj yy_modelToJSONObject];
//        [jsonData addObject:[obj yy_modelToJSONObject]];
    }];
    return jsonDic;
}

@end
