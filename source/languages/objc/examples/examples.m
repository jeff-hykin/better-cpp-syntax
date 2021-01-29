- (nonnull NSArray<NSString *> *)getCameras {
    // get list of regular cameras
    AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession 
        discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
        mediaType:AVMediaTypeVideo 
        position:AVCaptureDevicePositionUnspecified];

    // create json object for each camera
    NSMutableArray<NSString *> *lst = [[NSMutableArray alloc] init];
    for (AVCaptureDevice *device in session.devices) {
        NSString *s = @"{ ";
        s = [s stringByAppendingFormat:@"\"id\": %@, ", device.uniqueID];
        s = [s stringByAppendingFormat:@"\"facing\": %@, ", device.position == AVCaptureDevicePositionFront ? @"front" : @"back"];
        s = [s stringByAppendingFormat:@"\"orientation\": 0, "];
        s = [s stringByAppendingFormat:@"\"forcedShutterSound\": false"];
        s = [s stringByAppendingString:@" }"];
        [lst addObject:s];
    }

    return lst;
}