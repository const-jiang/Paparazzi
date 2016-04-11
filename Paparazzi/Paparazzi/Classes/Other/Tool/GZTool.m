//
//  GZTool.m
//  Paparazzi
//
//  Created by jiangtian on 16-4-11.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZTool.h"
#import "AFNetworking.h"

@implementation GZTool

+ (void)parseVideoURL:(NSString *)videoURL  success:(void (^)(NSString * url))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *video_url = videoURL;
    
    NSDictionary *jsonDic = @{
                              @"appendix" : @{
                                      @"site" : @"",
                                      @"nextStep" : @""
                                      },
                              @"cmd_results" : @[
                                      @""
                                      ],
                              @"mobileInfo" : @{
                                      @"manufacturer" : @"apple",
                                      @"model" : @"iPhone",
                                      @"systemver" : @"9.2.1",
                                      @"type" : @"ios",
                                      @"appver" : @"4"
                                      },
                              @"resource" : @{
                                      @"url" : video_url,
                                      @"mplay_link" : @"",
                                      @"cookie" : @""
                                      }
                              };
    
    
    
    NSString *jsonStr = [self DataTOjsonString:jsonDic];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"data"] = jsonStr;
    
    
    NSString *url = @"http://v.sogou.com/playservice/";
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
//          NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//          NSLog(@"%@",aString);
          
          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
          
          NSArray *result_datas =  dict[@"result_data"];
          if (result_datas.count) {
              NSString *url = [result_datas[0][@"videos"] firstObject];
              if (success) {
                  success(url);
              }
              
          }else{
              // 如果 result_data 没值
              // 先发送一次get请求
              NSDictionary *cmd_request = dict[@"cmds"][0][@"cmd_request"];
              NSString *url = cmd_request[@"url"];
              
              AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
              mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
              
              [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  // dataString 可作为 二次post请求时 data  对应的值
                  NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  
                  //获取appendix的值
                  NSDictionary *appendix = dict[@"appendix"];
                  
                  //获取cmd_request的值
                  NSDictionary *cmd_request = dict[@"cmds"][0][@"cmd_request"];
                  //获取cmd_name的值
                  NSString *cmd_name = dict[@"cmds"][0][@"cmd_name"];
                  
                  
                  //设置 Date、X-TT-LOGID对应的值
                  NSDate *date = [NSDate date];
                  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                  NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                  [dateFormatter setTimeZone:GTMzone];
                  
                  //@"Thu, 31 Mar 2016 09:34:16 GMT"
                  //@"EEE, dd MMM yyyy HH:mm:ss zzz"
                  [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
                  NSString *dateString = [dateFormatter stringFromDate:date];
                  
                  //20160331173416 + 0100040230463760
                  [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
                  NSString *logid = [NSString stringWithFormat:@"%@%@",[dateFormatter stringFromDate:date],[self randomString]];
                  
                  //设置header对应的值
                  NSDictionary *headerDic =  @{
                                               @"Content-Type":@"text/html; charset=utf-8",
                                               @"Access-Control-Allow-Origin":@"http://mp.toutiao.com",
                                               @"Proxy-Connection":@"Keep-alive",
                                               @"Content-Encoding":@"gzip",
                                               @"Server":@"nginx/1.9.6",
                                               @"Access-Control-Allow-Methods":@"POST,GET,OPTIONS",
                                               @"Transfer-Encoding":@"Identity",
                                               @"Access-Control-Allow-Headers":@"Content-Type,accept,content-disposition,content-range",
                                               @"Date":dateString,
                                               @"X-TT-LOGID":logid,
                                               @"Vary":@"Accept-Encoding, Accept-Encoding",
                                               @"X-Frame-Options":@"SAMEORIGIN"
                                               };
                  NSString *header = [self DataTOjsonString:headerDic];
                  
                  
                  NSDictionary *jsonDic = @{
                                            @"appendix":appendix,
                                            @"cmd_results":@[
                                                    @{
                                                        @"cmd_request":cmd_request,
                                                        @"cmd_name":cmd_name,
                                                        @"cmd_response":@{
                                                                @"data":dataString,
                                                                @"header":header
                                                                }
                                                        }
                                                    ],
                                            @"mobileInfo":@{
                                                    @"manufacturer":@"apple",
                                                    @"model":@"iPhone",
                                                    @"systemver":@"9.2.1",
                                                    @"type":@"ios",
                                                    @"appver":@"4"
                                                    },
                                            @"resource":@{
                                                    @"url":video_url,
                                                    @"mplay_link":@"",
                                                    @"cookie":@""
                                                    }
                                            };
                  
                  NSString *jsonStr = [self DataTOjsonString:jsonDic];
                  NSMutableDictionary *params = [NSMutableDictionary dictionary];
                  params[@"data"] = jsonStr;
                  NSString *requstURL = @"http://v.sogou.com/playservice/";
                  
                  AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
                  mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
                  [mgr POST:requstURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
//                      NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                      NSLog(@"***:%@",aString);
                      
                      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                      
                      NSArray *result_datas =  dict[@"result_data"];
                      if (result_datas.count) {
                          NSString *url = [result_datas[0][@"videos"] lastObject];
                          if (success) {
                              success(url);
                          }
                          
                      }else{
                          if (failure) {
                              failure(nil);
                          }
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      if (failure) {
                          failure(error);
                      }
                  }];
                  
                  
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (failure) {
                      failure(error);
                  }
              }];
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (NSString* )DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#define RNum arc4random_uniform(10)
//返回一个16位的随机数字符串
+ (NSString* )randomString
{
    NSString *string = [NSString stringWithFormat:@"010004023%d%d%d%d%d%d%d",RNum,RNum,RNum,RNum,RNum,RNum,RNum];
    return string;
}


@end
