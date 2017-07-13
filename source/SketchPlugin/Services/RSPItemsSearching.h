//
//  RSPItemsSearching.h
//  SketchPlugin
//
//  Created by aboyko on 7/5/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSPItem;
NS_ASSUME_NONNULL_BEGIN

@protocol RSPItemsSearching <NSObject>

///
/// Allow to suspend service for stop sending requests
/// suspended service always return empty answer @[]
/// return
@property BOOL suspended;

///
/// Loading bunch of items
/// @param query - search query
/// @param page - page number
/// @param completionHandler - completion handler
- (void) getItems:(NSString *)query
             page:(NSUInteger)page
completionHandler:(void (^)(NSArray<RSPItem *> *__nullable url, NSError *__nullable error))completionHandler;

///
/// @return Name of Search Service
- (NSString *)serviceName;
@end

NS_ASSUME_NONNULL_END
