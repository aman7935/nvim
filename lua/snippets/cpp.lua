local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s("main", {
		t({ "#include <iostream>", "using namespace std;", "", "int main() {" }),
		t("\t"),
		i(1),
		t({ "", "\treturn 0;", "}" }),
	}),
	s("inc", {
		t("#include <"),
		i(1),
		t(">"),
	}),
	s("cl", {
		t("class "),
		i(1, "Name"),
		t({ " {", "public:" }),
		t("\t"),
		i(2),
		t({ "", "", "private:" }),
		t("\t"),
		i(3),
		t({ "", "};" }),
	}),
	s("co", {
		t("cout << "),
		i(1),
		t(" << endl;"),
	}),
	s("ci", {
		t("cin >> "),
		i(1),
		t(";"),
	}),
	s("cout", {
		t("cout << "),
		i(1),
		t(";"),
	}),
	s("cin", {
		t("cin >> "),
		i(1),
		t(";"),
	}),
}
