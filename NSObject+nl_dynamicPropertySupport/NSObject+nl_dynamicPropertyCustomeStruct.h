//
//  NSObject+nl_dynamicPropertyPrivate.h
//  CategoryPropertyDynamicSupport
//
//  Created by 听榆大叔 on 15/11/24.
//  Copyright © 2015年 NL. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief  CMTime 和 CLLocationCoordinate2D 等 struct 需要导入相关的库后有
 *  这里是为了不用导入这些库也能原生支持这些 struct。
 *
 *  这里支持：
 *    CLLocationCoordinate2D
 *    MKCoordinateSpan
 *
 *    CMTime
 *    CMTimeRange
 *    CMTimeMapping
 *
 *    SCNVector3
 *    SCNVector4
 *    SCNMatrix4
 *
 *    与上述结构体的字段完全一致的结构也同样支持
 *
 */
@interface NSObject (nl_dynamicPropertyCustomeStruct)

@end
