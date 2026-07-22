// Command clarus is the Clarus front-end CLI: `clarus check FILE...`
// type-checks one or more source files as a single program.
package main

import (
	"fmt"
	"os"

	"clarus/internal/driver"
)

const usage = "usage: clarus check FILE..."

func main() {
	if len(os.Args) < 2 || os.Args[1] != "check" || len(os.Args) < 3 {
		fmt.Fprintln(os.Stderr, usage)
		os.Exit(2)
	}

	diags, err := driver.Check(os.Args[2:])
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	for _, d := range diags {
		fmt.Println(d.String())
	}
	if len(diags) > 0 {
		os.Exit(1)
	}
}
