# UIScaler

UIScaler is a UI scaling tool for iOS and macOS apps with Swift and Objective-C compatibility. It can be used scaling values for different device sizes. Common use cases include scaling layout constraint constants and font sizes. It's intended to be used when Autolayout doesn't provide enough flexibility or power.

## Installation
### Installation with Carthage
To integrate UIScaler, add the following to your  `Cartfile`.
```
github "mindsnack/UIScaler" ~> 0.1.0
```

Since this is a private repository, you made need to add `--use-ssh` to Carthage update commands.
```
carthage update UIScaler --use-ssh --platform iOS
```

### Installation with Swift Package Manager

To install UIScaler using the Swift Package Manager support built into Xcode (11.0+), select:

```
File -> Swift Packages -> Add Package Dependency...
```

and use https://github.com/mindsnacks/UIScaler.git as the repository URL.

## TODO
 - Usage documentation
 - Unit tests
 - Code examples documentation
 - Example project
