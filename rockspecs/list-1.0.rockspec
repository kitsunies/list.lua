package = "list"
version = "1.0"
source = {
    url = "git+https://github.com/kitsunies/list.lua.git",
    tag = "v1.0"
}
description = {
    homepage = "https://github.com/kitsunies/list.lua",
    license = "MIT",
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "builtin",
    modules = {
        list = "list.lua"
    }
}
