API_VERSION = 4

-- function remove_boost(policy)
--     set_boost_rel(policy, nil)
--     set_boost_abs(policy, nil)
-- end

function set_default_ignore(ignore, pkg)
    if ignore then
        if pkg == "com.miHoYo.Yuanshen" or pkg == "com.miHoYo.ys.mi" or pkg == "com.miHoyo.ys.bilibili" or pkg == "com.miHoYo.GenshinImpact" then
            set_ignore_policy(0, true)
            set_ignore_policy(2, true)
        else
            set_ignore_policy(0, true)
        end
    else
        set_ignore_policy(0, false)
        set_ignore_policy(2, false)
        set_ignore_policy(5, false)
        set_ignore_policy(7, false)
    end
end

function set_default_extra_policy(extra_policy, pkg)
    if extra_policy then
        if pkg == "com.tencent.tmgp.sgame" or pkg == "com.levelinfinite.sgameGlobal" then
            set_extra_policy_rel(0, 2, -400000, 0)
            set_extra_policy_rel(2, 7, -200000, 0)
            set_extra_policy_abs(5, 499200, 960000)
        elseif pkg == "com.miHoYo.Yuanshen" or pkg == "com.miHoYo.ys.mi" or pkg == "com.miHoyo.ys.bilibili" or pkg == "com.miHoYo.GenshinImpact" then
            set_extra_policy_rel(2, 7, -100000, 0)
            set_extra_policy_rel(5, 7, -350000, 0)
        elseif pkg == "com.tencent.KiHan" then
            set_extra_policy_rel(0, 2, -250000, 0)
            set_extra_policy_rel(2, 5, -200000, 0)
            set_extra_policy_rel(5, 7, -250000, 0)
        elseif pkg == "com.tencent.tmgp.pubgmhd" or pkg == "com.tencent.ig" or pkg == "com.pubg.krmobile" or pkg == "com.tencent.litece" then
            set_extra_policy_rel(0, 2, -150000, 0)
            set_extra_policy_rel(2, 5, -150000, 0)
            set_extra_policy_rel(5, 7, -250000, 0)
        elseif pkg == "com.kurogame.mingchao" or pkg == "com.kurogame.wutheringwaves.global" then
            set_extra_policy_rel(0, 2, -150000, 0)
            set_extra_policy_rel(2, 5, -150000, 0)
            set_extra_policy_rel(5, 7, -150000, 0)
        elseif pkg == "com.tencent.tmgp.cf" then
            set_extra_policy_rel(5, 7, -350000, -250000)
        elseif pkg == "com.netease.l22" or pkg =="com.gnml.yjwjxxfcpl" then
            set_extra_policy_rel(2, 5, -150000, -100000)
            set_extra_policy_rel(5, 7, -275000, -200000)
        elseif pkg == "com.netease.sky" then
            set_extra_policy_rel(2, 7, -250000, -150000)
            set_extra_policy_abs(5, 614400, 729600)
        elseif pkg == "com.miHoYo.Nap" or pkg == "com.miHoYo.zenless" then
            set_extra_policy_rel(0, 2, -150000, -50000)
            set_extra_policy_rel(2, 7, -350000, -300000)
            set_extra_policy_abs(5, 614400, 729600)
        else
            set_extra_policy_rel(0, 2, -150000, 0)
            set_extra_policy_rel(2, 5, -150000, 0)
            set_extra_policy_rel(5, 7, -150000, 0)
        end
    else
        remove_extra_policy(0)
        remove_extra_policy(2)
        remove_extra_policy(5)
        remove_extra_policy(7)
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
--     set_default_governor(true, pkg)
end

-- function game_scene_change(scene, pkg)
--     if scene == "battle" then
--         remove_boost(0)
--         remove_boost(2)
--         remove_boost(5)
--         remove_boost(7)
--         set_default_ignore(true, pkg)
--         set_boost_rel(0, 0.3)
--         set_boost_rel(2, 0.3)
--         set_boost_rel(5, 0.3)
--         set_boost_rel(7, 0.3)
--     elseif scene == "menu" then
--         remove_boost(0)
--         remove_boost(2)
--         remove_boost(5)
--         remove_boost(7)
--         set_default_ignore(false, pkg)
--         set_ignore_policy(0, true)
--         set_ignore_policy(2, true)
--         set_boost_abs(5, 0)
--         set_boost_abs(7, 0)
--     elseif scene == "loading" then
--         remove_boost(0)
--         remove_boost(2)
--         remove_boost(5)
--         remove_boost(7)
--         set_default_ignore(false, pkg)
--         set_ignore_policy(0, true)
--         set_ignore_policy(2, true)
--         set_ignore_policy(5, true)
--         set_ignore_policy(7, true)
--     elseif scene == "smooth" then
--         remove_boost(0)
--         remove_boost(2)
--         remove_boost(5)
--         remove_boost(7)
--         set_default_ignore(true, pkg)
--         set_boost_rel(0, -0.1)
--         set_boost_rel(2, -0.1)
--         set_boost_rel(5, -0.1)
--         set_boost_rel(7, -0.1)
--     elseif scene == "struggling" then
--         remove_boost(0)
--         remove_boost(2)
--         remove_boost(5)
--         remove_boost(7)
--         set_default_ignore(true, pkg)
--         set_boost_rel(0, 0.1)
--         set_boost_rel(2, 0.1)
--         set_boost_rel(5, 0.1)
--         set_boost_rel(7, 0.1)
--     end
-- end

function unload_fas(pid, pkg)
    set_default_ignore(false, pkg)
    set_default_extra_policy(false, pkg)
--     set_default_governor(false, pkg)
--     remove_boost(0)
--     remove_boost(2)
--     remove_boost(5)
--     remove_boost(7)
end
