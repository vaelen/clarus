// Command clarus is the Clarus front-end CLI: `clarus check FILE...`
// type-checks one or more source files as a single program; `clarus build
// [-o OUT] FILE...` compiles them to a native host executable.
package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"clarus/internal/build"
	"clarus/internal/driver"
)

const usage = "usage: clarus check FILE...\n       clarus build [-o OUT] FILE..."

func main() {
	if len(os.Args) < 3 {
		fmt.Fprintln(os.Stderr, usage)
		os.Exit(2)
	}

	switch os.Args[1] {
	case "check":
		runCheck(os.Args[2:])
	case "build":
		runBuild(os.Args[2:])
	default:
		fmt.Fprintln(os.Stderr, usage)
		os.Exit(2)
	}
}

func runCheck(args []string) {
	diags, err := driver.Check(args)
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

func runBuild(args []string) {
	out := ""
	if len(args) >= 2 && args[0] == "-o" {
		out = args[1]
		args = args[2:]
	}
	if len(args) < 1 {
		fmt.Fprintln(os.Stderr, usage)
		os.Exit(2)
	}
	if out == "" {
		out = strings.TrimSuffix(filepath.Base(args[0]), ".cla")
	}

	diags, err := build.Build(args, out)
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
