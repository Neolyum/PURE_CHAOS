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

    form:MakeCheckBox({
        label = "purechaos_settings_use_alt_sound",
        serverConvar = "purechaos_use_alt_sound"
    })

    
    -- Add the dropdown for sound override
    local dropdown = form:MakeComboBox({
        label = "purechaos_settings_sound_override",
        options = {
            { text = "Follow server setting", value = -1 },
            { text = "Use alternative sound", value = 1 },
            { text = "Use default sound", value = 0 },
        },
        defaultValue = -1,  -- Default is follow server setting
    })

    -- Listen for changes and send to the client
    dropdown.OnSelect = function(_, _, value)
        RunConsoleCommand("purechaos_use_alt_sound_override", value)
    end
end