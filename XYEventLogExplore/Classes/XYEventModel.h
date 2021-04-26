//
//  XYEventModel.h
//  AWSCore
//
//  Created by robbin on 2020/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYEventExtendModel : NSObject

@property (nonatomic, copy) NSString * key;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * type;

@end

@interface XYEventModel : NSObject

@property (nonatomic, copy) NSString * class_name;
@property (nonatomic, copy) NSString * event_id;
@property (nonatomic, copy) NSString * event_name;
@property (nonatomic, copy) NSString * event_params;
@property (nonatomic, copy) NSString * history_version;
@property (nonatomic, copy) NSNumber * id;
@property (nonatomic, copy) NSString * module_name;
@property (nonatomic, copy) NSString * operator;
@property (nonatomic, copy) NSNumber * state;
@property (nonatomic, copy) NSNumber * tag;
@property (nonatomic, copy) NSString * update_time;
@property (nonatomic, copy) NSString * version;
@property (nonatomic, copy) NSString * platform;
@property (nonatomic, copy) NSString * product;
@property (nonatomic, copy) NSString * remark_desc;

@property (nonatomic, strong) NSArray<XYEventExtendModel *> * extend;

@end

NS_ASSUME_NONNULL_END
