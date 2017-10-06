 # Fast Lane Sample App using UDP Sockets

## Background

Fastlane allows applications on iOS devices which are connected to Cisco Wi-Fi Access  points to prioritize their traffic; Such prioritization allows the apps to deliver best experience in the enterprises.

App traffic on Wi-Fi networks can be broadly classified as: **Voice**, **Video**, **Best Effort** and **Background**. Double clicking on each of the traffic types: 

> •	Voice: This is interactive voice for apps using Wi-Fi Calling (CallKit), Cisco Spark,  Facetime or any other Voice app.
> 
>  
> •	Video: This is video traffic using Wi-Fi Calling (CallKit),  Cisco Spark, Facetime or video capabilities within the app.

> •	Best Effort: Examples of data include instant messaging, VPN tunneling, audio/video streaming, signaling, screen sharing etc. 
> 
> •	Background: These apps include photo/media uploads or backups. 

Also, take a look at [https://developer.apple.com/library/content/qa/qa1934/_index.html](https://developer.apple.com/library/content/qa/qa1934/_index.html) to see how to set the service types for the different networking API within iOS.


## Let's get Started

### Setup:

Clone this repository

```
$ git clone https://github.com/CiscoDevNet/fastlane-udp-client-app.git
```

You now have the code available locally on your Mac.

### Edit the code in Xcode:

#### 1. In Xcode (Navigator) open UdpEchoClient -> UdpEchoClient -> ViewController.m

Remember this is a UDP client. iOS 10+ SDK defines the following for UDP sockets:



Check ***_setupSocket_*** method (uncomment a part of code, responsible for marking) and Set one of the above service type options for marking the socket for `optval` variable:

```

/ Choose from one the following service types
// Hint: For the UDP Client here it will be NET_SERVICE_TYPE_RD
//

/*
* NET_SERVICE_TYPE_BE
* NET_SERVICE_TYPE_BK
* NET_SERVICE_TYPE_VI
* NET_SERVICE_TYPE_VO
* NET_SERVICE_TYPE_RV
* NET_SERVICE_TYPE_AV
* NET_SERVICE_TYPE_OAM
* NET_SERVICE_TYPE_RD
* /

optval = NET_SERVICE_TYPE_BE; /* defualt */
         optlen = sizeof(optval);
        if(setsockopt(socketFD, SOL_SOCKET, SO_NET_SERVICE_TYPE, &optval, optlen) < 0) {
            perror("setsockopt()");
        }

```



### 2. Compile project and run it on your iOS device

### 3. Are you already on a Fast Lane Enabled network?
Download the [Fast Lane QoS Testing App](https://itunes.apple.com/us/app/fast-lane-qos/id1217974755?mt=8) which tells you if your network is Fast Lane Enabled or not.

### 4. How do you know if your changes really work or not? 
Check out Cisco DevNet. DevNet has a [Fast Lane Validation lab](https://devnet.cisco.com/site/fast-lane/) where you as a developer can submit your app for validation on a live enterprise network.

