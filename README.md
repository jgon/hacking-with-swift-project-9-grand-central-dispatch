# Hacking with Swift - Project 9 - Grand Central Dispatch

Learning how to run complex tasks in the background with GCD.

# Setup
- XCode 7.2.1
- Swift 2.0
- iOS 9.2
- iPad

## Topics covered

- Using ```dispatch_async()``` to run things in the background and bringing
results to the main thread.
- QoS of the different type of queues (```User Interactive```, ```User Initiated```,
  ```Utility queue```, ```Background queue```). The different types of queues have an impact on the battery life.
- ```dispatch_async()``` requires code to by passed as a closure and ```[unowned self]``` must be used to prevent reference cycles (memory leaks).
