---@diagnostic disable: undefined-global

return {
        s({ trig = 'ser' },
                fmta(
                        '[SerializeField] private <>;',
                        { i(1) }
                )
        ),
        s({ trig = 'oce2' },
                fmta(
                        [[
                        private void OnCollisionEnter2D(Collision2D collision)
                        {
                                <>
                        }
                        ]],
                        { i(1) }
                )
        ),
}
