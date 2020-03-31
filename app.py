from flask import Flask, render_template, jsonify
import requests
import datetime
from bs4 import BeautifulSoup

app = Flask(__name__)

res = requests.get("http://ncov.mohw.go.kr/static/image/map/map_main_new.svg")
soup = BeautifulSoup(res.text, 'html.parser')
svg = soup.find('svg')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/svg')
def getSvg():
    return str(svg)

@app.route('/corona')
def getCorona():
    res = requests.get("http://ncov.mohw.go.kr/")

    soup = BeautifulSoup(res.text, 'html.parser')
    div = soup.find("div", {"id": "main_maplayout"})
    buttons = div.findAll("button")
    result = {}
    for button in buttons:
        city_name = button.find("span", {"class": "name"}).text
        city_num = button.find("span", {"class": "num"}).text
        city_before = button.find("span", {"class": "before"}).text
        result[button["data-city"]] = [city_name, city_num, city_before]


    return jsonify(result)

@app.route('/liveNumber')
def liveNumber():
    res = requests.get('http://ncov.mohw.go.kr/en/')
    soup = BeautifulSoup(res.text, 'html.parser')
    div = soup.find('div', {"class": "mps_list"})
    spans = div.findAll('span')
    result = {}


    confirmed_cases = spans[1].text
    confirmed_cases_change = spans[2].text
    released_isolation = spans[4].text
    released_isolation_change = spans[5].text
    isolated = spans[7].text
    isolated_change = spans[8].text
    deceased_cases = spans[10].text
    deceased_change = spans[11].text

    result['confirmed'] = [confirmed_cases, confirmed_cases_change]
    result['released'] = [released_isolation, released_isolation_change]
    result['isolated'] = [isolated, isolated_change]
    result['deceased'] = [deceased_cases, deceased_change]
    print(result)

    return jsonify(result)

app.run()