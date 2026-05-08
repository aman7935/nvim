local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s("cl", {
		t("console.log("),
		i(1),
		t(")"),
	}),
	s("ec", {
		t("export const "),
		i(1, "name"),
		t(" = "),
		i(2, "value"),
		t(";"),
	}),
	s("el", {
		t("export let "),
		i(1, "name"),
		t(" = "),
		i(2, "value"),
		t(";"),
	}),
}
