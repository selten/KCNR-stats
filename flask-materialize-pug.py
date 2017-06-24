from flask import Flask, request, send_from_directory, jsonify, Response, send_file
from flask_httpauth import HTTPBasicAuth
import pandas as pd
import os, json, joblib, time
import numpy as np
from app import DbCon

app = Flask(__name__)
db = DbCon()

def id_generator(size=10):
    import random, string
    chars= string.digits
    return ''.join(random.choice(chars) for _ in range(size))


@app.route("/")
#@auth.login_required
def start():
    #---- remove in production ---------------
    #----this section is for recompiling riotjs tags in each stage
    from subprocess import call
    print ('\033[94mrebuilding riot tags\033[0m')
    call('riot --template pug ./tags "%s/static/js/tags.js"' % (os.getcwd()), shell=True)
    #---- remove in production ---------------

    h = open('index.html').read()
    h = h % (id_generator())
    return h


@app.route('/<staticFile>')
def send_static(staticFile):
    '''serving static files'''
    return send_from_directory('', staticFile)


@app.route('/css/fonts/<path:path>')
def send_fonts(path):
    '''serving font files'''
    return send_from_directory('static/fonts', path)


@app.route('/fonts/<path:path>')
def send_fonts2(path):
    '''serving font files'''
    return send_from_directory('static/fonts', path)

@app.route('/css/<path:path>')
def send_css(path):
    '''serving css files'''
    return send_from_directory('static/css', path)


@app.route('/js/<path:path>')
def send_js(path):
    '''serving js files'''
    return send_from_directory('static/js', path)


@app.route('/get_top_10_score')
def api_get_top_10_score():
    return Response(db.get_score_highest_10().to_json(orient='index'), mimetype='application/json')


@app.route('/get_bottom_10_score')
def api_get_bottom_10_score():
    return Response(db.get_score_lowest_10().to_json(orient='index'), mimetype='application/json')


@app.route('/get_top_10_kd')
def api_get_top_10_kd():
    return Response(db.get_kd_highest_10().to_json(orient='index'), mimetype='application/json')


@app.route('/get_bottom_10_kd')
def api_get_bottom_10_kd():
    return Response(db.get_kd_lowest_10().to_json(orient='index'), mimetype='application/json')


@app.route('/get_names')
def api_get_names():
    return Response(db.get_names().to_json(orient='values'), mimetype='application/json')


@app.route('/get_player_info/<username>')
def api_get_player_info(username):
    return Response(db.get_player_info(username).to_json(orient='index'), mimetype='application/json')


@app.route('/get_top_10_arrest')
def api_get_top_10_arrest():
    return Response(db.get_arrest_highest_10().to_json(orient='index'), mimetype='application/json')


@app.route('/get_top_10_arrested')
def api_get_top_10_arrested():
    return Response(db.get_arrested_highest_10().to_json(orient='index'), mimetype='application/json')

if __name__ == '__main__':
    app.run(debug=True, threaded=True, host='0.0.0.0', port=5003)
