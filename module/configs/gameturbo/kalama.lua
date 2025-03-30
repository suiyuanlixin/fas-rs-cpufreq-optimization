API_VERSION = 4

function set_default_ignore(ignore, pkg)
    if ignore then
        set_ignore_policy(0, true)
    else
        set_ignore_policy(0, false)
        set_ignore_policy(3, false)
        set_ignore_policy(7, false)
    end
end

function set_default_extra_policy(extra_policy, pkg)
    if extra_policy then
        if pkg == "com.tencent.tmgp.sgame" or pkg == "com.levelinfinite.sgameGlobal" then
            set_extra_policy_abs(0, 1555200, 2016000)
            set_extra_policy_abs(3, 1785600, 2707200)
            set_extra_policy_abs(7, 2342400, 2956800)
        elseif pkg == "com.miHoYo.Yuanshen" or pkg == "com.miHoYo.ys.mi" or pkg == "com.miHoyo.ys.bilibili" or pkg == "com.miHoYo.GenshinImpact" then
            set_extra_policy_abs(0, 1555200, 2016000)
            set_extra_policy_abs(3, 1785600, 2707200)
            set_extra_policy_abs(7, 2592000, 2956800)
        else
            set_extra_policy_abs(0, 1555200, 2016000)
            set_extra_policy_abs(3, 2323200, 2707200)
            set_extra_policy_abs(7, 2592000, 2956800)
        end
    else
        remove_extra_policy(0)
        remove_extra_policy(3)
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
