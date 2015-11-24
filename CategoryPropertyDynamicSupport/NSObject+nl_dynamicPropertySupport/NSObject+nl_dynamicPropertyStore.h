//
//  NSObject+nl_dynamicProperty.h
//  CategoryPropertyDynamicSupport
//
//  Created by 听榆大叔 on 15/11/20.
//  Copyright © 2015年 NL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NLPropertyDescriptor.h"

@interface NSObject (nl_dynamicPropertyStore)

@property (nonatomic, strong, readonly) NSMutableDictionary * _Nullable nl_dynamicPropertyDictionary;
@property (nonatomic, strong, readonly) NSMapTable * _Nonnull nl_dynamicPropertyWeakDictionary;

+ (BOOL)nl_validDynamicProperty:(_Nonnull objc_property_t)objProperty;

+ (NSString * _Nullable)nl_dynamicPropertyNameWithSelctor:(_Nonnull SEL)selector;

+ (NLPropertyDescriptor * _Nullable)nl_descriptorWithSelector:(_Nonnull SEL)selector;

/**
 *  @brief  所有需要动态增加 getter、setter 方法的属性描述器
 *
 *  @return NSArray<NLPropertyDescriptor *>
 */
+ (NSArray<NLPropertyDescriptor *> * _Nullable)nl_dynamicPropertyDescriptors;

@end
