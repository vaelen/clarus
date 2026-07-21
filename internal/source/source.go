package source

import (
	"fmt"
	"os"
)

type Pos struct{ Offset int }

type File struct {
	Name    string
	Content []byte
}

func Load(path string) (*File, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	return &File{Name: path, Content: b}, nil
}

func (f *File) LineCol(p Pos) (line, col int) {
	line, col = 1, 1
	for i := 0; i < p.Offset && i < len(f.Content); i++ {
		if f.Content[i] == '\n' {
			line++
			col = 1
		} else {
			col++
		}
	}
	return line, col
}

type Diag struct {
	File *File
	Pos  Pos
	Msg  string
}

func (d Diag) String() string {
	l, c := d.File.LineCol(d.Pos)
	return fmt.Sprintf("%s:%d:%d: %s", d.File.Name, l, c, d.Msg)
}
