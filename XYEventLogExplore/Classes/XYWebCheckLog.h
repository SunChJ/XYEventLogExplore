//
//  XYWebCheckLog.h
//  XYDebugTools
//
//  Created by LUOHUA_Think on 2018/8/7.
//

#import <Foundation/Foundation.h>

@interface XYWebCheckLog : NSObject

//@property (nonatomic, assign, readonly) BOOL isServerRunning;
//@property (nonatomic, strong) NSMutableArray *logs;
//
+ (instancetype)shared;
//
- (void)logEventID:(NSString *)eventID params:(NSDictionary *)dictParams channel:(NSString *)channel;
- (void)logWithContent:(NSString *)content;
//- (NSString *)allEventLogs;
//- (NSString *)eventLogsWithChannel:(NSString *)channel filterKey:(NSString *)filterKey;

@end
