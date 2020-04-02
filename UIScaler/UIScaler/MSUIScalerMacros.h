#ifndef MSUIScalerMacros_h
#define MSUIScalerMacros_h

#import "map.h"

#define MSUIScalerPointMake(ref, samp) \
    [[MSUIScalerPoint alloc] initWithReference:MSUIScalerConstants.ref sample:samp],

#define MSUIScalerPointMakeWithPair(pair) \
    MSUIScalerPointMake pair

#define MSUIScalerMake(...) \
    [MSUIScaler samples:@[ MAP(MSUIScalerPointMakeWithPair, __VA_ARGS__) ]]

#endif /* MSUIScalerMacros_h */
