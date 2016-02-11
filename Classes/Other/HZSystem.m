//
//  HzSystem.m
//  ZHFramework
//
//  Created by xzh. on 15/7/23.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HzSystem.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
@implementation HZSystem

#pragma mark - sytemVersion
+ (BOOL)isIOS6Later
{
    return ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending );
}

+ (BOOL)isIOS7Later
{
    return ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending );
}

+ (BOOL)isIOS8Later
{
    return ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending );
}

+ (BOOL)isIOS9Later
{
    return ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending );
}

+ (BOOL)isIOS6Early
{
   return ![self isIOS6Later];
}

+ (BOOL)isIOS7Early
{
    return ![self isIOS7Later];
}

+ (BOOL)isIOS8Early
{
    return ![self isIOS8Later];
}

+ (BOOL)isIOS9Early
{
    return ![self isIOS9Later];
}

#pragma mark - DeviceSize
+ (BOOL)isIPhone35Inch
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isIPhone4Inch
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isIPhone47Inch
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isIPhone55Inch
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isIPhone4InchEarly
{
    return [self isIPhone35Inch] || [self isIPhone4Inch];
}

#pragma mark - Device Info
+ (NSString *)platform
{
    size_t size;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *machine = malloc(size);
    
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s";
    return @"";
}


+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}


+ (NSString *)deviceModel
{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)UUID
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)systemInfo
{
    return [NSString stringWithFormat:@"%@,%@,%@",[self deviceModel],[self systemVersion],[self UUID]];
}

static const char * __jb_app = NULL;
+ (BOOL)isJailBroken
{
    static const char * __jb_apps[] =
    {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    __jb_app = NULL;
    
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
            __jb_app = __jb_apps[i];
            return YES;
        }
    }
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
    {
        return YES;
    }
    
    if ( 0 == system("ls") )
    {
        return YES;
    }
    
    return YES;

}

+ (BOOL)isPhone
{
    NSString *model = [[UIDevice currentDevice] model];
    BOOL result = NO;
    if ([model rangeOfString:@"iPhone"].length != 0)
    {
        result = YES;
    }
    
    return result;
}

+ (BOOL)isPad
{
    NSString *model = [[UIDevice currentDevice] model];
    BOOL result = NO;
    if ([model rangeOfString:@"iPad"].length != 0)
    {
        result = YES;
    }

    return result;
}

#pragma mark - App Info
+ (NSString *)appVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if (0 == version.length ) version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersion"];
    
    return version;
}

+ (NSString *)appIdentifier
{
    NSString *identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return identifier;
}

@end
