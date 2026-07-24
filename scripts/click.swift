import CoreGraphics
import Foundation

// usage: swift click.swift x y [double]
let args = CommandLine.arguments
let x = Double(args[1])!, y = Double(args[2])!
let dbl = args.count > 3 && args[3] == "double"
let pt = CGPoint(x: x, y: y)

func post(_ type: CGEventType, _ clickState: Int64) {
    let e = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: pt, mouseButton: .left)!
    e.setIntegerValueField(.mouseEventClickState, value: clickState)
    e.post(tap: .cghidEventTap)
    usleep(60000)
}

let move = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: pt, mouseButton: .left)!
move.post(tap: .cghidEventTap)
usleep(120000)
post(.leftMouseDown, 1)
post(.leftMouseUp, 1)
if dbl {
    post(.leftMouseDown, 2)
    post(.leftMouseUp, 2)
}
