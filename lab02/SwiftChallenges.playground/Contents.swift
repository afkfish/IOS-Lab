import Foundation

func challenge1(input: String)-> Bool {
    return input == String(input.reversed())
}

print(challenge1(input: "alla"))
