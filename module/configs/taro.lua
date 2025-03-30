API_VERSION = 4

-- function remove_boost(policy)
--     set_boost_rel(policy, nil)
--     set_boost_abs(policy, nil)
-- end

function set_default_ignore(ignore, pkg)
    if ignore then
        set_ignore_policy(0, true)
    else
        set_ignore_policy(0, false)
        set_ignore_policy(4, false)
        set_ignore_policy(7, false)
    end
end

function set_default_extra_policy(extra_policy, pkg)
    if extra_policy then
        if pkg == "com.tencent.tmgp.sgame" or pkg == "com.levelinfinite.sgameGlobal" then
            set_extra_policy_rel(0, 4, -50000, 0)
            set_extra_policy_rel(4, 7, -250000, 0)
        elseif pkg == "com.miHoYo.Yuanshen" or pkg == "com.miHoYo.ys.mi" or pkg == "com.miHoyo.ys.bilibili" or pkg == "com.miHoYo.GenshinImpact" then
            set_extra_policy_rel(0, 4, -150000, 0)
            set_extra_policy_rel(7, 4, -400000, 0)
        elseif pkg == "com.tencent.tmgp.pubgmhd" or pkg == "com.tencent.ig" or pkg == "com.pubg.krmobile" or pkg == "com.tencent.litece" then
            set_extra_policy_rel(4, 7, -250000, 0)
        elseif pkg == "com.kurogame.mingchao" or pkg == "com.kurogame.wutheringwaves.global" then
            set_extra_policy_rel(4, 7, -250000, 0)
        elseif pkg == "com.tencent.tmgp.cf" then
            set_extra_policy_rel(0, 7, -150000, 0)
            set_extra_policy_rel(4, 7, -250000, 0)
        elseif pkg == "com.tencent.lolm" then
            set_extra_policy_rel(0, 4, -200000, -150000)
            set_extra_policy_rel(4, 7, -750000, -700000)
            set_extra_policy_abs(7, 1536000, 2707200)
        elseif pkg == "com.tencent.KiHan" or pkg == "com.tencent.gamematrix.kihan" then
            set_extra_policy_rel(4, 7, -350000, 0)
        elseif pkg == "com.tencent.tmgp.cod" or pkg == "com.activision.callofduty.shooter" then
            set_extra_policy_rel(4, 7, -100000, 0)
        elseif pkg == "com.netease.l22" or pkg == "com.gnml.yjwjxxfcpl" then
            set_extra_policy_rel(4, 7, -350000, -200000)
        elseif pkg == ".com.sgshd.nearme.gamecenter" then
            set_extra_policy_rel(0, 4, -200000, -150000)
            set_extra_policy_rel(4, 7, -350000, -250000)
        elseif pkg == "com.hypergryph.arknights" then
            set_extra_policy_rel(0, 4, -350000, -250000)
            set_extra_policy_rel(4, 7, -350000, -150000)
        elseif pkg == "com.proximabeta.mf.uamo" then
            set_extra_policy_rel(0, 4, -250000, -200000)
            set_extra_policy_rel(4, 7, -150000, 0)
        else
            set_extra_policy_rel(0, 4, -150000, 0)
            set_extra_policy_rel(4, 7, -150000, 0)
        end
    else
        remove_extra_policy(0)
        remove_extra_policy(4)
        remove_extra_policy(7)
    end
end

function load_fas(pid, pkg)
    set_default_ignore(true, pkg)
    set_default_extra_policy(true, pkg)
end

-- function game_scene_change(scene, pkg)
--     if scene == "battle" then
--         remove_boost(0)
--         remove_boost(4)
--         remove_boost(7)
--         set_default_ignore(true, pkg)
--         set_boost_rel(0, 0.3)
--         set_boost_rel(4, 0.3)
--         set_boost_rel(7, 0.3)
--     elseif scene == "menu" then
--         remove_boost(0)
--         remove_boost(4)
--         remove_boost(7)
--         set_default_ignore(false, pkg)
--         set_ignore_policy(0, true)
--         set_boost_abs(4, 0)
--         set_boost_abs(7, 0)
--     elseif scene == "loading" then
--         remove_boost(0)
--         remove_boost(4)
--         remove_boost(7)
--         set_default_ignore(false, pkg)
--         set_ignore_policy(0, true)
--         set_ignore_policy(4, true)
--         set_ignore_policy(7, true)
--     elseif scene == "smooth" then
--         remove_boost(0)
--         remove_boost(4)
--         remove_boost(7)
--         set_default_ignore(true, pkg)
--         set_boost_rel(0, -0.1)
--         set_boost_rel(4, -0.1)
--         set_boost_rel(7, -0.1)
--     elseif scene == "struggling" then
--         remove_boost(0)
--         remove_boost(4)
--         remove_boost(7)
--         set_default_ignore(true, pkg)
--         set_boost_rel(0, 0.1)
--         set_boost_rel(4, 0.1)
--         set_boost_rel(7, 0.1)
--     end
-- end

function unload_fas(pid, pkg)
    set_default_ignore(false, pkg)
    set_default_extra_policy(false, pkg)
--     remove_boost(0)
--     remove_boost(4)
--     remove_boost(7)
end
