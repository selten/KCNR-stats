score
    div.col.s12
        div.row
            div.col.s6
                h4 Highest Score
            div.col.s6
                h4 Lowest Score
        div.row
            div.col.s6
                div.row
                    div.col.s6
                        h5 Username
                    div.col.s6
                        h5 Score
                div(each="{score in topscores}")
                    div.row(
                        each="{id in topscore_id[score]}"
                    )
                        div.col.s6 {top10[id].Username}
                        div.col.s6 {top10[id].Score}
            div.col.s6
                div.row
                    div.col.s6
                        h5 Username
                    div.col.s6
                        h5 Score
                div(each="{score in bottomscores}")
                    div.row(
                        each="{id in bottomscore_id[score]}"
                    )
                        div.col.s6 {bottom10[id].Username}
                        div.col.s6 {bottom10[id].Score}
    script(type="text/coffeescript").
        self = @
        self.top10 = {}
        self.bottom10 = {}

        @on 'mount', ->
            self.get_top_10()
            self.get_bottom_10()

        @get_top_10 = () ->
            $.get 'get_top_10_score', (res) ->
                data = if typeof res == "string" then JSON.parse(res) else res
                scores = []
                score_id = {}
                for id, pdata of data
                    scores.push(pdata.Score)
                    arr = if score_id[pdata.Score] == undefined then [] else score_id[pdata.Score]
                    arr.push(id)
                    score_id[pdata.Score] = arr
                scores.sort((a, b) -> return b-a)
                self.update({top10: data, topscores: scores, topscore_id: score_id})

        @get_bottom_10 = () ->
            $.get 'get_bottom_10_score', (res) ->
                data = if typeof res == "string" then JSON.parse(res) else res
                scores = []
                score_id = {}
                for id, pdata of data
                    scores.push(pdata.Score)
                    arr = if score_id[pdata.Score] == undefined then [] else score_id[pdata.Score]
                    arr.push(id)
                    score_id[pdata.Score] = arr
                scores.sort((a, b) -> return a - b)
                self.update({bottom10: data, bottomscores: scores, bottomscore_id: score_id})
