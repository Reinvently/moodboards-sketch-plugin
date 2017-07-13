//
// Created by Boyko Andrey on 3/25/17.
// Copyright (c) 2017 Reinvently. All rights reserved.
//

#import "RSPLogger.h"

NS_ASSUME_NONNULL_BEGIN

@implementation RSPLogger

- (void)appendToMyTextView:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[text stringByAppendingString:@"\n"]];
        [[self.textView textStorage] appendAttributedString:attr];
    });
}

+ (instancetype)sharedLogger {
    static RSPLogger *StaticLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        StaticLogger = [RSPLogger new];
    });
    return StaticLogger;
}

- (void)logMessage:(NSString *)string {
    NSLog(@"RSPlugin %@", string);
    [self appendToMyTextView:string];
}
@end

NS_ASSUME_NONNULL_END
