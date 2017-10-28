[![MadeInSweden](https://img.shields.io/badge/Made_In-Stockholm_Sweden-blue.svg)](https://en.wikipedia.org/wiki/Stockholm)
[![Status](https://img.shields.io/badge/Status-Active_and_in_development-blue.svg)](https://github.com/MKGitHub/JSONX)

[![Version](https://img.shields.io/badge/Version-1.2.2-blue.svg)](https://github.com/MKGitHub/JSONX)
[![Carthage](https://img.shields.io/badge/carthage-1.2.2-blue.svg)](https://github.com/MKGitHub/JSONX)
[![SPM](https://img.shields.io/badge/SPM-1.2.2-blue.svg)](https://github.com/MKGitHub/JSONX)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-removed-blue.svg)](https://github.com/MKGitHub/JSONX)

[![Platform](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS-blue.svg)](https://github.com/MKGitHub/JSONX)
[![Swift](https://img.shields.io/badge/Swift_Version-4.0.0-blue.svg)](https://github.com/MKGitHub/JSONX)
[![TestCoverage](https://img.shields.io/badge/Test_Coverage-88.33％-blue.svg)](https://github.com/MKGitHub/JSONX)


★ Give this repo a star and help its development grow! ★


![JSONX Logo](https://github.com/MKGitHub/JSONX/blob/master/Images/Banner.png)

Parse JSON data, simple, lightweight & without [noise](https://github.com/SwiftyJSON/SwiftyJSON/issues).

Enjoy the playground, it also contains some tests & an example json file.


Example Usage
------
```swift
// init with String, specifying single or double quotes
JSONX(with:"{'name':'Khan Solo'}", usesSingleQuotes:true)

// init with file path
JSONX(with:path)

// init with file URL
JSONX(with:url)

// init with Data
JSONX(with:data)

// init with Dictionary<String, Any>
JSONX(with:["name":"Khan-Solo", "level":50, "skills":[1,2,3], "droids":["shiny":9]])
```


Accessors Types
------
Supported Data Types: Bool, UInt,/Int, Float/Double, String, Array, Dictionary, Raw uncasted format

All accessor functions have the ability to define a default value:
```swift
// without default value
jsonx.asString("thisKeyDoesNotExist") // returns nil

// with default value
jsonx.asString("thisKeyDoesNotExist", default:"Default string") // returns "Default string"
```

Search using key paths:
```json
{
    "parent": {
        "child": {
            "puppy": {
                "name": "voffy"
            }
        }
    }
}
```
```swift
jsonx.asString(inKeyPath:"parent.child.puppy.name") // returns "voffy"
```

Simple JSON -> Swift Struct Model Mapping
------
```json
{
    "Person": {
        "name": "Khan Solo",
        "age": 99
    }
}
```
```swift
struct PersonModel
{
    var name:String!
    var age:Int!

    static func `init`(jsonx:JSONX) -> PersonModel
    {
        var pm:PersonModel = PersonModel()

        pm.name = jsonx.asString("name", default:"John Doe")
        pm.age = jsonx.asInt("age", default:0)

        return pm
    }
}

PersonModel.init(jsonx:myJSONXObject)
```

Tailored for your Swifty needs!
------
Just type *.as* to see the function lookup with prefixed function names :-)
![asLookup](https://github.com/MKGitHub/JSONX/blob/master/Images/asLookup.png)


Performance
------
The provided XCTest measures the performance when it comes to finding a key in a hierarchy. Usually you would only do this once and cache the value, but it is interesting to see how JSONX compares to other alternatives. JSONX is fast, you can use it in realtime without worrying about performance!

```text
    jsonx.asString(inKeyPath:"key1.key2.key3.key4.key5")

    jayson["key1"]["key2"]["key3"]["key4"]["key5"].string

swiftyjson["key1"]["key2"]["key3"]["key4"]["key5"].string
```

The test measures each call 10000 times, lower result is better & faster.

![asLookup](https://github.com/MKGitHub/JSONX/blob/master/Images/Performance.png)


What’s New?
------
* Version 1.1.0 improves performance as well as minor refactorings (Swift 3.0.1/3.1/3.2).
* Version 1.2.0 adds support for Swift 4 and Xcode 9.
* Version 1.2.1 adds support for Swift 4 and Xcode 9.
* Version 1.2.2 bug fix for null values, bug fix for non-existing key in dictionary key path crash.


Requirements
------
* Swift Version 4
* Xcode 9
* macOS 10.12 and later
* iOS 10.0 and later
* tvOS 10.0 and later


How to Install
------
There is no framework/library distibution, I recommend that you add the JSONX/Sources to your project. As this will allow you to easily find & read the JSONX API, it will also allow JSONX to compile using your apps build settings. 
* Git: run `git clone https://github.com/MKGitHub/JSONX.git` then `Drag & Drop the JSONX/Sources into your Xcode project.`
* Manual: `Drag & Drop the JSONX/Sources into your Xcode project.`
* Carthage: In your Cartfile add `github "MKGitHub/JSONX" ~> 1.2.2` then `carthage update --no-build` then `Drag & Drop the JSONX/Sources into your Xcode project.`
* Swift Package Manager (still quite meaningless): run `swift build` or `swift package generate-xcodeproj`
* CocoaPods support has been removed! 🙌🙏🎉


Documentation
------
Go to the documentation [index page](http://htmlpreview.github.io/?https://raw.githubusercontent.com/MKGitHub/JSONX/master/docs/index.html).


Used In Apps
------
JSONX is used in production in the following apps/games (known to me), these apps are together used by many millions of users every day. Please let me know if you use JSONX.

* McDonald's apps


Notes
------
   https://github.com/MKGitHub/JSONX

   http://www.xybernic.com

   http://www.khanofsweden.com

   Copyright 2016/2017 Mohsan Khan

   Licensed under the Apache License, Version 2.0.

