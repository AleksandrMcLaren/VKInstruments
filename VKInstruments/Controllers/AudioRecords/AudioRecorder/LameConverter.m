//
//  LameConverter.m
//  VKInstruments
//
//  Created by Aleksandr on 11/07/2017.
//
//

#import "LameConverter.h"
#import "lame/lame.h"

@implementation LameConverter 

+ (NSString *)convertFromWavToMp3:(NSString *)filePath {
    
    NSMutableString *mp3FilePath = [[filePath stringByDeletingPathExtension] mutableCopy];
    [mp3FilePath appendString:@".mp3"];

    @try {
        int read, write;
        FILE *pcm = fopen([filePath UTF8String], "rb");  //source
        if (pcm == NULL) {
            perror("fopen");
            return nil;
        }
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192*2;
        const int MP3_SIZE = 8192*2;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        //# for constants of settings
        const int sampleRate = 22050;
        const int bitsPerSample = 16;
        const int numberOfChannels = 1;
        const int myBitRate = 320;
        
        //# for Lame settings
        lame_t lame = lame_init();
        lame_set_in_samplerate  (lame, sampleRate);
        lame_set_VBR            (lame, vbr_off);
        lame_set_brate          (lame, myBitRate);
        lame_init_params        (lame);
        
        lame_get_num_samples(lame);
        
        long long fileSize = [[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] objectForKey:NSFileSize] longLongValue];
        long duration = fileSize / (sampleRate * numberOfChannels * bitsPerSample / 8);//(fileSize * 8.0f) / (sampleRate * 2);

        lame_set_num_samples(lame, (duration * sampleRate));
        lame_get_num_samples(lame);
        
        float percent     = 0.0;
        int totalframes = lame_get_totalframes(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
            int frameNum    = lame_get_frameNum(lame);
            if (frameNum < totalframes)
                percent = (100. * frameNum / totalframes + 0.5);
            else
                percent = 100;
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        return nil;
    }
    @finally {
        return mp3FilePath;
    }
}

@end
