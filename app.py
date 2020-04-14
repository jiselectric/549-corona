from flask import Flask, render_template, jsonify, request, url_for
# from urllib.request import urlretrieve
import os
import requests
import pymysql
import time
import datetime
from codecs import open
from apscheduler.schedulers.background import BackgroundScheduler
from bs4 import BeautifulSoup

app = Flask(__name__)
conn = pymysql.connect(host='localhost', user='root', password='123456789', db='corona')

@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

@app.route('/getSVG')
def getSVG():
    f = open('static/map_main_new.tag', 'r', encoding='utf8')
    svgHTML = " ".join(f.readlines())
    f.close()
    return svgHTML

@app.route('/getLiveNumber')
def getLiveNumber():
    date = request.args.get('date')
    now = datetime.datetime.strptime(date, '%Y-%m-%d')
    yesterday = str(now - datetime.timedelta(days=1))[:10]
    past = str(now - datetime.timedelta(days=2))[:10]
    result = {}

    curs = conn.cursor(pymysql.cursors.DictCursor)
    sql = "SELECT * FROM status WHERE REGIST_DTM=%s"
    curs.execute(sql, yesterday)
    result['status'] = curs.fetchall()

    sql = "SELECT y.LOC_NAME, y.LOC_NUM, y.CONFIRM, p.CONFIRM AS `BEFORE` FROM location y LEFT JOIN location p ON y.LOC_NUM = p.LOC_NUM AND p.REGIST_DTM=DATE_SUB(y.REGIST_DTM, INTERVAL 1 DAY) WHERE y.REGIST_DTM=%s"
    curs.execute(sql, yesterday)
    result['location'] = curs.fetchall()

    return jsonify(result)



def downloadSVG():
    res = requests.get('http://ncov.mohw.go.kr/static/css/chart_kr.css')
    res.encoding = None
    f = open('static/svg.css', 'w', encoding='utf8')
    f.write(res.text.split('\r\n\r\n')[16].replace('.regional_patient_status_A .rpsa_map .rpsam_graph', '.map-wrapper'))
    f.close()

    buttons = ''
    for i in range(1, 19):
        buttons += '<button type="button" data-city="map_city{}"><span class ="name"></span><span class ="num"></span><span class ="before"></span></button>'.format(i)

    res = requests.get('http://ncov.mohw.go.kr/static/image/map/map_main_new.svg')
    soup = BeautifulSoup(res.text, 'html.parser')
    svg = soup.find('svg')
    paths = svg.find_all('path')
    for path in paths:
        path['fill'] = '#FFFFFF'
    polygons = svg.find_all('polygon')
    for polygon in polygons:
        polygon['fill'] = '#FFFFFF'
    f = open('static/map_main_new.tag', 'w', encoding='utf8')
    f.write(buttons)
    f.write(str(svg))
    f.close()


def crawlLocationConfirm():
    res = requests.get('http://ncov.mohw.go.kr/')
    soup = BeautifulSoup(res.text, 'html.parser')
    curs = conn.cursor()
    buttons = soup.find('div', {'id': 'main_maplayout'}).find_all('button')
    for button in buttons:
        spans = button.find_all('span')
        LOC_NUM = button['data-city'].replace('map_city', '')
        LOC_NAME = spans[0].text
        CONFIRM = spans[1].text.replace(',', '')
        print(LOC_NUM, LOC_NAME, CONFIRM)
        sql = "INSERT INTO location(LOC_NUM, LOC_NAME, CONFIRM, REGIST_DTM) VALUES (%s, %s, %s, DATE_SUB(CURDATE(), INTERVAL 1 DAY))"
        curs.execute(sql, (LOC_NUM, LOC_NAME, CONFIRM))

    lis = soup.find('ul', {'class': 'liveNum'}).find_all('li')
    for STTUS_NUM, li in enumerate(lis[1:]):
        STTUS_NAME = li.find('strong').contents[0]
        NUM = li.find('span', {'class':'num'}).text.replace(',', '')
        print(STTUS_NUM, STTUS_NAME, NUM)
        sql = 'INSERT INTO status(STTUS_NUM, STTUS_NAME, NUM, REGIST_DTM) VALUES (%s, %s, %s, DATE_SUB(CURDATE(), INTERVAL 1 DAY))'
        curs.execute(sql, (STTUS_NUM, STTUS_NAME, NUM))
    conn.commit()

@app.context_processor
def override_url_for():
    return dict(url_for=dated_url_for)

def dated_url_for(endpoint, **values):
    if endpoint == 'static':
        if values['filename'].split('.')[-1] == 'css':
            values['version'] = datetime.datetime.now().strftime("%y%m%d%H%M%S")
    return url_for(endpoint, **values)

if __name__ == "__main__":
    if 'map_main_new.tag' not in os.listdir('static'):
        downloadSVG()
        print('SVG Downloaded')
    crawlLocationConfirm()
    scheduler = BackgroundScheduler()
    scheduler.add_job(func=crawlLocationConfirm, trigger='interval', hours=24,
                      start_date='{} 20:48:00'.format(str(datetime.datetime.now() + datetime.timedelta(days=1))[:10]),
                      id='jiselectric_location')
    scheduler.start()
    print('Scheduler jiselectic-location Registered!')

    try:
        app.run()
    except:
        scheduler.remove_job('jiselectric_location')
        scheduler.shutdown()
        print('Scheduler jiselectric_location removed')

