//
//  WLBWebLogManager.h
//  Expecta
//
//  Created by irobbin on 2019/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLBWebLogManager : NSObject

@property (readonly) BOOL isRunning;
@property (readonly) NSURL * serverURL;

+ (instancetype)sharedManager;
- (void)startServer;
- (void)stopServer;
- (void)sendEventWithChannel:(NSString *)channel eventName:(NSString *)eventName content:(NSString *)content parameters:(NSDictionary *)parameters;
- (void)sendLogWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
