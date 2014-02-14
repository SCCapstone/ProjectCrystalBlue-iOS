//
//  LocalImageStore.h
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AbstractMobileImageStore.h"

@interface LocalImageStore : AbstractMobileImageStore {
    NSString *localDirectory;
}

@end
