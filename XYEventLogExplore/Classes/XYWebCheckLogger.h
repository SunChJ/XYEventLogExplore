//
//  XYWebCheckLogger.h
//  XYDebugTools
//
//  Created by LUOHUA_Think on 2018/8/7.
//

#import <Foundation/Foundation.h>

@interface XYWebCheckLogger : NSObject

+ (instancetype)shared;

@property (nonatomic, assign, readonly) BOOL isAllowEventLog;
//@property (nonatomic, assign) BOOL awalaysRecord;
//
- (void)startServer;
- (void)stopServer;
- (BOOL)isRunning;
//
- (NSURL *)checkURL;

@end
