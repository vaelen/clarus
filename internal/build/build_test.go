package build

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func writeFile(t *testing.T, dir, name, content string) string {
	t.Helper()
	p := filepath.Join(dir, name)
	if err := os.WriteFile(p, []byte(content), 0o644); err != nil {
		t.Fatal(err)
	}
	return p
}

func TestBuildHelloAlert(t *testing.T) {
	requireGoCompiler(t)
	dir := t.TempDir()
	src := writeFile(t, dir, "hello.cla", "on App.launch {\n    alert(\"hi\")\n}\n")
	exe := filepath.Join(dir, "hello")

	diags, err := Build([]string{src}, exe)
	if err != nil {
		t.Fatalf("Build: %v", err)
	}
	if len(diags) != 0 {
		t.Fatalf("want no diags, got %v", diags)
	}
	if _, err := os.Stat(exe); err != nil {
		t.Fatalf("want executable at %s: %v", exe, err)
	}

	out, err := exec.Command(exe).Output()
	if err != nil {
		t.Fatalf("run: %v", err)
	}
	if string(out) != "hi\n" {
		t.Fatalf("output: %q, want %q", out, "hi\n")
	}
}

func TestBuildCheckError(t *testing.T) {
	requireGoCompiler(t)
	dir := t.TempDir()
	src := writeFile(t, dir, "bad.cla", "var x: int = \"hi\"\n")
	exe := filepath.Join(dir, "bad")

	diags, err := Build([]string{src}, exe)
	if err != nil {
		t.Fatalf("Build: %v", err)
	}
	if len(diags) == 0 {
		t.Fatal("want diags for check error")
	}
	if _, statErr := os.Stat(exe); statErr == nil {
		t.Fatalf("want no output file at %s", exe)
	}
}

func TestBuildUnsupportedWindow(t *testing.T) {
	requireGoCompiler(t)
	dir := t.TempDir()
	src := writeFile(t, dir, "win.cla", "window W {\n    title: \"x\"\n}\n")
	exe := filepath.Join(dir, "win")

	diags, err := Build([]string{src}, exe)
	if err != nil {
		t.Fatalf("Build: %v", err)
	}
	if len(diags) == 0 {
		t.Fatal("want unsupported-construct diag")
	}
	found := false
	for _, d := range diags {
		if strings.Contains(d.Msg, "window") {
			found = true
		}
	}
	if !found {
		t.Fatalf("want a diag naming window, got %v", diags)
	}
	if _, statErr := os.Stat(exe); statErr == nil {
		t.Fatalf("want no output file at %s", exe)
	}
}
