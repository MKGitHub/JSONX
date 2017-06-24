Pod::Spec.new do |s|

  s.name         = "JSONX"
  s.version      = "1.2.0"
  s.summary      = "Parse JSON data, simple, lightweight & without noise."

  s.homepage     = "https://github.com/MKGitHub/JSONX"

  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE.txt" }

  s.author       = { "Mohsan Khan" => "git.mk@xybernic.com" }

  s.osx.deployment_target = "10.12"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"

  s.source       = { :git => "https://github.com/MKGitHub/JSONX.git", :tag => "#{s.version}" }

  s.source_files = "Sources/JSONX.swift"

  s.requires_arc = true

end

