//
//  HZGlobalConstVarables.m
//  AnhuiNews
//
//  Created by History on 14-9-22.
//  Copyright (c) 2014年 ahxmt. All rights reserved.
//

#include "HZGlobalConstVarables.h"

/**
 *
 */
CGFloat const kZANGlobalAnimationDuration      = 0.3f;

/**
 * UserDefault
 */
NSString * const kZANNewsContentFontSize       = @"com.ahn.content.font.size";

NSString * const kZANAppShowLaunchHelper       = @"com.ahn.show.launch.helper.version.3.0.1";

NSString * const kZANADImageURL                = @"com.ahn.adimage.url";

NSString * const kZANADImageExpireDate         = @"com.ahn.adimage.expire.date";

NSString * const kZANLaunchImageShouldDownload = @"com.ahn.should.download.adimage";
NSString * const kZANLaunchImageNewsId         = @"com.ahn.launch.image.news.id";
NSString * const kZANLaunchImageNewsMode       = @"com.ahn.launch.image.news.mode";
NSString * const kZANLaunchImageNewsOutLinkURL = @"com.ahn.launch.image.news.out.link.url";


NSString * const kZANLocalColumnDate           = @"com.ahn.local.column.date";
NSString * const kZANLocalCityDate             = @"com.ahn.local.city.date";

/**
 *  UM Event
 */
NSString * const kUMPvHomeVc                   = @"ahnews.HomeVc";
NSString * const kUMPvUserVc                   = @"ahnews.UserVc";
NSString * const kUMPvInteractionVc            = @"ahnews.InteractionVc";
NSString * const kUMPvDiscoverVc               = @"ahnews.DiscoverVc";
NSString * const kUMPvNormalNewsDetailVc       = @"ahnews.NewsDetailVc";
NSString * const kUMPvLinkNewsDetailVc         = @"ahnews.LinkNewsDetailVc";
NSString * const kUMPvImageSetNewsDetailVc     = @"ahnews.ImageSetNewsDetailVc";
NSString * const kUMPvSubscribeSubjectNewsVc   = @"ahnews.SubscribeSubjectNewsVc";
NSString * const kUMPvSubscribeVc              = @"ahnews.SubscribeVc";
NSString * const kUMPvSpecialNewsListVc        = @"ahnews.SpecialNewsListVc";
NSString * const kUMPvSpecialBlockListVc       = @"ahnews.TopicBlockListVc";
NSString * const kUMPv24HotNewsVc              = @"ahnews.24HotNewsVc";
NSString * const kUMPvActivityNewsVc           = @"ahnews.ActivityNews";
NSString * const kUMPvGovernorNewsVc           = @"ahnews.GovernorNewsVc";
NSString * const kUMPvSecretaryNewsVc          = @"ahnews.GovernorNewsVc";
NSString * const kUMPvSearchNewsVc             = @"ahnews.SearchNewsVc";
NSString * const kUMPvSystemMessageVc          = @"ahnews.SystemMessageVc";
NSString * const kUMPvMallVc                   = @"ahnews.MallVc";

NSString * const kUMPvVolunteerActivityVc      = @"ahnews.VolunteerActivityVc";
NSString * const kUMPvVolunteerHomeVc          = @"ahnews.VolunteerHomeVc";
NSString * const kUMPvVolunteerNewsVc          = @"ahnews.VolunteerNewsVc";



/**
 *  GLOBAL TIP
 */
NSString * const kZANNotInWIFI                 = @"您当前处于非WIFI状态";
NSString * const kZANNoNetworking              = @"您当前无网络,请设置您的网络";
NSString * const kZANGlobalRequestError        = @"请求数据失败,请重试";
NSString * const kZANJSONParseError            = @"解析数据失败,工程师正在努力解决";
NSString * const kZANNotLoginMessage           = @"奇怪的事情发生了，请重新登录重试";

/**
 *  WebView Key
 */
NSString * const kWebViewSchemeZANKey          = @"ahnews";
NSString * const kWebViewSchemeHttpKey         = @"http";
NSString * const kWebViewSchemeHttpsKey        = @"https";
NSString * const kWebViewHostErrorKey          = @"error";
NSString * const kWebViewHostLikeKey           = @"like";
NSString * const kWebViewHostCriticismKey      = @"criticism";
NSString * const kWebViewHostOpenImageKey      = @"openimage";
NSString * const kWebViewHostOpenAudioKey      = @"openaudio";
NSString * const kWebViewHostOpenVideoKey      = @"openvideo";
NSString * const kWebViewHostImageCountKey     = @"imagecount";
NSString * const kWebViewHostRelativeKey       = @"relative";
NSString * const kWebViewHostOpenQrCodeKey     = @"openqrcode";
NSString * const kWebViewHostOpenBrokenKey     = @"openbroken";
NSString * const kWebViewHostOpenNewsKey       = @"opennews";
NSString * const kWebViewHostOpenEPaperKey     = @"openepaper";

NSString * const kWebViewQueryImageIndexKey    = @"index";

NSTimeInterval const kZANNewsCacheTimeInterval = 300;

NSInteger const kZANMaxPageOfNewsList          = 20;

NSString * const kZANCityArray[]               = {
    @"合肥", @"淮北", @"亳州",  @"宿州", @"蚌埠", @"阜阳", @"淮南", @"滁州", @"六安", @"马鞍山", @"芜湖", @"宣城", @"铜陵", @"池州", @"安庆", @"黄山",
};
