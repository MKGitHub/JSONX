[![MadeInSweden](https://img.shields.io/badge/Made_In-Stockholm_Sweden-blue.svg)](https://en.wikipedia.org/wiki/Stockholm)
[![Status](https://img.shields.io/badge/Status-Active_and_in_development-blue.svg)](https://github.com/MKGitHub/JSONX)

[![Version](https://img.shields.io/badge/Version-1.3-blue.svg)](https://github.com/MKGitHub/JSONX)
[![Carthage](https://img.shields.io/badge/carthage-1.3-blue.svg)](https://github.com/MKGitHub/JSONX)
[![SPM](https://img.shields.io/badge/SPM-1.3-blue.svg)](https://github.com/MKGitHub/JSONX)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-🤬-blue.svg)](https://github.com/MKGitHub/JSONX)

[![Platform](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS-blue.svg)](https://github.com/MKGitHub/JSONX)
[![Swift](https://img.shields.io/badge/Swift_Version-4.2-blue.svg)](https://github.com/MKGitHub/JSONX)
[![TestCoverage](https://img.shields.io/badge/Test_Coverage-98.32％-blue.svg)](https://github.com/MKGitHub/JSONX)


🌟 Give this repo a star and help its development grow! 🌟


![JSONX Logo](https://github.com/MKGitHub/JSONX/blob/master/Images/Banner.png)

Parse JSON data, simple, lightweight & without [noise](https://github.com/SwiftyJSON/SwiftyJSON/issues).

Enjoy the playground, it also contains some tests & an example JSON file.

<br/>


Example Usage
------
```swift
// init with a `String`
JSONX(string:"{'name':'Khan Solo'}", usesSingleQuotes:true)

// init with a file path
JSONX(filepath:path)

// init with a file `URL`
JSONX(url:url)

// init with `Data`
JSONX(data:data)

// init with a `Dictionary`
JSONX(dictionary:["name":"Khan-Solo", "level":50, "skills":[1,2,3], "droids":["shiny":9]])

// convert dictionary to `JSONX`
let dict = ["key1":"value1", "key2":"value2"]
let jsonX = dict.toJSONX(context:"converting stuff")
```

<br/>


Accessors Types
------
**Supported Data Types:**

Bool, UInt/Int, Float/Double, String, Array, Dictionary, Raw uncasted format

**Default Values:**

All accessor functions have the ability to define a default value:

```swift
// without default value
jsonx.asString("thisKeyDoesNotExist")  // returns nil

// with default value
jsonx.asString("thisKeyDoesNotExist", default:"Default string")  // returns "Default string" 🤩
```

**Search using Key Paths:**

```swift
{
    "parent": {
        "child": {
            "puppy": {
                "name": "voffy"
            }
        }
    }
}

jsonx.asString(inKeyPath:"parent.child.puppy.name")  // returns "voffy" 🤩
```

<br/>


Model Mapping: JSON → Swift Struct
------
```swift
// example
{
    "Person": {
        "name": "Khan Solo",
        "age": 99
    }
}

// example
struct PersonModel
{
    var name:String!
    var age:Int!

    static func `init`(jsonx:JSONX) -> PersonModel
    {
        var pm = PersonModel()

        pm.name = jsonx.asString("name", default:"John Doe")
        pm.age = jsonx.asInt("age", default:0)

        return pm
    }
}

PersonModel.init(jsonx:myJSONXObject)
```

<br/>


Tailored for your Swifty needs!
------
Just type **.as** to see the function lookup with prefixed function names 😍

![asLookup](https://github.com/MKGitHub/JSONX/blob/master/Images/asLookup.png)

<br/>


Performance
------
The provided XCTest measures the performance when it comes to finding a key in a hierarchy. Usually you would only do this once and cache the value, but it is interesting to see how JSONX compares to other alternatives. JSONX is fast, you can use it in realtime without worrying about performance!

```text
    jsonx.asString(inKeyPath:"key1.key2.key3.key4.key5")    // much nicer syntax 😍

swiftyjson["key1"]["key2"]["key3"]["key4"]["key5"].string
```

The test measures each call 10000 times, lower result is better & faster.

![asLookup](https://github.com/MKGitHub/JSONX/blob/master/Images/Performance.png)

<br/>


What’s New?
------
* Version 1.3 updates for Swift 4.2.
  * Added `dictionary.toJSONX(:)` function which creates a JSONX object from a dictionary.
  * Updated documentation + comments.
* Version 1.2.2 bug fix for null values, bug fix for non-existing key in dictionary key path crash.
* Version 1.2.1 adds support for Swift 4 and Xcode 9.
* Version 1.2.0 adds support for Swift 4 and Xcode 9.
* Version 1.1.0 improves performance as well as minor refactorings (Swift 3.0.1/3.1/3.2).


Requirements
------
* Swift Version 4.2
* Xcode 10


How to Install
------
There is no framework/library distibution, I recommend that you simply add the `JSONX.swift` to your project. As this will allow you to easily find & read the JSONX API, and it will also allow JSONX to compile using your apps build settings. 

* Using Git: `git clone https://github.com/MKGitHub/JSONX.git` then add `JSONX.swift` to your Xcode project.
* Manual Way: Add `JSONX.swift` to your Xcode project.
* Using Carthage: In your Cartfile add `github "MKGitHub/JSONX" ~> 1.3` then `carthage update --no-build` then add `JSONX.swift` to your Xcode project.
* Using Swift Package Manager: swift-tools-version:4.0
* CocoaPods support has been removed! 🙌🙏🎉 Never use CocoaPods! 💀


Documentation
------
Go to the documentation [index page](http://htmlpreview.github.io/?https://raw.githubusercontent.com/MKGitHub/JSONX/master/docs/index.html).


Used In Apps
------
JSONX is used in production in the following apps/games (that I'm aware of), these apps are together used by millions of users. Please let me know if you use JSONX.

* Hoppa
* McDonald's apps
* Lånekoll


Notes
------
https://github.com/MKGitHub/JSONX

http://www.xybernic.com

Copyright 2016/2017/2018 Mohsan Khan

Licensed under the Apache License, Version 2.0.

