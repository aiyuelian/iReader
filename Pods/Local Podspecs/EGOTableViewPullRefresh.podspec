Pod::Spec.new do |s|
  s.name         = "EGOTableViewPullRefresh"
  s.version      = "0.0.1"

  s.summary      = "pull up load more,pull down refresh"

  s.homepage     = "https://github.com/aiyuelian/EGOTableViewPullRefresh"

  s.license = { :type => 'MIT', :text => <<-LICENSE
                   Version 1.0

  Created by Saiday on 01/14/2013.
  Copyright 2013 Saiday

 This code is distributed under the terms and conditions of the MIT license.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
  LICENSE
               }

  s.author       = { "aiyuelian" => "645822731@qq.com" }

  s.platform     = :ios, '6.0'

  s.source       = { :git => "https://github.com/aiyuelian/EGOTableViewPullRefresh.git", :commit => "44de2627e5e638738791b94c64cadf8a8d741142" }

  s.source_files  = 'EGOTableViewPullAction/Classes/*.{h,m}'

  s.resources = "EGOTableViewPullAction/Resources/*.png"

  s.frameworks = 'UIKit', 'Foundation','QuartzCore'

  s.requires_arc = true

end
