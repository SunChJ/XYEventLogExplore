//
//  XYEventCheckManager.h
//  AFNetworking
//
//  Created by robbin on 2020/3/27.
//

#import <Foundation/Foundation.h>
#import "XYEventModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYEventCheckManager : NSObject

@property (nonatomic, strong) NSArray<XYEventModel *> * eventList;
@property (nonatomic, strong) NSMutableArray<XYEventModel *> * notShootList; // 未命中
@property (nonatomic, strong) NSMutableArray<XYEventModel *> * alreadyShootList; // 已命中
@property (nonatomic, strong) NSMutableArray<XYEventModel *> * shootButParameterErrorList; // 已命中，但参数错误

+ (instancetype)sharedInstance;

- (void)addEventWithChannel:(NSString *)channel eventName:(NSString *)eventName content:(NSString *)content parameters:(NSDictionary *)parameters;

- (void)start;

@end

NS_ASSUME_NONNULL_END
