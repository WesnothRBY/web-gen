#textdomain wesnoth-multiplayer
[multiplayer]
    id="RBY_Custom" {RBY_RELEASE}
    name= _ "RBY Custom " {RBY_RELEASE}
    description= _ "/names/."

    {RBY_INIT_SET Custom}

    [event]
        name=prestart
        {RANDOM 0../max/}

        [switch]
            variable=random
            /scenarios/
        [/switch]

        [set_variable]
            name=rby_set_message
            value=true
        [/set_variable]

        [set_variables]
            name=rby_set_info
            [value]
                val= _ "Custom"
            [/value]
            [value]
                val= _ "/names/"
            [/value]
        [/set_variables]

        {RBY_END_LEVEL}
    [/event]
[/multiplayer]
