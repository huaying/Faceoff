//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

//for i in (0..<5).reverse() {
//    print(i)
//}

//
//let data = ["x":"2","y":"1"]
//let b = "1" + data["x"]!
//
//
//var a = ["1","2","3","4"]
//print(a.removeFirst())
//a
//
//let aa = ["x":1]
//if let a = aa["x"] {
//    print(1)
//}



//var str_ = "Hello, darling."
//var index1 = str_.startIndex.advancedBy(5)
//str_.substringToIndex(index1)
//str
//index1 = str_.startIndex.advancedBy(5)
//str_ = str_.substringToIndex(index1)


var chunks = [[Character]]()
let chunkSize = 100

let base64String = "alfkjadf;lkaflk"

for (i, character) in base64String.characters.enumerate() {
    if i % chunkSize == 0 {
        chunks.append([Character]())
    }
    chunks[i/chunkSize].append(character)
}
var rltString = ""
for chunk in chunks {
    rltString += String(chunk)
}
print( chunks.count)
if rltString == base64String {
    print("ok")
}

let a = "wd4X3h886YJngidesC8rLvIAQ6MONpUXHK0vyTtZlpt6Jjcl9kxqTMjJ+FC/oxj/wYTwgAMY/76cpKhnClJj76eifHNldtJldQXp"
a.characters.count


