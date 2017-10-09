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

```
/*
* Network Service Type for option SO_NET_SERVICE_TYPE
*
* The vast majority of sockets should use Best Effort that is the default
* Network Service Type. Other Network Service Types have to be used only if
* the traffic actually matches the description of the Network Service Type.
*
* Network Service Types do not represent priorities but rather describe
* different categories of delay, jitter and loss parameters.
* Those parameters may influence protocols from layer 4 protocols like TCP
* to layer 2 protocols like Wi-Fi. The Network Service Type can determine
* how the traffic is queued and scheduled by the host networking stack and
* by other entities on the network like switches and routers. For example
* for Wi-Fi, the Network Service Type can select the marking of the
* layer 2 packet with the appropriate WMM Access Category.
*
* There is no point in attempting to game the system and use
* a Network Service Type that does not correspond to the actual
* traffic characteristic but one that seems to have a higher precedence.
* The reason is that for service classes that have lower tolerance
* for delay and jitter, the queues size is lower than for service
* classes that are more tolerant to delay and jitter.
*
* For example using a voice service type for bulk data transfer will lead
* to disastrous results as soon as congestion happens because the voice
* queue overflows and packets get dropped. This is not only bad for the bulk
* data transfer but it is also bad for VoIP apps that legitimately are using
* the voice  service type.
*
* The characteristics of the Network Service Types are based on the service
* classes defined in RFC 4594 "Configuration Guidelines for DiffServ Service
* Classes"
*
* When system detects the outgoing interface belongs to a DiffServ domain
* that follows the recommendation of the IETF draft "Guidelines for DiffServ to
* IEEE 802.11 Mapping", the packet will marked at layer 3 with a DSCP value
* that corresponds to Network Service Type.
*
* NET_SERVICE_TYPE_BE
*             "Best Effort", unclassified/standard.  This is the default service
*             class and cover the majority of the traffic.
*
* NET_SERVICE_TYPE_BK
*             "Background", high delay tolerant, loss tolerant. elastic flow,
*             variable size & long-lived. E.g: non-interactive network bulk transfer
*             like synching or backup.
*
* NET_SERVICE_TYPE_RD
*             "Responsive Data", a notch higher than "Best Effort", medium delay
*             tolerant, elastic & inelastic flow, bursty, long-lived. E.g. email,
*             instant messaging, for which there is a sense of interactivity and
*             urgency (user waiting for output).
*
* NET_SERVICE_TYPE_OAM
*             "Operations, Administration, and Management", medium delay tolerant,
*             low-medium loss tolerant, elastic & inelastic flows, variable size.
*             E.g. VPN tunnels.
*
* NET_SERVICE_TYPE_AV
*             "Multimedia Audio/Video Streaming", medium delay tolerant, low-medium
*             loss tolerant, elastic flow, constant packet interval, variable rate
*             and size. E.g. video and audio playback with buffering.
*
* NET_SERVICE_TYPE_RV
*             "Responsive Multimedia Audio/Video", low delay tolerant, low-medium
*             loss tolerant, elastic flow, variable packet interval, rate and size.
*             E.g. screen sharing.
*
* NET_SERVICE_TYPE_VI
*             "Interactive Video", low delay tolerant, low-medium loss tolerant,
*             elastic flow, constant packet interval, variable rate & size. E.g.
*             video telephony.
*
* NET_SERVICE_TYPE_SIG
*             "Signaling", low delay tolerant, low loss tolerant, inelastic flow,
*             jitter tolerant, rate is bursty but short, variable size. E.g. SIP.
*
* NET_SERVICE_TYPE_VO
*             "Interactive Voice", very low delay tolerant, very low loss tolerant,
*             inelastic flow, constant packet rate, somewhat fixed size.
*             E.g. VoIP.
*/
```


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

// Choose from one the following service types
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

optval = NET_SERVICE_TYPE_BE; /* default */
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

