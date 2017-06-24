kill-death
    div.col.s12
        div.row
            div.col.s6
                h4 Highest K/D ratio
            div.col.s6
                h4 Lowest K/D ratio
        div.row
            div.col.s6
                div.row
                    div.col.s3
                        h5 Username
                    div.col.s3
                        h5 K/D ratio
                    div.col.s3
                        h5 Kills
                    div.col.s3
                        h5 Deaths
                div(each="{score in topscores}")
                    div.row(
                        each="{id in topscore_id[score]}"
                    )
                        div.col.s3 {top10[id].Username}
                        div.col.s3 {top10[id].kd_ratio.toFixed(2)}
                        div.col.s3 {top10[id].Kills}
                        div.col.s3 {top10[id].Deaths}
            div.col.s6
                div.row
                    div.col.s3
                        h5 Username
                    div.col.s3
                        h5 K/D ratio
                    div.col.s3
                        h5 Kills
                    div.col.s3
                        h5 Deaths
                div(each="{score in bottomscores}")
                    div.row(
                        each="{id in bottomscore_id[score]}"
                    )
                        div.col.s3 {bottom10[id].Username}
                        div.col.s3 {bottom10[id].kd_ratio.toFixed(2)}
                        div.col.s3 {bottom10[id].Kills}
                        div.col.s3 {bottom10[id].Deaths}
    script(type="text/coffeescript").
        self = @
        self.top10 = {}
        self.bottom10 = {}

        @on 'mount', ->
            self.get_top_10()
            self.get_bottom_10()

        @get_top_10 = () ->
            $.get 'get_top_10_kd', (res) ->
                data = if typeof res == "string" then JSON.parse(res) else res
                scores = []
                score_id = {}
                for id, pdata of data
                    scores.push(pdata.kd_ratio)
                    arr = if score_id[pdata.kd_ratio] == undefined then [] else score_id[pdata.kd_ratio]
                    arr.push(id)
                    score_id[pdata.kd_ratio] = arr
                scores.sort((a, b) -> return b - a)
                self.update({top10: data, topscores: scores, topscore_id: score_id})

        @get_bottom_10 = () ->
            $.get 'get_bottom_10_kd', (res) ->
                data = if typeof res == "string" then JSON.parse(res) else res
                scores = []
                score_id = {}
                for id, pdata of data
                    scores.push(pdata.kd_ratio)
                    arr = if score_id[pdata.kd_ratio] == undefined then [] else score_id[pdata.kd_ratio]
                    arr.push(id)
                    score_id[pdata.kd_ratio] = arr
                scores.sort((a, b) -> return a - b)
                self.update({bottom10: data, bottomscores: scores, bottomscore_id: score_id})