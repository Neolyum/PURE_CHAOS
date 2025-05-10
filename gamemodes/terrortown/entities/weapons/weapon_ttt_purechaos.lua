if SERVER then
    AddCSLuaFile()
    resource.AddFile("gamemodes/terrortown/content/sound/pure_chaos.ogg")
    resource.AddFile("gamemodes/terrortown/content/sound/pure_chaos_kller.ogg")
    resource.AddFile("materials/Scarlet_Witch.png")

    CreateConVar("purechaos_range", 4000, { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The range of PURE CHAOS.")
    CreateConVar("purechaos_verticalpower", 30, { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The strength of flying up and down while PURE CHAOS.")
    CreateConVar("purechaos_damage", 110, { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "The damage of PURE CHAOS.")
    CreateConVar("purechaos_use_alt_sound", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Use kller sound for Pure Chaos.")


    print("PURE CHAOS v1.1 by Neolyum loaded.")
else
    CreateClientConVar("purechaos_range", 4000, true, false, "The range of PURE CHAOS.")
    CreateClientConVar("purechaos_verticalpower", 30, true, false, "The strength of flying up and down while PURE CHAOS.")
    CreateClientConVar("purechaos_damage", 110, true, false, "The damage of PURE CHAOS.")
    CreateClientConVar("purechaos_use_alt_sound", 0, true, false, "Use kller sound for Pure Chaos.")
    CreateClientConVar("purechaos_use_alt_sound_override", -1, true, true, "Override server default for the alternative Sound: -1 = use server setting, 0 = off, 1 = use alt sound")

    print("PURE CHAOS v1.1 by Neolyum loaded.")
end

SWEP.Base = "weapon_tttbase"
SWEP.PrintName = "Pure Chaos"
SWEP.Author = "Neolyum"
SWEP.Instructions = "The Ultimate of Scarlet Witch. Unleash chaos! Hover and damage players around you."
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false


SWEP.Slot = 7
SWEP.Icon = "materials/Scarlet_Witch.png"
SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "PURE CHAOS",
    desc = "The Ultimate of Scarlet Witch.\nUnleash chaos!\nHover and damage nearby enemies."
}

SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} 
SWEP.LimitedStock = true
SWEP.NoSights = true

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.HoldType = "normal"

function SWEP:PrimaryAttack()
    if CLIENT then
        return
    end

    self:SetNextPrimaryFire( CurTime() + 5 )

    local ende = false
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    -- Give the player fall damage immunity
    owner.fallDamageImmune = true

    -- owner:SendLua("RunConsoleCommand('thirdperson')")

    -- Store original movement data
    local originalWalkSpeed = owner:GetWalkSpeed()
    local originalMoveType = owner:GetMoveType()

    owner:SetWalkSpeed(originalWalkSpeed * 0.5)
    owner:SetMoveType(MOVETYPE_FLY)

    local useAlt = GetConVar("purechaos_use_alt_sound"):GetBool()

    -- Check for client override
    if owner:IsPlayer() and owner:IsValid() then
        local override = owner:GetInfoNum("purechaos_use_alt_sound_override", -1)
        if override == 0 then
            useAlt = false
        elseif override == 1 then
            useAlt = true
        end
    end

    local soundFile = useAlt and "pure_chaos_kller.ogg" or "pure_chaos.ogg"

    self:EmitSound(soundFile, SNDLVL_NONE)
    owner:SetNWBool("PureChaosActive", true)


    -- checking if we are close to the ground and pushing up if true. When we land,
    --  the controls get kind of cursed
    local currentPos = owner:EyePos()
    local trace = util.TraceLine({
        start = currentPos,
        endpos = currentPos + Vector(0, 0, 70),
        filter = owner
    })
    if trace.Hit then
        print("PURE CHAOS: Not launching upwards due to obstacle above!")
    else
        owner:SetPos(owner:GetPos() + Vector(0, 0, 60))
    end
    
    local verticalPower = GetConVar("purechaos_verticalpower"):GetInt() or 30
    timer.Create("ChaosFlight_" .. owner:SteamID(), 0.2, 0, function()
        if not IsValid(owner) or not owner:Alive() or ende then
            timer.Remove("ChaosFlight_" .. owner:SteamID())
            return
        end

        local upward = Vector(0, 0, 0)

        -- Allow vertical control (Jump to go up, Crouch to go down)
        if owner:KeyDown(IN_JUMP) then
            upward = Vector(0, 0, verticalPower)
        elseif owner:KeyDown(IN_DUCK) then
            upward = Vector(0, 0, -verticalPower)
        end

        owner:SetVelocity(upward)

        local currentPos = owner:GetPos()
        local trace = util.TraceLine({
            start = currentPos,
            endpos = currentPos + Vector(0, 0, -30),
            filter = owner
        })
        if trace.Hit then
            owner:SetVelocity(Vector(0, 0, verticalPower - verticalPower * 0.6))
        end

    end)

    -- After 4 seconds, start damaging players in range
    timer.Simple(4, function()
        if IsValid(owner) and owner:Alive() then
            local range = GetConVar("purechaos_range"):GetInt() or 4000
            local damage = GetConVar("purechaos_damage"):GetInt() or 110

            for _, target in pairs(player.GetAll()) do
                if target ~= owner and target:Alive() then
                    local distance = owner:EyePos():Distance(target:EyePos())
                    if distance <= range then
                        local trace = util.TraceLine({
                            start = owner:EyePos(),
                            endpos = target:EyePos(),
                            filter = {owner, target}
                        })

                        if not trace.Hit then
                            target:TakeDamage(damage, owner, self)
                        end
                    end
                end
            end
        end
    end)

    -- After 6 seconds, reset movement
    timer.Simple(5, function()
        if IsValid(owner) then
            --Remove fall damage immunity after another 5 seconds
            timer.Simple(5, function()
                if IsValid(owner) then
                    owner.fallDamageImmune = false
                end
            end)
            
            ende = true
            owner:SetNWBool("PureChaosActive", false)
            -- owner:SendLua("RunConsoleCommand('firstperson')")
            owner:SetMoveType(originalMoveType)
            owner:SetWalkSpeed(originalWalkSpeed)

            
            -- Remove weapon after use
            owner:StripWeapon(self:GetClass())

            timer.Remove("HoverTimer_" .. owner:SteamID())

        end
    end)

end


hook.Add("EntityTakeDamage", "PureChaos_FallDamageImmunity", function(target, dmgInfo)
    if target:IsPlayer() and target.fallDamageImmune and dmgInfo:IsFallDamage() then
        dmgInfo:SetDamage(0)
    end
end)


hook.Add("PreDrawHalos", "PureChaos_HighlightEnemies", function()
    local client = LocalPlayer()
    
    -- Only run if the player has activated the ability
    if not client:GetNWBool("PureChaosActive", false) then return end

    local enemies = {}
    local range = GetConVar("purechaos_range"):GetInt() or 4000

    for _, target in ipairs(player.GetAll()) do
        if target ~= client and target:Alive() and client:GetPos():Distance(target:GetPos()) <= range then
            local trace = util.TraceLine({
                start = client:EyePos(),
                endpos = target:EyePos(),
                filter = {client, target}
            })

            if not trace.Hit then
                table.insert(enemies, target)
            end
        end
    end

    if #enemies > 0 then
        halo.Add(enemies, Color(255, 0, 0), 2, 2, 1, true, true)
    end
end)

hook.Add("PlayerDeath", "PureChaos_StopSoundOnDeath", function(victim, inflictor, attacker)
    if not IsValid(victim) then return end
    if victim:GetNWBool("PureChaosActive", false) then
        local useAlt = GetConVar("purechaos_use_alt_sound"):GetBool()

        -- Check for client override
        if owner:IsPlayer() and owner:IsValid() then
            local override = owner:GetInfoNum("purechaos_use_alt_sound_override", -1)
            if override == 0 then
                useAlt = false
            elseif override == 1 then
                useAlt = true
            end
        end

        local soundFile = useAlt and "pure_chaos_kller.ogg" or "pure_chaos.ogg"
        victim:StopSound(soundFile)
    end
end)
