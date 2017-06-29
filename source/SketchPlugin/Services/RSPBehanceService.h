//
//  RSPBehanceService.h
//  SketchPlugin
//
//  Created by Boyko Andrey on 4/9/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSPItem.h"
NS_ASSUME_NONNULL_BEGIN
@interface RSPBehanceService : NSObject
///
/// Loading bunch of items
/// @param query - search query
/// @param page - page number
/// @param completionHandler - completion handler
- (void) getItems:(NSString *)query
             page:(NSUInteger)page
completionHandler:(void (^)(NSArray<RSPItem *> *__nullable url, NSError *__nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
