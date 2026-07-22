package types

import "testing"

func TestAssignable(t *testing.T) {
	if !AssignableTo(StringT(255), StringT(63)) {
		t.Fatal("any string capacity assigns to any other (runtime clamps)")
	}
	if AssignableTo(IntT, FixedT) {
		t.Fatal("int is not assignable to fixed")
	}
	e1 := &Type{Kind: Enum, Enum: &EnumInfo{Name: "A"}}
	e2 := &Type{Kind: Enum, Enum: &EnumInfo{Name: "B"}}
	if AssignableTo(e1, e2) {
		t.Fatal("distinct enums do not assign")
	}
	if !AssignableTo(e1, e1) {
		t.Fatal("same enum assigns")
	}
	if !AssignableTo(ListT(IntT), ListT(IntT)) || AssignableTo(ListT(IntT), ListT(BoolT)) {
		t.Fatal("list elem types must match")
	}
}

func TestSaveChoice(t *testing.T) {
	if SaveChoice.Kind != Enum || len(SaveChoice.Enum.Members) != 3 {
		t.Fatal("saveChoice shape")
	}
	if SaveChoice.Enum.Members[1].Label != "Don't Save" {
		t.Fatal("Discard label")
	}
}
