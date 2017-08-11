//
// Created by Boyko Andrey on 3/25/17.
// Copyright (c) 2017 Reinvently. All rights reserved.
//

@import AppKit;
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSPLogger : NSObject

@property(strong) NSTextView *textView;

+ (instancetype)sharedLogger;

- (void)logMessage:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
#define RSPLog(message) [RSPLogger.sharedLogger logMessage:message];
