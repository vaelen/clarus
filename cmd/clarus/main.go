// Command clarus is the Clarus front-end CLI: `clarus check FILE...`
// type-checks one or more source files as a single program; `clarus build
// [-o OUT] FILE...` compiles them to a native host executable.
package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"clarus/internal/build"
	"clarus/internal/driver"
)

const usage = "usage: clarus check FILE...\n       clarus build [-o OUT] FILE...\n       clarus run FILE..."

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
	case "run":
		runRun(os.Args[2:])
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

func runRun(args []string) {
	if len(args) < 1 {
		fmt.Fprintln(os.Stderr, usage)
		os.Exit(2)
	}

	workdir, err := os.MkdirTemp("", "clarus-run-*")
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	defer os.RemoveAll(workdir)
	exe := filepath.Join(workdir, "prog")

	diags, err := build.Build(args, exe)
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

	cmd := exec.Command(exe)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if exitErr, ok := err.(*exec.ExitError); ok {
		os.Exit(exitErr.ExitCode())
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
