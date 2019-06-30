require_relative '../directory.rb'
# 
# get the package_json
# 
$main_package_json = JSON.parse(IO.read(PathFor[:package_json]))

# 
# helpers
# 
def dashedToCapatalized(name)
    # replace dashes with spaces
    new_name = name.gsub(/-/," ")
    # capatalize first letters
    new_name.gsub! /(\b|^)\w/ do |match|
        "#{$1}#{match.upcase}"
    end
    return new_name
end

def createIconFor(language_extension_text, new_icon_path)
    # example usage:
    #     createIconFor("cpp","test_cpp_icon.svg")
    
    number_of_letters = language_extension_text.length
    if number_of_letters == 1
        font_size = "120px"
    elsif number_of_letters == 2
        font_size = "90px"
    elsif number_of_letters == 3
        font_size = "80px"
    elsif number_of_letters == 4
        font_size = "70px"
    elsif number_of_letters == 5
        font_size = "60px"
    elsif number_of_letters == 6
        font_size = "54px"
    # if its more than 6 letters truncate it
    elsif number_of_letters > 6
        language_extension_text = language_extension_text[0..6]
        font_size = "54px"
    end
    
    # create the svg version
    IO.write new_icon_path, <<-HEREDOC
        <svg version="1.1" viewBox="0.0 0.0 287.68241469816275 195.04724409448818" fill="none" stroke="none"
        stroke-linecap="square" stroke-miterlimit="10" xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns="http://www.w3.org/2000/svg">
        <defs>
            <style xmlns="http://www.w3.org/2000/svg">
                @import url("https://fonts.googleapis.com/css?family=Source+Code+Pro");
            </style>
        </defs>
        <clipPath id="p.0">
            <path d="m0 0l287.6824 0l0 195.04724l-287.6824 0l0 -195.04724z" clip-rule="nonzero" />
        </clipPath>
        <g clip-path="url(#p.0)">
            <path fill="#000000" fill-opacity="0.0" d="m0 0l287.6824 0l0 195.04724l-287.6824 0z" fill-rule="evenodd"/>
            <path fill="#273244" d="m60.212025 8.747432l168.80052 0l21.099747 10.808398l10.293961 21.614172l-1.545929 123.514435l-16.981628 17.496063l-17.498688 4.1181183l-160.56693 0l-25.729656 -10.808395l-11.322836 -23.157486l0.5144348 -115.79265l13.895014 -22.645668z" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m27.458082 44.72824l0 0c0 -9.7173195 3.855095 -19.036646 10.717211 -25.907831c6.862114 -6.8711834 16.169136 -10.731374 25.873634 -10.731374l0 36.639206z" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m27.458082 44.72824l0 0c0 -9.7173195 3.855095 -19.036646 10.717211 -25.907831c6.862114 -6.8711834 16.169136 -10.731374 25.873634 -10.731374" fill-rule="evenodd"/>
            <path stroke="#6fa5bc" stroke-width="16.0" stroke-linejoin="round" stroke-linecap="butt" d="m27.458082 44.72824l0 0c0 -9.7173195 3.855095 -19.036646 10.717211 -25.907831c6.862114 -6.8711834 16.169136 -10.731374 25.873634 -10.731374" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m64.04893 185.92813l0 0c-9.704498 0 -19.01152 -3.8601837 -25.873634 -10.731369c-6.862116 -6.8711853 -10.717211 -16.190506 -10.717211 -25.907837l36.590843 0z" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m64.04893 185.92813l0 0c-9.704498 0 -19.01152 -3.8601837 -25.873634 -10.731369c-6.862116 -6.8711853 -10.717211 -16.190506 -10.717211 -25.907837" fill-rule="evenodd"/>
            <path stroke="#6fa5bc" stroke-width="16.0" stroke-linejoin="round" stroke-linecap="butt" d="m64.04893 185.92813l0 0c-9.704498 0 -19.01152 -3.8601837 -25.873634 -10.731369c-6.862116 -6.8711853 -10.717211 -16.190506 -10.717211 -25.907837" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m27.458082 44.72824l0 104.56073" fill-rule="evenodd"/>
            <path stroke="#6fa5bc" stroke-width="16.0" stroke-linejoin="round" stroke-linecap="butt" d="m27.458082 41.72824l0 109.56073" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m33.18894 97.008286l-32.313374 0" fill-rule="evenodd"/>
            <path stroke="#6fa5bc" stroke-width="16.0" stroke-linejoin="round" stroke-linecap="butt" d="m33.18894 97.008286l-32.313374 0" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m260.22842 149.28893l0 0c0 9.717331 -3.8551025 19.036652 -10.717209 25.907837c-6.8621063 6.8711853 -16.169128 10.731369 -25.873627 10.731369l0 -36.639206z" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m260.22842 149.28893l0 0c0 9.717331 -3.8551025 19.036652 -10.717209 25.907837c-6.8621063 6.8711853 -16.169128 10.731369 -25.873627 10.731369" fill-rule="evenodd"/>
            <path stroke="#6fa5bc" stroke-width="16.0" stroke-linejoin="round" stroke-linecap="butt" d="m260.22842 149.28893l0 0c0 9.717331 -3.8551025 19.036652 -10.717209 25.907837c-6.8621063 6.8711853 -16.169128 10.731369 -25.873627 10.731369" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m223.63759 8.089036l0 0c9.704498 0 19.01152 3.8601904 25.873627 10.731374c6.8621063 6.8711853 10.717209 16.190512 10.717209 25.907831l-36.590836 0z" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m223.63759 8.089036l0 0c9.704498 0 19.01152 3.8601904 25.873627 10.731374c6.8621063 6.8711853 10.717209 16.190512 10.717209 25.907831" fill-rule="evenodd"/>
            <path stroke="#6fa5bc" stroke-width="16.0" stroke-linejoin="round" stroke-linecap="butt" d="m223.63759 8.089036l0 0c9.704498 0 19.01152 3.8601904 25.873627 10.731374c6.8621063 6.8711853 10.717209 16.190512 10.717209 25.907831" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m260.22842 149.28893l0 -104.56073" fill-rule="evenodd"/>
            <path stroke="#6fa5bc" stroke-width="16.0" stroke-linejoin="round" stroke-linecap="butt" d="m260.22842 153.28893l0 -112.56073" fill-rule="evenodd"/>
            <path fill="#000000" fill-opacity="0.0" d="m254.49757 97.00889l32.31337 0" fill-rule="evenodd"/>
            <path stroke="#6fa5bc" stroke-width="16.0" stroke-linejoin="round" stroke-linecap="butt" d="m254.49757 97.00889l32.31337 0" fill-rule="evenodd"/>
            <text x="49%" y="52%" dominant-baseline="middle" text-anchor="middle"
                style="&#10;    fill: white;&#10;    font-family: Source Code Pro, Helvetica, Arial;&#10;    text-align: center;&#10;    vertical-align: middle;&#10;    font-size: #{font_size};&#10;">
                #{language_extension_text.upcase}
            </text>
        </g>
    </svg>
    HEREDOC
end

def packageJsonFor(language_extension, version:nil)
    # 
    # get the existing package.json info
    # 
    languages = $main_package_json["contributes"]["grammars"]
    language_info = languages.find{|item| item["scopeName"].sub(/source\./,"") == language_extension }
    if not language_info.is_a?(Hash)
        raise "\n\nI dont see the langauge with '#{language_extension}' in the 'contributes':{'grammars': ... } section of the package.json"
    end
    language_name = language_info["language"]
    new_package_json = $main_package_json.dup
    
    # 
    # set each field
    # 
    
    # name
    new_package_json["name"] = "better-#{language_name}-syntax"
    # displayName
    new_package_json["displayName"] = "Better #{dashedToCapatalized(language_name)} Syntax"
    # description
    new_package_json["description"] = "An update to the syntax of #{dashedToCapatalized(language_name)}"
    # version
    if version != nil
        new_package_json["version"] = version
    end
    # icon
    if not File.file?(PathFor[:svgIcon][language_extension])
        createIconFor(language_extension, PathFor[:svgIcon][language_extension])
    end
    # create the png version
    if not File.file?(PathFor[:pngIcon][language_extension])
        system "node '#{PathFor[:svg_helper]}' '#{PathFor[:pngIcon][language_extension]}'"
    end
    new_package_json["icon"] = PathFor[:relativeIconPng][language_extension]
    # keywords
    new_package_json["keywords"] = [
        language_extension,
        language_name,
        "syntax",
        "textmate",
        "highlighting",
        "coloring",
        "color"
    ]
    # contributing grammar
    new_package_json["contributes"] = {
        "grammars" => [
            language_info
        ]
    }
    # 
    # If theres a local package.json, use it to overwrite any exiting things
    # 
    if File.file?(PathFor[:localPackageJson][language_extension])
        new_package_json.merge!(JSON.parse(IO.read(PathFor[:localPackageJson][language_extension])))
    end
    return new_package_json
end


# 
# Process commandline input
# 
language_extension = ARGV[0]
language_version   = ARGV[1]

Dir.chdir PathFor[:root]

# if no language specified, then publish the main repo
if language_extension == nil
    # run the build command then publish
    system "npm run build && vsce publish"
# if an extension was specified
else
    # generate the new package info
    new_package_json_string = JSON.generate(packageJsonFor(language_extension, version:language_version))
    begin
        # move the current readme to a temp place
        FileUtils.mv(PathFor[:readme], PathFor[:temp_readme])
        # if there is a readme for the language, switch to it
        if File.file?(PathFor[:localReadMe][language_extension])
            FileUtils.cp(PathFor[:localReadMe][language_extension], PathFor[:readme])
        else
            FileUtils.cp(PathFor[:generic_readme], PathFor[:readme])
        end
        # overwrite the package json
        IO.write(PathFor[:package_json], new_package_json_string)
        # run the build command then publish
        system "npm run build #{language_extension} && vsce publish"
    ensure
        # once finished, restore the original package.json
        IO.write(PathFor[:package_json], JSON.pretty_generate($main_package_json))
        # switch back to the original readme
        FileUtils.mv(PathFor[:temp_readme], PathFor[:readme])
    end
end
