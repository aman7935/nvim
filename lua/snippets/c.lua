local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s("main", {
		t({ "#include <stdio.h>", "", "int main(void) {" }),
		t("\t"),
		i(1),
		t({ "", "\treturn 0;", "}" }),
	}),
	s("inc", {
		t("#include <"),
		i(1),
		t(">"),
	}),
	s("struct", {
		t("typedef struct "),
		i(1, "name"),
		t({ " {", "\t" }),
		i(2),
		t({ "", "} " }),
		i(3, "name"),
		t(";"),
	}),
	s("guard", {
		t("#ifndef "),
		i(1, "HEADER_H"),
		t({ "", "#define " }),
		i(2, "HEADER_H"),
		t({ "", "", "#endif // " }),
		i(3, "HEADER_H"),
	}),
}
