import CoreGraphics
import Foundation

// usage: swift drag.swift x1 y1 x2 y2
//
// Press-drag-release CGEvent helper for non-sticky System 7 menus (Snow
// facts, docs/superpowers/plans/2026-08-08-mac-resident-clarusc.md):
// unlike modern macOS, a System 7 menu does not stay open on a plain
// click -- the mouse button must stay physically down from the menu
// title through the item, so a synthetic click-release pair (click.swift)
// can't drive one. This posts mouseMoved, leftMouseDown at (x1,y1), a
// handful of interpolated leftMouseDragged steps toward (x2,y2), then
// leftMouseUp at (x2,y2) -- the same shape a real press-drag-release
// mouse gesture produces. Screen-absolute coordinates, same convention
// as click.swift.
let a = CommandLine.arguments.map { Double($0) ?? 0 }
let p1 = CGPoint(x: a[1], y: a[2])
let p2 = CGPoint(x: a[3], y: a[4])
let steps = 8

func post(_ type: CGEventType, _ p: CGPoint) {
    let e = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: p, mouseButton: .left)!
    e.post(tap: .cghidEventTap)
    usleep(30000)
}

post(.mouseMoved, p1)
post(.leftMouseDown, p1)
for i in 1...steps {
    let t = Double(i) / Double(steps)
    let p = CGPoint(x: p1.x + (p2.x - p1.x) * t, y: p1.y + (p2.y - p1.y) * t)
    post(.leftMouseDragged, p)
}
post(.leftMouseUp, p2)
