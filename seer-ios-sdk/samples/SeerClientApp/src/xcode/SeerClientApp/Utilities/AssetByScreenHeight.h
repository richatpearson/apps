//
//  AssetByScreenHeight.h
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

// iPhone 5 support
#define ASSET_BY_SCREEN_HEIGHT(regular) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : [regular stringByAppendingString:@"-568h"])

@interface AssetByScreenHeight : NSObject

@end
