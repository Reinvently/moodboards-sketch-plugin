//
//  RSPSketchService.h
//  SketchPlugin
//
//  Created by Boyko Andrey on 3/25/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "RSPItem.h"
NS_ASSUME_NONNULL_BEGIN
@interface RSPSketchService : NSObject
///
/// Create moodboards
/// @param items Images
/// @param moodboardConfig Configuration
/// @param document parent document
- (void)createMoodboardsWithItems:(NSArray<RSPItem *> *)items moodboardConfig:(RSPMoodboardConfig)moodboardConfig document:(id)document;
@end
NS_ASSUME_NONNULL_END
