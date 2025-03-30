API_VERSION = 4

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
            set_extra_policy_abs(0, 1363600, 3532800)
            set_extra_policy_abs(6, 1401600, 4320000)
        elseif pkg == "com.miHoYo.Yuanshen" or pkg == "com.miHoYo.ys.mi" or pkg == "com.miHoyo.ys.bilibili" or pkg == "com.miHoYo.GenshinImpact" then
            set_extra_policy_abs(0, 1363600, 3532800)
            set_extra_policy_abs(6, 1958400, 4320000)
        else
            set_extra_policy_abs(0, 2227200, 3532800)
            set_extra_policy_abs(6, 2438400, 4320000)
        end
    else
        remove_extra_policy(0)
        remove_extra_policy(6)
    end
end

function load_fas(pid, pkg)
    set_default_ignore(false, pkg)
    set_default_extra_policy(true, pkg)
end

function unload_fas(pid, pkg)
    set_default_ignore(false, pkg)
    set_default_extra_policy(false, pkg)
end
