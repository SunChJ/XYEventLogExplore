//
//  XYWebCheckLogger.m
//  XYDebugTools
//
//  Created by LUOHUA_Think on 2018/8/7.
//

#import "XYWebCheckLogger.h"
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServer.h>
#import "WLBWebLogManager.h"

@interface XYWebCheckLogger ()

@end


@implementation XYWebCheckLogger

+ (instancetype)shared
{
    static dispatch_once_t onceToken;

    static XYWebCheckLogger *shared;

    dispatch_once(&onceToken, ^{
        shared = [[XYWebCheckLogger alloc] init];
    });

    return shared;
}

- (BOOL)isAllowEventLog {
    return [WLBWebLogManager sharedManager].isRunning;
}

- (void)startServer
{
    [[WLBWebLogManager sharedManager] startServer];
}

- (void)stopServer
{
    [[WLBWebLogManager sharedManager] stopServer];
}

- (BOOL)isRunning
{
    return [WLBWebLogManager sharedManager].isRunning;
}

- (NSURL *)checkURL
{
    return [WLBWebLogManager sharedManager].serverURL;
}


@end
