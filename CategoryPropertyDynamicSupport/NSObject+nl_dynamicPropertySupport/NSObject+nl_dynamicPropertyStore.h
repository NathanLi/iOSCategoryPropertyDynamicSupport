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

/**
 *  @brief  用来存储自动生成的 `getter`、`setter` 操作的数据
 */
@property (nonatomic, strong, readonly) NSMutableDictionary * _Nullable nl_dynamicPropertyDictionary;

/**
 *  @brief 用来存储自动生成的 `getter`、`setter` 操作的 __weak 类型的数据
 */
@property (nonatomic, strong, readonly) NSMapTable * _Nonnull nl_dynamicPropertyWeakDictionary;

/**
 *  @brief 判断属性是否应该自动生成方法
 *
 *  @param objProperty 需要判断的属性
 *
 *  @return 如果是，则返回 YES；否则返回 NO；
 */
+ (BOOL)nl_validDynamicProperty:(_Nonnull objc_property_t)objProperty;

/**
 * 获取该选择子对应的属性名
 */
+ (NSString * _Nullable)nl_dynamicPropertyNameWithSelctor:(_Nonnull SEL)selector;

/**
 * 获取该选择子对应的属性描述器
 */
+ (NLPropertyDescriptor * _Nullable)nl_descriptorWithSelector:(_Nonnull SEL)selector;

/**
 *  @brief  所有需要动态增加 getter、setter 方法的属性描述器
 *
 *  @return NSArray<NLPropertyDescriptor *>
 */
+ (NSArray<NLPropertyDescriptor *> * _Nullable)nl_dynamicPropertyDescriptors;

@end
