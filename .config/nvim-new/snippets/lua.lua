---@diagnostic disable: undefined-global

return {
        s({ trig = 'if' },
                fmta([[
                     if <> then
                             <>
                     end
                     ]], { i(1), i(2) }
                )
        ),
}
