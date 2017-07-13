//
//  RSPSearchItemsService.h
//  SketchPlugin
//
//  Created by aboyko on 7/5/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSPItemsSearching.h"
#import "RSPItem.h"

#define LOLDynamicCast(object, classType) ([(object) isKindOfClass:[classType class]]?((classType*)object):nil)
NS_ASSUME_NONNULL_BEGIN

@interface RSPSearchItemsService : NSObject <RSPItemsSearching>

///
/// Create search url
/// @param query search query
/// @param page page number
/// @return url
- (nullable NSURL *)urlWithQuery:(NSString *)query page:(NSUInteger)page;

///
/// Map server answer to model
/// @param data raw response from server
/// @return List of RSPItems
- (NSArray <RSPItem *> *)mapDataToModel:(NSData *)data;

///
/// Handle error from server
/// @param error server error
/// @param response http response
/// @return Modified error(if required)
- (NSError *)processError:(NSError *)error response:(NSURLResponse *)response;
@end

NS_ASSUME_NONNULL_END
