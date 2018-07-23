//
//  TTPMacros.h
//  TTWebbrowserDemo
//
//  Created by Zeaple on 2018/7/16.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#ifndef TTPMacros_h
#define TTPMacros_h

/** DEBUG LOG **/
#ifdef DEBUG

#define TTPLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define TTPLog( s, ... )

#endif

#endif /* TTPMacros_h */
