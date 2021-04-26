//
//  XYEventModel.m
//  AWSCore
//
//  Created by robbin on 2020/3/30.
//

#import "XYEventModel.h"

@implementation XYEventModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"extend" : [XYEventExtendModel class]};
}

@end

@implementation XYEventExtendModel



@end
