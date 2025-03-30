API_VERSION = 4

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
            set_extra_policy_abs(0, 1574400, 2265600)
            set_extra_policy_abs(2, 1708800, 3148800)
            set_extra_policy_abs(5, 1708800, 2956800)
            set_extra_policy_abs(7, 2304000, 3052800)
        elseif pkg == "com.miHoYo.Yuanshen" or pkg == "com.miHoYo.ys.mi" or pkg == "com.miHoyo.ys.bilibili" or pkg == "com.miHoYo.GenshinImpact" then
            set_extra_policy_abs(0, 1574400, 2265600)
            set_extra_policy_abs(2, 1708800, 3148800)
            set_extra_policy_abs(5, 1708800, 2956800)
            set_extra_policy_abs(7, 2553600, 3052800)
        elseif pkg == "com.tencent.tmgp.pubgmhd" then
            set_extra_policy_abs(0, 1574400, 2265600)
            set_extra_policy_abs(2, 2323200, 3148800)
            set_extra_policy_abs(5, 2323200, 2956800)
            set_extra_policy_abs(7, 2630400, 3052800)
        else
            set_extra_policy_abs(0, 1574400, 2265600)
            set_extra_policy_abs(2, 2323200, 3148800)
            set_extra_policy_abs(5, 2323200, 2956800)
            set_extra_policy_abs(7, 2553600, 3052800)
        end
    else
        remove_extra_policy(0)
        remove_extra_policy(2)
        remove_extra_policy(5)
        remove_extra_policy(7)
    end
end

function load_fas(pid, pkg)
    set_default_ignore(true, pkg)
    set_default_extra_policy(true, pkg)
end

function unload_fas(pid, pkg)
    set_default_ignore(false, pkg)
    set_default_extra_policy(false, pkg)
end
