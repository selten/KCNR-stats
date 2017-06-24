search
    div.row
        div.col.s12
            div.row
                div.input-field.col.s8
                    i.material-icons.prefix person
                    input.autocomplete#searchinput(type="text")
                    label(for="searchinput") Username
                div.col.s4
                    select#statSelect(multiple)
                        option(value="", disabled, selected) Choose
                        option(
                            each="{option,bool in options}",
                            value="{option}",
                            selected="{bool}"
                        ) {option}
                    label Statistics
    div.row#playerstats
        div.col.s12
            div.row(style="border-bottom: 1px solid black;")
                div.col.s1
                    span(style="font-weight: bold;") Username
                div.col.s1(each="{stat in selectedstat}")
                    span(style="font-weight: bold;") {stat}
            div.row(each="{id,playerdata in playerData}")
                div.col.s1 {playerdata['Username']}
                div.col.s1(each="{stat in selectedstat}") {playerdata[stat]}
    script(type="text/coffeescript").
        self = @
        self.autocompletedata = {}
        self.options = {
            "Score": true,
            "kd_ratio": true,
            "Kills": true,
            "Deaths": true,
            "Donator": true,
            "Arrests": true,
            "Times arrested": true,
            "SWAT": true,
            "Coprank": true
        }
        self.playerSelected = ""
        self.playerData = {}
        self.selectedstat = []

        @on 'mount', ->
            $('#playerstats').hide()
            $.get 'get_names', (res) ->
                data = if typeof res == "string" then JSON.parse(res) else res
                for name in data
                    self.autocompletedata[name] = null

                $('input.autocomplete').autocomplete({
                    data: self.autocompletedata,
                    limit: 20,
                    minLength: 0,
                    onAutocomplete: (input) ->
                        self.playerSelected = input
                        self.update({playerSelected: input})
                        $.get 'get_player_info/'+input, (res) ->
                            self.playerData = if typeof res == "string" then JSON.parse(res) else res
                            self.selectedstat = $('#statSelect').val()
                            self.update({playerData: self.playerData, selectedstat: self.selectedstat})
                            $('#playerstats').show()
                });
            $('select').material_select()
            $('#statSelect').on('change', () ->
                self.selectedstat = $('#statSelect').val()
                self.update({selectedstat: self.selectedstat})
            )

