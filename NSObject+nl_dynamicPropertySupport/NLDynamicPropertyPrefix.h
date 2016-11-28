//
//  NLDynamicPropertyPrefix.h
//  CategoryPropertyDynamicSupport
//
//  Created by NathanLi on 28/11/2016.
//  Copyright © 2016 听榆大叔. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 可以通过定义宏：DynamicPropertySetPrefix 来定义动态属性的前辍名
 * 前辍名长度不能为 0，你应该定义成字母加下划线的形式，如下
 *
 * DynamicPropertySetPrefix("demo_")
 *
 * 注意，要在 m 文件中调用
 */
#define DynamicPropertySetPrefix(prefix)\
@interface NSObject (nl__dynamicPropertySetPre__) @end\
@implementation NSObject (nl__dynamicPropertySetPre__)\
- (const char * const)__nl_dynamicPropertyPrefix__ {\
  return prefix;\
}\
@end

/**
 *  @brief 动态属性前辍名
 *
 *  @return 前辍字符串
 */
extern const char * _Nullable nl_dynamicPropertyPrefix();


