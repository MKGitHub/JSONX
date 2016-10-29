[![MadeInSweden](https://img.shields.io/badge/Made In-Stockholm, Sweden-blue.svg)](https://en.wikipedia.org/wiki/Stockholm)
[![Status](https://img.shields.io/badge/Status-Active doing well & alive-blue.svg)](https://github.com/MKGitHub/JSONX)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](https://github.com/MKGitHub/JSONX)
[![Pod](https://img.shields.io/badge/pod-1.0.0-blue.svg)](https://github.com/MKGitHub/JSONX)

[![Platform](https://img.shields.io/badge/Platforms-macOS + iOS + tvOS-blue.svg)](https://github.com/MKGitHub/JSONX)
[![Swift](https://img.shields.io/badge/Swift Version-3.0-blue.svg)](https://github.com/MKGitHub/JSONX)
[![TestCoverage](https://img.shields.io/badge/Test Coverage-97.06％-blue.svg)](https://github.com/MKGitHub/JSONX)


![JSONX Logo](https://raw.githubusercontent.com/MKGitHub/JSONX/master/Banner.png)

Parse JSON data, simple, lightweight & without [noise](https://github.com/SwiftyJSON/SwiftyJSON/issues).

Enjoy the playground, it also contains some tests & an example json file.


Example Usage
------
```swift
// init with String
JSONX(with:"{'name':'Khan Solo'}", usesSingleQuotes:true)

// init with file contents at path
JSONX(with:path)

// init with file contents at URL
JSONX(with:url)

// init with Data (i.e. from your networking lib etc.)
JSONX(with:data)

// init with Dictionary<String, Any>
JSONX(with:["name":"Khan-Solo", "level":50, "skills":[1,2,3], "droids":["shiny":9]])
```


Accessors Types
------
Supported Data Types: Bool, UInt, Int, Float, Double, String, Array, Dictionary, Raw

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
    "parent":
    {
        "child":
        {
            "puppy":
            {
                "name": "voffy"
            }
        }
    }
}
```
```swift
jsonx.asString(inKeyPath:"parent.child.puppy.name") // returns "voffy"
```

Simple JSON -> Swift Struct model mapping
------
```json
{
    "Person":
    {
        "name": "Khan Solo",
        "age": 99
    }
}
```
```swift
struct PersonModel
{
    var name:String?
    var age:Int?
    var level:Int?

    static func `init`(jsonx:JSONX)
    -> PersonModel?
    {
        var pm:PersonModel = PersonModel()

        pm.name = jsonx.asString("name", default:"Johnny Appleseed")
        pm.age = jsonx.asInt("age", default:0)

        // this will default to 0 because we are looking to the key "level"
        // but the JSON does not have it
        pm.level = jsonx.asInt("level", default:0)

        return pm
    }
}

PersonModel.init(jsonx:)
```

Tailored for your Swifty needs!
------
Just type *.as* to see the function lookup with prefixed function names :-)
![asLookup](https://raw.githubusercontent.com/MKGitHub/JSONX/master/asLookup.png)


Performance
------
The provided XCTest measures the performance when it comes to finding a key in a hierarchy. Usually you would only do this once and cache the value, but it is interesting to see how JSONX compares to other alternatives.

```text
    jsonx.asString(inKeyPath:"key1.key2.key3.key4.key5")

    jayson["key1"]["key2"]["key3"]["key4"]["key5"].string

swiftyjson["key1"]["key2"]["key3"]["key4"]["key5"].string
```

Both [JAYSON](https://github.com/muukii/JAYSON) and [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) have implemented Swift Subscripts in ways that cause loss of performance! While JSONX uses good old key paths – the syntax is also much cleaner and convenient :-)

The test measures each call 10000 times, lower result is better/faster.

|                                   | JSONX | JAYSON | SwiftyJSON |
|-----------------------------------|:-----:|:------:|:----------:|
| Measured Average (Time, Seconds): | 0.798 | 0.905  | 1.385      |
|                   Passed Seconds: | 8.237 | 10.213 | 14.107     |

By measured average JSONX is 1.134x (~13%) faster than JAYSON and 1.735x (~74%) faster than SwiftyJSON.

By passed time JSONX is 1.239x (~24%) faster than JAYSON, and 1.712x (~71%) faster than SwiftyJSON.


Used By
------
[McDonald's Sweden](https://itunes.apple.com/se/app/mcdonalds-sverige/id322810359?mt=8)


Notes
------
   https://github.com/MKGitHub/JSONX

   http://www.xybernic.com

   http://www.khanofsweden.com

   Copyright 2016 Mohsan Khan

   Licensed under the Apache License, Version 2.0.

