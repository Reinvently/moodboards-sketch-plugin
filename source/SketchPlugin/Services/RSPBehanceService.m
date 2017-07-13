//
//  RSPBehanceService.m
//  SketchPlugin
//
//  Created by Boyko Andrey on 4/9/17.
//  Copyright © 2017 Reinvently. All rights reserved.
//

#import "RSPBehanceService.h"
#import "RSPLogger.h"
#import "Macros.h"

static NSString *const BehanceApiURL = @"https://api.behance.net/v2/projects?q=%@&page=%lu&client_id=OPuJSfVVGSacAPbxKBYGE6xeW4qKAA7u&sort=appreciations";

static NSInteger const BehanceLimitErrorCode = 429;

static NSString *const kBehanceApiProject = @"projects";

static NSString *const kBehanceApiCovers = @"covers";

static NSString *const kBehanceApiImageItem = @"404";

static NSString *const kBehanceApiName = @"name";

static NSString *const kBehanceApiURL = @"url";

NS_ASSUME_NONNULL_BEGIN

@implementation RSPBehanceService

#pragma mark - Public

///
/// @return Name of Search Service
- (NSString *)serviceName {
    return @"Behance";
}

#pragma mark - Url

///
/// Create search url
/// @param query search query
/// @param page page number
/// @return url
- (nullable NSURL *)urlWithQuery:(NSString *)query page:(NSUInteger)page {
    query = [query stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSString *urlStr = [NSString stringWithFormat:BehanceApiURL, query, page];
    RSPLog(urlStr);
    return [NSURL URLWithString:urlStr];
}

#pragma mark - Model mapping

///
/// Map server answer to model
/// @param data raw response from server
/// @return List of RSPItems
- (NSArray <RSPItem *> *)mapDataToModel:(NSData *)data {
    //parse json
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    jsonResponse = LOLDynamicCast(jsonResponse, NSDictionary);

    NSMutableArray <RSPItem *> *result = [NSMutableArray array];
    NSArray<NSDictionary *> *projects = LOLDynamicCast(jsonResponse[kBehanceApiProject], NSArray);

    for (NSDictionary *project in projects) {

        NSDictionary *cover = LOLDynamicCast(project[kBehanceApiCovers], NSDictionary);
        NSString *urlStr = LOLDynamicCast(cover[kBehanceApiImageItem], NSString);
        NSString *urlProject = LOLDynamicCast(project[kBehanceApiURL], NSString);
        NSString *nameProject = LOLDynamicCast(project[kBehanceApiName], NSString);

        if (urlStr == nil) {
            continue;
        }
        NSURL *tmpURL = [NSURL URLWithString:urlStr];
        if (tmpURL == nil) {
            continue;
        }

        RSPItem *item = [RSPItem new];
        item.imgURL = tmpURL;
        item.name = nameProject;
        item.itemURLString = urlProject;
        item.source = self.serviceName;
        [result addObject:item];

    }

    return [result copy];
}

#pragma mark - Error Handling

///
/// Handle error from server
/// @param error server error
/// @param response http response
/// @return Modified error(if required)
- (NSError *)processError:(NSError *)error response:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if (httpResponse.statusCode == BehanceLimitErrorCode) {
        error = [self errorToManyRequests];
    }
    return error;
}

///
/// A special error for situation where user rich max limit
/// @return error
- (NSError *)errorToManyRequests {
    NSString *errorMessage = RSPLocalizedString(@"You have sent too many search requests in a given amount of time. Please try again later");
    return [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
}
@end

NS_ASSUME_NONNULL_END
