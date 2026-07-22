// Package reftest extracts ```rust code fences from the Clarus language
// reference and checks a curated subset of them (see manifest.go) as
// permanent fixtures, so the reference's own examples stay compiler-clean.
package reftest

import (
	"bufio"
	"os"
)

// Fence is one ```rust ... ``` code block from the reference document.
type Fence struct {
	Index int // 0-based, in document order
	Line  int // 1-based line number of the opening ```rust fence
	Code  string
}

// ExtractFences scans mdPath for ```rust fenced code blocks and returns them
// in document order.
func ExtractFences(mdPath string) ([]Fence, error) {
	f, err := os.Open(mdPath)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	var fences []Fence
	var inFence bool
	var startLine int
	var lines []string

	lineNo := 0
	sc := bufio.NewScanner(f)
	sc.Buffer(make([]byte, 64*1024), 1024*1024)
	for sc.Scan() {
		lineNo++
		line := sc.Text()
		if !inFence {
			if line == "```rust" {
				inFence = true
				startLine = lineNo
				lines = nil
			}
			continue
		}
		if line == "```" {
			inFence = false
			code := ""
			for i, l := range lines {
				if i > 0 {
					code += "\n"
				}
				code += l
			}
			if len(lines) > 0 {
				code += "\n"
			}
			fences = append(fences, Fence{
				Index: len(fences),
				Line:  startLine,
				Code:  code,
			})
			continue
		}
		lines = append(lines, line)
	}
	if err := sc.Err(); err != nil {
		return nil, err
	}
	return fences, nil
}
