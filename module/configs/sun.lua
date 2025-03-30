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
        set_ignore_policy(6, false)
    end
end

function set_default_extra_policy(extra_policy, pkg)
    if extra_policy then
        if pkg == "com.tencent.tmgp.sgame" or pkg == "com.levelinfinite.sgameGlobal" then
            set_extra_policy_rel(0, 6, 0, 100000)
            set_extra_policy_abs(6, 1017600, 1401600)
        elseif pkg == "com.miHoYo.Yuanshen" or pkg == "com.miHoYo.ys.mi" or pkg == "com.miHoyo.ys.bilibili" or pkg == "com.miHoYo.GenshinImpact" then
            set_extra_policy_rel(6, 0, -400000, 0)
        elseif pkg == "com.tencent.KiHan" then
            set_extra_policy_rel(0, 6, -250000, 0)
        elseif pkg == "com.tencent.jkchess" then
            set_extra_policy_rel(0, 6, -250000, -100000)
        elseif pkg == "com.netease.dwrg" then
            set_extra_policy_rel(6, 0, -250000, -50000)
        elseif pkg == "com.tencent.tmgp.pubgmhd" or pkg == "com.tencent.ig" or pkg == "com.pubg.krmobile" or pkg == "com.tencent.litece" then
            set_extra_policy_rel(0, 6, -100000, -50000)
        else
            set_extra_policy_rel(0, 6, -150000, 0)
        end
    else
        remove_extra_policy(0)
        remove_extra_policy(6)
    end
end

function set_default_disable_policy(disable, pkg)
    if disable then
        if pkg == "com.tencent.tmgp.sgame" or pkg == "com.levelinfinite.sgameGlobal" then
            os.execute("echo 0 > /sys/devices/system/cpu/cpu6/online")
        end
    else
        os.execute("echo 1 > /sys/devices/system/cpu/cpu6/online")
    end
end

function set_default_governor(governor, pkg)
    if governor then
        if pkg == "com.tencent.tmgp.sgame" or pkg == "com.levelinfinite.sgameGlobal" then
            for i = 0, 7 do
                os.execute("echo scx > /sys/devices/system/cpu/cpu"..i.."/cpufreq/scaling_governor")
            end
        end
    else
        for i = 0, 7 do
            os.execute("echo walt > /sys/devices/system/cpu/cpu"..i.."/cpufreq/scaling_governor")
        end
    end
end

function load_fas(pid, pkg)
    set_default_ignore(true, pkg)
    set_default_extra_policy(true, pkg)
--     set_default_disable_policy(true, pkg)
--     set_default_governor(true, pkg)
end

-- function game_scene_change(scene, pkg)
--     if scene == "battle" then
--         remove_boost(0)
--         remove_boost(6)
--         set_default_ignore(true, pkg)
--         set_boost_rel(0, 0.3)
--         set_boost_rel(6, 0.3)
--     elseif scene == "menu" then
--         remove_boost(0)
--         remove_boost(6)
--         set_default_ignore(false, pkg)
--         set_ignore_policy(0, true)
--         set_boost_abs(6, 0)
--     elseif scene == "loading" then
--         remove_boost(0)
--         remove_boost(6)
--         set_default_ignore(false, pkg)
--         set_ignore_policy(0, true)
--         set_ignore_policy(6, true)
--     elseif scene == "smooth" then
--         remove_boost(0)
--         remove_boost(6)
--         set_default_ignore(true, pkg)
--         set_boost_rel(0, -0.1)
--         set_boost_rel(6, -0.1)
--     elseif scene == "struggling" then
--         remove_boost(0)
--         remove_boost(6)
--         set_default_ignore(true, pkg)
--         set_boost_rel(0, 0.1)
--         set_boost_rel(6, 0.1)
--     end
-- end

function unload_fas(pid, pkg)
    set_default_ignore(false, pkg)
    set_default_extra_policy(false, pkg)
--     set_default_disable_policy(false, pkg)
--     set_default_governor(false, pkg)
--     remove_boost(0)
--     remove_boost(6)
end
