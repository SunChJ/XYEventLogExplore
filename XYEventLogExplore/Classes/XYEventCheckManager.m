//
//  XYEventCheckManager.m
//  AFNetworking
//
//  Created by robbin on 2020/3/27.
//

#import "XYEventCheckManager.h"
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>


@interface XYEventCheckManager ()

@property (nonatomic, strong) NSMutableArray<XYEventModel *> * willProcessList; // 等待处理的埋点

@end

@implementation XYEventCheckManager

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static XYEventCheckManager *sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[XYEventCheckManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)start {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self requestEventData];
    });
}

- (void)requestEventData {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * url = [NSString stringWithFormat:@"http://vcm.quvideo.vip/gh/api/event/query-list?product=%@&version=%@&platform=ios", @"2", version];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"response = %@", responseObject);
            NSArray<XYEventModel *> * eventList = [NSArray yy_modelArrayWithClass:XYEventModel.class json:responseObject[@"data"]];
            self.eventList = eventList;
            self.notShootList = eventList.mutableCopy;
            
            [self processWillProcessList];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
    }];
}

- (void)addEventWithChannel:(NSString *)channel eventName:(NSString *)eventName content:(NSString *)content parameters:(NSDictionary *)parameters {
    
    XYEventModel * eventModel = [XYEventModel new];
    eventModel.event_id = eventName;
    eventModel.event_params = content;
    
    if (parameters) {
        NSMutableArray<XYEventExtendModel *> * extend = [NSMutableArray arrayWithCapacity:parameters.count];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            XYEventExtendModel * extendItemModel = [XYEventExtendModel new];
            extendItemModel.key = key;
            if ([obj isKindOfClass:NSString.class]) {
                extendItemModel.type = @"string";
            } else if ([obj isKindOfClass:[NSNumber class]] && [self isNumberTypeWithObj:obj]) {
                extendItemModel.type = @"int";
            } else if ([obj isKindOfClass:[NSNumber class]] && [self isBooleanTypeWithObj:obj]) {
                extendItemModel.type = @"boolean";
            }
            
            [extend addObject:extendItemModel];
            
        }];
        eventModel.extend = extend;
    }

    [self processEvent:eventModel];
}

- (BOOL)isNumberTypeWithObj:(id)obj {
    // 判断是不是数字类型
    if ([obj isKindOfClass:[NSNull class]]) {
      return NO;
    }
    BOOL type = NO;
    if([obj isKindOfClass:[NSNumber class]])
    {
      if (strcmp([obj objCType], @encode(float)) == 0)
      {
        type = YES;
      }
      else if (strcmp([obj objCType], @encode(double)) == 0)
      {
        type = YES;
      }
      else if (strcmp([obj objCType], @encode(int)) == 0)
      {
        type = YES;
      }
      else if (strcmp([obj objCType], @encode(long)) == 0)
      {
        type = YES;
      }
    }
    
    return type;
}

- (BOOL)isBooleanTypeWithObj:(id)obj {
    if (strcmp([obj objCType], @encode(BOOL)) == 0)
    {
      return YES;
    }
    return NO;
}

- (void)processWillProcessList {
    [self.willProcessList enumerateObjectsUsingBlock:^(XYEventModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self processEvent:obj];
    }];
    
    [self.willProcessList removeAllObjects];
}

- (void)processEvent:(XYEventModel *)eventModel {
    if (self.eventList == nil) {
        [self.willProcessList addObject:eventModel];
    } else {
        // 是否已存在，且参数是否正确
        if ([self checkExistsToAlreadyShoot:eventModel] || [self checkExistsToParameterError:eventModel]) {
            return ;
        }
        
        // 不是当前版本埋点
        XYEventModel * currentVersionEvent = [self getCurrentVersionEvent:eventModel];
        if (!currentVersionEvent) {
            return ;
        }
        
        // 检查参数
        __block BOOL successExtendCheck = YES; // 通过参数检查
        [currentVersionEvent.extend enumerateObjectsUsingBlock:^(XYEventExtendModel * _Nonnull currentVersionEventObj, NSUInteger currentVersionEventIdx, BOOL * _Nonnull currentVersionEventStop) {
            
            __block BOOL isFindMatchKey = NO;
            __block BOOL isFindMatchKeyAndParameterCorrect = NO;
            
            isFindMatchKey = NO;
            isFindMatchKeyAndParameterCorrect = NO;
            
            [eventModel.extend enumerateObjectsUsingBlock:^(XYEventExtendModel * _Nonnull eventModelObj, NSUInteger eventModelIdx, BOOL * _Nonnull eventModelStop) {
                if ([eventModelObj.key isEqualToString:currentVersionEventObj.key]) {
                    isFindMatchKey = YES;
                    
                    if ([eventModelObj.type isEqualToString:currentVersionEventObj.type]) {
                        isFindMatchKeyAndParameterCorrect = YES;
                    }
                    
                    *eventModelStop = YES;
                }
            }];
            
            if (!isFindMatchKey || !isFindMatchKeyAndParameterCorrect) {
                successExtendCheck = NO;
                *currentVersionEventStop = YES;
            }
        }];
        
        if (successExtendCheck) {
            [self.alreadyShootList addObject:currentVersionEvent];
        } else {
            [self.shootButParameterErrorList addObject:currentVersionEvent];
        }
        [self.notShootList removeObject:currentVersionEvent];
        
        
    }
}

- (XYEventModel *)getCurrentVersionEvent:(XYEventModel *)eventModel {
    __block XYEventModel * shoot = NO;
    [self.eventList enumerateObjectsUsingBlock:^(XYEventModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.event_id isEqualToString:eventModel.event_id]) {
            shoot = obj;
            *stop = YES;
        }
    }];
    
    return shoot;
}

- (BOOL)checkExistsToParameterError:(XYEventModel *)eventModel {
    __block BOOL shoot = NO;
    [self.shootButParameterErrorList enumerateObjectsUsingBlock:^(XYEventModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.event_id isEqualToString:eventModel.event_id]) {
            shoot = YES;
            *stop = YES;
        }
    }];
    
    return shoot;
}

- (BOOL)checkExistsToAlreadyShoot:(XYEventModel *)eventModel {
    __block BOOL alreadyShoot = NO;
    [self.alreadyShootList enumerateObjectsUsingBlock:^(XYEventModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.event_id isEqualToString:eventModel.event_id]) {
            alreadyShoot = YES;
            *stop = YES;
        }
    }];
    
    return alreadyShoot;
}

- (NSMutableArray<XYEventModel *> *)willProcessList {
    if (!_willProcessList) {
        _willProcessList = [NSMutableArray arrayWithCapacity:10];
    }
    return _willProcessList;
}

- (NSMutableArray<XYEventModel *> *)alreadyShootList {
    if (!_alreadyShootList) {
        _alreadyShootList = [NSMutableArray arrayWithCapacity:10];
    }
    return _alreadyShootList;
}

- (NSMutableArray<XYEventModel *> *)shootButParameterErrorList {
    if (!_shootButParameterErrorList) {
        _shootButParameterErrorList = [NSMutableArray arrayWithCapacity:10];
    }
    return _shootButParameterErrorList;
}

@end
