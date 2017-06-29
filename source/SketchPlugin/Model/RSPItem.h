//
//  RSPItem.h
//  SketchPlugin
//
//  Created by aboyko on 6/20/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface RSPItem : NSObject
@property (copy) NSURL *imgURL;
@property (copy, nullable) NSString *name;
@property (copy, nullable) NSString *itemURLString;
@end
NS_ASSUME_NONNULL_END
