if SERVER then
    hook.Add("TTT2ModifyBuyableWeapons", "AddPureChaosSWEP", function(tbl)
        table.insert(tbl[ROLE_TRAITOR], "weapon_ttt_purechaos")
    end)
    print("Server loaded PURE CHAOS and added it to the shop!")
end
