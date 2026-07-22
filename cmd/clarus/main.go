// Command clarus is the Clarus front-end CLI, targeting the portable host
// backend (a native executable built from generated C99 plus the runtime in
// internal/build/rt — no Mac emulator involved; that target lands in a
// later plan). FILE... arguments are concatenated in order and checked as a
// single program, same as multiple files in one package.
//
//	clarus check FILE...          type-check only; prints diagnostics, exit 1 on any
//	clarus build [-o OUT] FILE... compile to a native executable (default OUT: first FILE's
//	                               basename, extension stripped, in the current directory)
//	clarus run FILE...             build to a throwaway temp dir and execute it immediately,
//	                               forwarding stdin/stdout/stderr and the child's exit code
//
// A program using a construct the host backend doesn't yet support (windows,
// menus, timers, network/file-dialog resources — see the language reference,
// Chapter 12 and the UI chapters) fails with a "host build does not support
// X yet" diagnostic instead of an executable.
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
	if len(args) >= 1 && args[0] == "-o" {
		if len(args) < 2 {
			fmt.Fprintln(os.Stderr, usage)
			os.Exit(2)
		}
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
	// No `defer os.RemoveAll(workdir)` here: every exit below is an
	// os.Exit, which skips deferred calls entirely — the workdir must be
	// removed explicitly on every path out of this function, including the
	// child's own nonzero exit code (previously leaked one throwaway temp
	// dir per failing `clarus run`).
	exe := filepath.Join(workdir, "prog")

	diags, err := build.Build(args, exe)
	if err != nil {
		os.RemoveAll(workdir)
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	for _, d := range diags {
		fmt.Println(d.String())
	}
	if len(diags) > 0 {
		os.RemoveAll(workdir)
		os.Exit(1)
	}

	cmd := exec.Command(exe)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	os.RemoveAll(workdir)
	if exitErr, ok := err.(*exec.ExitError); ok {
		os.Exit(exitErr.ExitCode())
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
