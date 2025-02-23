CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "PURE CHAOS"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "purechaos_settings")

    form:MakeSlider({
        label = "purechaos_settings_range",
        serverConvar = "purechaos_range",
        min = 200,
        max = 20000,
        decimal = 0
    })

    form:MakeSlider({
        label = "purechaos_settings_verticalpower",
        serverConvar = "purechaos_verticalpower",
        min = 10,
        max = 200,
        decimal = 0
    })

    form:MakeSlider({
        label = "purechaos_settings_damage",
        serverConvar = "purechaos_damage",
        min = 20,
        max = 200,
        decimal = 0
    })
end