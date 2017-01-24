//
//  JSONX
//  Copyright © 2016/2017 Mohsan Khan. All rights reserved.
//

//
//  https://github.com/MKGitHub/JSONX
//  http://www.xybernic.com
//  http://www.khanofsweden.com
//

//
//  Copyright 2016/2017 Mohsan Khan
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation


func ExampleUsage()
{
    // init with String
    guard let jsonXFromString:JSONX = JSONX(with:"{'name':'Khan Solo'}", usesSingleQuotes:true) else { print("Failed to create JSONX object!"); return }
    print("JSONX with String:", jsonXFromString.description(), "\n")

    // init with file contents at path
    let filePath1:String = Bundle.main.path(forResource:"example", ofType:"json")!
    guard let jsonXFromFilepath:JSONX = JSONX(with:filePath1) else { print("Failed to create JSONX object!"); return }
    print("JSONX with file contents at path:", jsonXFromFilepath.description(), "\n")

    // init with file contents at URL
    let filePath2:String = Bundle.main.path(forResource:"example", ofType:"json")!
    let url:URL = URL(fileURLWithPath:filePath2)
    guard let jsonXFromFileURL:JSONX = JSONX(with:url) else { print("Failed to create JSONX object!"); return }
    print("JSONX with file contents at URL:", jsonXFromFileURL.description(), "\n")

    // init with Data
    let data:Data? = JSONX.convertSingleQuotesToDoubleQuotes("{'name':'Khan Solo'}").data(using:String.Encoding.utf8)
    guard let jsonXFromData:JSONX = JSONX(with:data!) else { print("Failed to create JSONX object!"); return }
    print("JSONX with Data:", jsonXFromData.description(), "\n")

    // init with Dictionary<String, Any>
    guard let jsonXFromDictionary:JSONX = JSONX(with:["name":"Khan Solo", "level":50, "skills":[1,2,3], "droids":["shiny":9]]) else { print("Failed to create JSONX object!"); return }
    print("JSONX with Dictionary<String, Any>:", jsonXFromDictionary.description())
}


ExampleUsage()

