import Foundation
import ArgumentParser

struct XCodeTheme: ParsableCommand {

    @Option(name: .long, help: "A larger or smaller font size, for desktop or laptop systems respectively.")
    var screen: String = "small"

    mutating func run() throws {
        try Script.run(screen)
    }
}

XCodeTheme.main()
