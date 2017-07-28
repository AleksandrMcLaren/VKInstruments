//
//  LameConverter.h
//  VKInstruments
//
//  Created by Aleksandr on 11/07/2017.
//
//

#ifndef LameConverter_h
#define LameConverter_h

#import <Foundation/Foundation.h>

@interface LameConverter : NSObject

+ (NSString *)convertFromWavToMp3:(NSString *)filePath;

@end

#endif /* LameConverter_h */
