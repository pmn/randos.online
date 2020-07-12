import tables

type 
    Theme* = object
        background*, brand*, brandtext*, text*: string

const default = Theme(background: "#E7F4FF", brand: "#445F77", brandtext: "#FFFFFF", text: "#2F3F4E")
const red = Theme(background: "#e6003a", brand: "#9a0027", brandtext: "#FFFFFF", text: "#FFFFFF")
const blue = Theme(background: "#0080ff", brand: "#005ab3", brandtext: "#FFFFFF", text: "#FFFFFF")
const green = Theme(background: "#ACDF87", brand: "#1E5631", brandtext: "#FFFFFF", text: "#1E5631")
const hotdog = Theme(background: "#FF0000", brand: "#FEFF00", brandtext: "#000", text: "#FEFF00")

const themes = {"default": default, 
                "red": red, 
                "blue": blue, 
                "green": green,
                "hotdog": hotdog}.toTable()

proc getTheme*(name: string): Theme =
    result = themes.getOrDefault(name, default)