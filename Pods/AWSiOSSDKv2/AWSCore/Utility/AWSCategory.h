/*
 * Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const AWSDateRFC822DateFormat1;
FOUNDATION_EXPORT NSString *const AWSDateISO8601DateFormat1;
FOUNDATION_EXPORT NSString *const AWSDateISO8601DateFormat2;
FOUNDATION_EXPORT NSString *const AWSDateISO8601DateFormat3;
FOUNDATION_EXPORT NSString *const AWSDateShortDateFormat1;

@interface NSDate (AWS)

+ (NSDate *)aws_dateFromString:(NSString *)string;
+ (NSDate *)aws_dateFromString:(NSString *)string format:(NSString *)dateFormat;
- (NSString *)aws_stringValue:(NSString *)dateFormat;

/**
 * Set the clock skew for the current device.  This clock skew will be used for calculating
 * signatures to AWS signatures and for parsing/converting date values from responses.
 *
 * @param clockskew the skew (in seconds) for this device.  If the clock on the device is fast, pass positive skew to correct.  If the clock on the device is slow, pass negative skew to correct.
 */
+ (void)aws_setRuntimeClockSkew:(NSTimeInterval)clockskew;

/**
 * Get the clock skew for the current device.
 *
 * @return the skew (in seconds) currently set for this device.  Positive clock skew implies the device is fast, negative implies the device is slow.
 */
+ (NSTimeInterval)aws_getRuntimeClockSkew;

+ (NSDate *)aws_getDateFromMessageBody:(NSString *)messageBody;

@end

@interface NSDictionary (AWS)

- (NSDictionary *)aws_removeNullValues;
- (id)aws_objectForCaseInsensitiveKey:(id)aKey;

@end

@interface NSObject (AWS)

- (NSDictionary *)aws_properties;

- (void)aws_copyPropertiesFromObject:(NSObject *)object;
- (BOOL)aws_isDNSBucketName:(NSString *)theBucketName;
- (BOOL)aws_isVirtualHostedStyleCompliant:(NSString *)theBucketName;

@end

@interface NSString (AWS)

- (BOOL)aws_isBase64Data;
- (NSString *)aws_stringWithURLEncoding;
- (NSString *)aws_stringWithURLEncodingPath;
- (NSString *)aws_md5String;

@end

@interface NSURL (AWS)

- (NSURL *)aws_URLByAppendingQuery:(NSDictionary *)query;

@end
