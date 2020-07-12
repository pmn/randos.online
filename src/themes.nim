import tables

type 
    Theme* = object
        background*, brand*, text*: string

const default = Theme(background: "#E7F4FF", brand: "#FFFFFF", text: "#2F3F4E")
const red = Theme(background: "#FF0000", brand: "#000000", text: "#FFFFFF")
const blue = Theme(background: "#0000FF", brand: "#000000", text: "#FFFFFF")
const green = Theme(background: "#00FF00", brand: "#000000", text: "#FFFFFF")

const themes = {"default": default, "red": red, "blue": blue, "green": green}.toTable()

proc getTheme*(name: string): Theme =
    result = themes.getOrDefault(name, default)