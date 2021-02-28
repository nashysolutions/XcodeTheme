import Foundation
import Files
import ShellOut

struct Script {
    
    static func run(_ argument: String) throws {
        try fetchFontIfNecessary()
        print("🎨  Installing Xcode theme...")
        print("")
        try installTheme(for: argument)
    }
    
    private static func fetchFontIfNecessary() throws {
        let fontsFolder = try Folder.home.subfolder(at: "Library/Fonts")
        if !fontsFolder.containsFile(named: "SourceCodePro-Regular.ttf") {
            print("🅰️  Downloading Source Code Pro font...")
            let data = try downloadPackage()
            print("🅰️  Installing Source Code Pro font...")
            try install(data, in: fontsFolder)
        }
    }
    
    private static func downloadPackage() throws -> Data {
        let fontZipURL = URL(string: "https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip")!
        return try Data(contentsOf: fontZipURL)
    }
    
    private static func install(_ data: Data, in folder: Folder) throws {
        let fontZipFile = try folder.createFile(named: "SourceCodePro.zip", contents: data)
        try shellOut(to: "unzip \(fontZipFile.name) -d SourceCodePro", at: folder.path)
        let sourceCodeProFolder = try folder.subfolder(named: "SourceCodePro")
        let ttfFolder = try sourceCodeProFolder.subfolders.first!.subfolder(named: "TTF")
        try ttfFolder.files.move(to: folder)
        try sourceCodeProFolder.delete()
        try fontZipFile.delete()
    }
    
    private static func installTheme(for argument: String) throws {
        
        func establishPath() -> String {
            let standard = "Resources/Themes/SmallScreen/"
            if argument == "large" {
                return "Resources/Themes/LargeScreen/"
            } else {
                return standard
            }
        }
        
        let path = establishPath()
        let darkThemeURL = URL(fileURLWithPath: #file.replacingOccurrences(of: "main.swift", with: path + "SundellsColorsDark.xccolortheme"))
        let lightThemeURL = URL(fileURLWithPath: #file.replacingOccurrences(of: "main.swift", with: path + "SundellsColorsLight.xccolortheme"))
        let darkThemeData = try Data(contentsOf: darkThemeURL)
        let lightThemeData = try Data(contentsOf: lightThemeURL)
        
        let xcodeFolder = try Folder.home.subfolder(at: "Library/Developer/Xcode")
        let userDataFolder = try xcodeFolder.createSubfolderIfNeeded(withName: "UserData")
        let themeFolder = try userDataFolder.createSubfolderIfNeeded(withName: "FontAndColorThemes")
        
        let darkThemeFile = try themeFolder.createFile(named: "SundellsColorsDark.xccolortheme")
        let lightThemeFile = try themeFolder.createFile(named: "SundellsColorsLight.xccolortheme")
        try darkThemeFile.write(darkThemeData)
        print("🎉 Sundell's Colors Dark successfully installed")
        try lightThemeFile.write(lightThemeData)
        print("🎉 Sundell's Colors Light successfully installed")
        
        print("👍 Select them in Xcode's preferences to start using it (you may have to restart Xcode first)")
    }
}
