# fastlane-udp-client-app

## 1. In Xcode (Navigator) open UdpEchoClient -> UdpEchoClient -> ViewController.m

Check setupSocket method (uncomment a part of code, responsible for marking) and Set one of the following parameters for `optval` variable:

* NET_SERVICE_TYPE_BE
* NET_SERVICE_TYPE_BK
* NET_SERVICE_TYPE_VI
* NET_SERVICE_TYPE_VO
* NET_SERVICE_TYPE_RV
* NET_SERVICE_TYPE_AV
* NET_SERVICE_TYPE_OAM
* NET_SERVICE_TYPE_RD

## 3. Compile project and run it on your iOS device
