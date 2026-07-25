// Copyright 2026, Andrew C. Young <andrew@vaelen.org>
// SPDX-License-Identifier: MIT

package emitui

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

// runAppInfo runs `clarusc appinfo <files...>` and returns combined stdout,
// stderr, and the process exit code (0 on clean exit).
func runAppInfo(t *testing.T, exe string, files ...string) (stdout, stderr string, code int) {
	t.Helper()
	args := append([]string{"appinfo"}, files...)
	cmd := exec.Command(exe, args...)
	var outBuf, errBuf bytes.Buffer
	cmd.Stdout = &outBuf
	cmd.Stderr = &errBuf
	err := cmd.Run()
	code = 0
	if err != nil {
		if ee, ok := err.(*exec.ExitError); ok {
			code = ee.ExitCode()
		} else {
			t.Fatalf("clarusc appinfo %v: %v", files, err)
		}
	}
	return outBuf.String(), errBuf.String(), code
}

// TestAppInfoFullFixture exercises the committed testdata/emitui/app_info.cla
// fixture (Task 2's app section: name/version/author/about, no icon/id) --
// asserts the exact appinfo stdout contract Task 6's shell parser consumes.
func TestAppInfoFullFixture(t *testing.T) {
	root := repoRoot(t)
	exe := buildClarusc(t)
	fixture := filepath.Join(root, "testdata", "emitui", "app_info.cla")

	stdout, stderr, code := runAppInfo(t, exe, fixture)
	if code != 0 {
		t.Fatalf("clarusc appinfo %s: exit %d, stderr: %s", fixture, code, stderr)
	}
	want := "app=1\nname=Bookmarks\nversion=1.0\n"
	if stdout != want {
		t.Errorf("stdout = %q, want %q", stdout, want)
	}
}

// TestAppInfoLabelFallback exercises the name resolution's second rung --
// no `name` property, so `name=` falls back to the app section's label.
func TestAppInfoLabelFallback(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()
	path := filepath.Join(dir, "probe.cla")
	src := "app Zap {}\n\non App.startCLI(args: list of string) {\n    quit 0\n}\n"
	if err := os.WriteFile(path, []byte(src), 0644); err != nil {
		t.Fatal(err)
	}

	stdout, stderr, code := runAppInfo(t, exe, path)
	if code != 0 {
		t.Fatalf("clarusc appinfo %s: exit %d, stderr: %s", path, code, stderr)
	}
	want := "app=1\nname=Zap\n"
	if stdout != want {
		t.Errorf("stdout = %q, want %q", stdout, want)
	}
}

// TestAppInfoFilenameFallback exercises the name resolution's third rung --
// no app section at all, so `name=` falls back to the first file's basename
// minus its .cla extension, and no `app=1` line prints.
func TestAppInfoFilenameFallback(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()
	path := filepath.Join(dir, "myprog.cla")
	src := "on App.startCLI(args: list of string) {\n    quit 0\n}\n"
	if err := os.WriteFile(path, []byte(src), 0644); err != nil {
		t.Fatal(err)
	}

	stdout, stderr, code := runAppInfo(t, exe, path)
	if code != 0 {
		t.Fatalf("clarusc appinfo %s: exit %d, stderr: %s", path, code, stderr)
	}
	want := "name=myprog\n"
	if stdout != want {
		t.Errorf("stdout = %q, want %q", stdout, want)
	}
}

// TestAppInfoIconJoin exercises the icon path's join against the DECLARING
// file's directory (not the cwd or entry file), plus the id line.
func TestAppInfoIconJoin(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()
	subDir := filepath.Join(dir, "sub")
	if err := os.MkdirAll(subDir, 0755); err != nil {
		t.Fatal(err)
	}
	path := filepath.Join(subDir, "prog.cla")
	src := "app Sprocket {\n" +
		"    name: \"Sprocket\"\n" +
		"    icon: \"art/i.pbm\"\n" +
		"    id: \"TEST\"\n" +
		"}\n\n" +
		"on App.startCLI(args: list of string) {\n    quit 0\n}\n"
	if err := os.WriteFile(path, []byte(src), 0644); err != nil {
		t.Fatal(err)
	}

	stdout, stderr, code := runAppInfo(t, exe, path)
	if code != 0 {
		t.Fatalf("clarusc appinfo %s: exit %d, stderr: %s", path, code, stderr)
	}
	want := "app=1\nname=Sprocket\nid=TEST\nicon=" + filepath.Join(subDir, "art", "i.pbm") + "\n"
	if stdout != want {
		t.Errorf("stdout = %q, want %q", stdout, want)
	}
}

// TestAppInfoCheckError asserts that a program failing the checker (an
// invalid app id) prints its diagnostic and exits 1, exactly like `clarusc
// check`/`clarusc emit` -- appinfo runs the same pipeline, no special-casing.
func TestAppInfoCheckError(t *testing.T) {
	exe := buildClarusc(t)
	dir := t.TempDir()
	path := filepath.Join(dir, "bad.cla")
	src := "app Bad {\n    id: \"bad\"\n}\n\non App.startCLI(args: list of string) {\n    quit 0\n}\n"
	if err := os.WriteFile(path, []byte(src), 0644); err != nil {
		t.Fatal(err)
	}

	stdout, stderr, code := runAppInfo(t, exe, path)
	if code != 1 {
		t.Fatalf("clarusc appinfo %s: exit = %d, want 1 (stdout: %s, stderr: %s)", path, code, stdout, stderr)
	}
	const want = "app id must be exactly 4 printable characters"
	if !bytes.Contains([]byte(stdout+stderr), []byte(want)) {
		t.Errorf("stdout+stderr %q missing %q", stdout+stderr, want)
	}
}
