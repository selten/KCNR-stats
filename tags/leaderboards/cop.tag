cop
    div.col.s12
        div.row
            div.col.s6
                h4 Arrests
            div.col.s6
                h4 Times arrested
        div.row
            div.col.s6
                div.row
                    div.col.s3
                        h5 Username
                    div.col.s3
                        h5 Arrests
                    div.col.s3
                        h5 Takedowns
                    div.col.s3
                        h5 Times arrested
                div(each="{score in topscores}")
                    div.row(
                        each="{id in topscore_id[score]}"
                    )
                        div.col.s3 {top10[id].Username}
                        div.col.s3 {top10[id].Arrests}
                        div.col.s3 {top10[id]['Takedowns']}
                        div.col.s3 {top10[id]['Times arrested']}
            div.col.s6
                div.row
                    div.col.s3
                        h5 Username
                    div.col.s3
                        h5 Times arrested
                    div.col.s3
                        h5 Jail escapes
                    div.col.s3
                        h5 Arrests
                div(each="{score in bottomscores}")
                    div.row(
                        each="{id in bottomscore_id[score]}"
                    )
                        div.col.s3 {bottom10[id].Username}
                        div.col.s3 {bottom10[id]['Times arrested']}
                        div.col.s3 {bottom10[id]['Jail escapes']}
                        div.col.s3 {bottom10[id]['Arrests']}
    script(type="text/coffeescript").
        self = @
        self.top10 = {}
        self.bottom10 = {}

        @on 'mount', ->
            self.get_top_10()
            self.get_bottom_10()

        @get_top_10 = () ->
            $.get 'get_top_10_arrest', (res) ->
                data = if typeof res == "string" then JSON.parse(res) else res
                scores = []
                score_id = {}
                for id, pdata of data
                    scores.push(pdata.Arrests)
                    arr = if score_id[pdata.Arrests] == undefined then [] else score_id[pdata.Arrests]
                    arr.push(id)
                    score_id[pdata.Arrests] = arr
                scores.sort((a, b) -> return b - a)
                self.update({top10: data, topscores: scores, topscore_id: score_id})

        @get_bottom_10 = () ->
            $.get 'get_top_10_arrested', (res) ->
                data = if typeof res == "string" then JSON.parse(res) else res
                scores = []
                score_id = {}
                for id, pdata of data
                    scores.push(pdata['Times arrested'])
                    arr = if score_id[pdata['Times arrested']] == undefined then [] else score_id[pdata['Times arrested']]
                    arr.push(id)
                    score_id[pdata['Times arrested']] = arr
                scores.sort((a, b) -> return b - a)
                self.update({bottom10: data, bottomscores: scores, bottomscore_id: score_id})