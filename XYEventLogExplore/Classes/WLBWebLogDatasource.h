//
//  WLBWebLogDatasource.h
//  Expecta
//
//  Created by irobbin on 2019/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLBWebLogDatasource : NSObject

- (NSArray *)getEvents;
- (NSArray *)getLogs;

- (NSDictionary *)getTotalMap;
- (NSDictionary *)getCorectMap;
- (NSDictionary *)getLeftMap;
- (NSDictionary *)getErrorMap;

- (void)addEventWithChannel:(NSString *)channel eventName:(NSString *)eventName content:(NSString *)content parameters:(NSDictionary *)parameters;
- (void)addLogWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
