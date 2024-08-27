# Thorsignia_InternetCheck
 
The Thorsignia_InternetChecking is leting you that your user internet is in active or inactive.  


### Requirements
iOS 12.1+ 

Supported devices : 
* iPhone 
* iPad 
 

### How to get started
  - Install our library on your project (see below).
  - Import our pod to your main class.
  - Intialise given methods into that class.

### Integration
Find the integration information by following [this link]

### Installation with CocoaPods

CocoaPods is a dependency manager which automates and simplifies the process of using 3rd-party libraries in your projects.

### Podfile

  - iOS application : 

```ruby
target 'MyProject' do
pod "Thorsignia_InternetCheck"
use_frameworks!
end
```





## Integration samples
### Import Pod into your class
```swift
// Your initial class.swift
import Thorsignia_InternetCheck
```
### Tracker
```
//calling method in viewdidload
 override func viewDidLoad() {
    super.viewDidLoad()
    self.GetInternetUpdates()
 }
 ```
 ```
 
 //Internet check main method...

func GetInternetUpdates(){
    print(" 👊👊👊👊👊👊 Intialise method ...👊👊👊👊👊")
    if !NetStatus.isMonitoring {
        NetStatus.startMonitoring()
    } else {
        NetStatus.stopMonitoring()
    }
    
    
    NetStatus.didStartMonitoringHandler = { [unowned self] in
        print(" 👊👊👊👊👊👊 start Monitoring...👊👊👊👊👊")
        
        print(" 👊👊👊👊👊👊 Please Update your UI...👊👊👊👊👊")
    }
    
    NetStatus.didStopMonitoringHandler = { [unowned self] in
        print(" 👊👊👊👊👊👊 Stop Monitoring...👊👊👊👊👊")
        
        print(" 👊👊👊👊👊👊 Please Update your UI...👊👊👊👊👊")

    }
    
    NetStatus.netStatusChangeHandler = {
        DispatchQueue.main.async { [unowned self] in
            print(" 👊👊👊👊👊👊 \(NetStatus.isConnected ? "Connected" : "Not Connected")👊👊👊👊👊")
            print(" 👊👊👊👊👊👊 \(NetStatus.isExpensive  ? "Expensive" : "Not Expensive")👊👊👊👊👊")
            print(" 👊👊👊👊👊👊 \(NetStatus.interfaceType )👊👊👊👊👊")
            print(" 👊👊👊👊👊👊 \(NetStatus.availableInterfacesTypes)👊👊👊👊👊")

            print(" 👊👊👊👊👊👊 Please Update your UI...👊👊👊👊👊")
         }
    }
}
```

### License
MIT

   [documentation page]: <https://developers.atinternet-solutions.com/apple-universal-en/getting-started-apple-universal-en/integration-of-the-swift-library-apple-universal-en/>
   [here]: <https://developers.atinternet-solutions.com/apple-universal-fr/contenus-de-lapplication-apple-universal-fr/rich-media-apple-universal-fr/#refresh-dynamique-2-9_3/>

