//
//  WLBWebLogManager.m
//  Expecta
//
//  Created by irobbin on 2019/3/16.
//

#import "WLBWebLogManager.h"
#import <GCDWebServer/GCDWebServer.h>
#import "WLBWebLogDatasource.h"
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import "XYEventCheckManager.h"

@interface WLBWebLogManager ()

@property (nonatomic, strong) GCDWebServer * webServer;
@property (nonatomic, strong) WLBWebLogDatasource * datasource;

@end

@implementation WLBWebLogManager

+ (instancetype)sharedManager {
    static WLBWebLogManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[WLBWebLogManager alloc] init];
    });
    return staticInstance;
}

- (NSURL *)serverURL {
    return self.webServer.serverURL;
}

- (WLBWebLogDatasource *)datasource {
    if (_datasource == nil) {
        _datasource = [WLBWebLogDatasource new];
    }
    return _datasource;
}

- (BOOL)isRunning {
    return self.webServer && self.webServer.isRunning;
}

- (void)startServer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.webServer = [GCDWebServer new];
        
        __weak WLBWebLogManager * weakSelf = self;
        [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
            
            if ([request.path isEqualToString:@"/get_more_event"]) {
                GCDWebServerDataResponse * response = [GCDWebServerDataResponse responseWithJSONObject:(id)[weakSelf.datasource getEvents]];
                return response;
            } else if ([request.path isEqualToString:@"/get_more_log"]) {
                GCDWebServerDataResponse * response = [GCDWebServerDataResponse responseWithJSONObject:(id)[weakSelf.datasource getLogs]];
                return response;
            } else if ([request.path isEqualToString:@"/get_total_map"]) {
                // 获取全部埋点
                GCDWebServerDataResponse * response = [GCDWebServerDataResponse responseWithJSONObject:(id)[weakSelf.datasource getTotalMap]];
                return response;
            } else if ([request.path isEqualToString:@"/get_correct_map"]) {
                // 获取正确埋点
                GCDWebServerDataResponse * response = [GCDWebServerDataResponse responseWithJSONObject:(id)[weakSelf.datasource getCorectMap]];
                return response;
            }  else if ([request.path isEqualToString:@"/get_left_map"]) {
                // 获取剩余埋点
                GCDWebServerDataResponse * response = [GCDWebServerDataResponse responseWithJSONObject:(id)[weakSelf.datasource getLeftMap]];
                return response;
            }  else if ([request.path isEqualToString:@"/get_error_map"]) {
                // 获取错误埋点
                GCDWebServerDataResponse * response = [GCDWebServerDataResponse responseWithJSONObject:(id)[weakSelf.datasource getErrorMap]];
                return response;
            }  else {
                return [weakSelf getIndexHTMLResponse];
            }
            return nil;
        }];
        
        [self.webServer startWithOptions:@{GCDWebServerOption_AutomaticallySuspendInBackground : @(NO), GCDWebServerOption_Port : @(8086)} error:NULL];
        
        [[XYEventCheckManager sharedInstance] start];
    });
}

- (void)stopServer {
    [self.webServer stop];
}

- (void)sendEventWithChannel:(NSString *)channel eventName:(NSString *)eventName content:(NSString *)content parameters:(NSDictionary *)parameters {
    [self.datasource addEventWithChannel:channel eventName:eventName content:content parameters:parameters];
}

- (void)sendLogWithContent:(NSString *)content {
    [self.datasource addLogWithContent:content];
}

- (GCDWebServerDataResponse *)getIndexHTMLResponse {
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [mainBundlePath stringByAppendingPathComponent:@"XYEventLogExplore.bundle"];
    NSString * path = [bundlePath stringByAppendingPathComponent:@"index.html"];
    NSString * indexString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    indexString = [indexString stringByReplacingOccurrencesOfString:@"{host}" withString:self.webServer.serverURL.absoluteString];
    
    GCDWebServerDataResponse * response = [GCDWebServerDataResponse responseWithHTML:indexString];
    return response;
}

@end
