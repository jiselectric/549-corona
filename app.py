from flask import Flask, render_template, jsonify, request, url_for, session, redirect
# from urllib.request import urlretrieve
import os
import requests
import pymysql
import random
import time
import datetime
from codecs import open
from apscheduler.schedulers.background import BackgroundScheduler
from bs4 import BeautifulSoup

app = Flask(__name__)
app.secret_key = 'jiselectric'
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
    print(date)
    now = datetime.datetime.strptime(date, '%Y-%m-%d')
    #print(now)
    yesterday = str(now - datetime.timedelta(days=1))[:10]
    past = str(now - datetime.timedelta(days=2))[:10]
    result = {}

    curs = conn.cursor(pymysql.cursors.DictCursor)
    sql = "SELECT * FROM status WHERE REGIST_DTM=%s"
    curs.execute(sql, yesterday)
    result['status'] = curs.fetchall()
    #print(result)

    sql = "SELECT y.LOC_NAME, y.LOC_NUM, y.CONFIRM, p.CONFIRM AS `BEFORE` FROM location y LEFT JOIN location p ON y.LOC_NUM = p.LOC_NUM AND p.REGIST_DTM=DATE_SUB(y.REGIST_DTM, INTERVAL 1 DAY) WHERE y.REGIST_DTM=%s"
    curs.execute(sql, yesterday)
    result['location'] = curs.fetchall()
    #print(result)
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
        #print(LOC_NUM, LOC_NAME, CONFIRM)
        sql = 'SELECT * FROM location WHERE REGIST_DTM = DATE_SUB(CURDATE(), INTERVAL 1 DAY) AND LOC_SN=%s'
        curs.execute(sql, (LOC_NUM))
        result = curs.fetchall()
        if len(result) > 0:
            sql = 'UPDATE location SET CONFIRM=%s WHERE LOC_NUM=%s AND REGIST_DTM = DATE_SUB(CURDATE(), INTERVAL 1 DAY)'
            curs.execute(sql, (CONFIRM, LOC_NUM))
        sql = "INSERT INTO location(LOC_NUM, LOC_NAME, CONFIRM, REGIST_DTM) VALUES (%s, %s, %s, DATE_SUB(CURDATE(), INTERVAL 1 DAY))"
        curs.execute(sql, (LOC_NUM, LOC_NAME, CONFIRM))

    lis = soup.find('ul', {'class': 'liveNum'}).find_all('li')
    for STTUS_NUM, li in enumerate(lis[1:]):
        STTUS_NAME = li.find('strong').contents[0]
        NUM = li.find('span', {'class':'num'}).text.replace(',', '')
        #print(STTUS_NUM, STTUS_NAME, NUM)
        sql = 'INSERT INTO status(STTUS_NUM, STTUS_NAME, NUM, REGIST_DTM) VALUES (%s, %s, %s, DATE_SUB(CURDATE(), INTERVAL 1 DAY))'
        curs.execute(sql, (STTUS_NUM, STTUS_NAME, NUM))
    conn.commit()

def getTestingNumber():
    date = request.args.get('date')
    print(date)
    now = datetime.datetime.strptime(date, '%Y-%m-%d')
    yesterday = str(now - datetime.timedelta(days=1))[:10]
    result = {}

    curs = conn.cursor(pymysql.cursors.DictCursor)
    sql = 'SELECT * FROM testing WHERE REGIST_DTM=%s'
    curs.execute(sql, yesterday)
    result = curs.fetchall()

    print(result)
    return jsonify(result)

@app.route('/getTestingNumber')
def crawlTestingNumber():
    res = requests.get('http://ncov.mohw.go.kr/en/')
    soup = BeautifulSoup(res.text, 'html.parser')
    curs = conn.cursor()
    lis = soup.find('div', {'class':'misi_list'}).find_all('li')

    index = 0
    for li in lis:
        spans = li.find_all('span')
        TESTING_NAME = spans[0].text
        TESTING_NUM = index
        NUM = spans[1].text.replace(',', '')
        index = index + 1
        if index == 3: break
        sql = 'INSERT INTO testing(TESTING_NAME, TESTING_NUM, NUM, REGIST_DTM) VALUES(%s, %s, %s, DATE_SUB(CURDATE(), INTERVAL 1 DAY))'
        curs.execute(sql, (TESTING_NAME, TESTING_NUM, NUM))
    conn.commit()

@app.route('/assessment', methods=['GET', 'POST'])
def assessment():
    if request.method == 'GET':
        return render_template('terms.html')
    else:
        return render_template('user.html')

@app.route('/user', methods=['GET', 'POST'])
def user():
    lastName = request.form.get('lastName')
    firstName = request.form.get('firstName')
    phone = request.form.get('phone')
    affiliation = request.form.get('affiliation')
    area = request.form.get('area')
    unit = request.form.get('unit')

    curs = conn.cursor()

    if request.method == 'POST':
        u_sn = random.randint(1, 1000)
        sql = "SELECT * FROM users WHERE U_SN=%s"
        curs.execute(sql, u_sn)
        result = curs.fetchall()

        while len(result) > 0:
            u_sn = random.randint(1, 1000)
            sql = 'SELECT * FROM users WHERE U_SN=%s'
            curs.execute(sql, u_sn)
            result = curs.fetchall()

    session['u_sn'] = u_sn
    #print(session['u_sn'])
    sql = 'INSERT INTO users (U_SN,LAST_NAME, FIRST_NAME, AREA, UNIT, AFFIL, PHONE_NUM, REGIST_DTM) VALUES (%s, %s, %s, %s, %s, %s, %s, NOW())'
    curs.execute(sql, (u_sn, lastName, firstName, area, unit, affiliation, phone))
    conn.commit()

    return redirect('/startAssessment')

@app.route('/startAssessment', methods=['GET', 'POST'])
def startAssessment():
    u_sn = session['u_sn']
    answer = request.args.get('answer')
    if 'u_sn' not in session:
        return redirect('/assessment')
    else:
        if answer is None:
            curs = conn.cursor(pymysql.cursors.DictCursor)
            sql = "SELECT * FROM question WHERE Q_SN=%s"
            curs.execute(sql, (1))
            question = curs.fetchone()

            return render_template('assessment.html', q_sn=1, q_text=question['Q_TEXT'], q_num=1)

        else:
            q_sn = request.args.get('q_sn')
            q_sn = int(q_sn)
            curs = conn.cursor(pymysql.cursors.DictCursor)
            sql = "SELECT * FROM answer WHERE U_SN=%s AND Q_SN=%s"
            curs.execute(sql, (u_sn, q_sn))
            result = curs.fetchall()

            if len(result) > 0:
                sql = 'UPDATE answer SET A_ANS=%s WHERE U_SN=%s AND Q_SN=%s'
                curs.execute(sql, (answer, u_sn, q_sn))
            else:
                sql = "INSERT INTO answer(U_SN, Q_SN, A_ANS) VALUES(%s, %s, %s)"
                curs.execute(sql, (u_sn, q_sn, answer))
            conn.commit()

            answer = int(answer)

            if q_sn % 2 != 0 and answer == 1:
                next_q = q_sn + 1
                sql = "SELECT * FROM question WHERE Q_SN = %s"
                curs.execute(sql, (next_q))
                question = curs.fetchone()
            elif q_sn % 2 != 0 and answer == 0:
                next_q = q_sn + 2
                sql = "SELECT * FROM question WHERE Q_SN=%s"
                curs.execute(sql, (next_q))
                question = curs.fetchone()
            elif q_sn % 2 == 0:
                next_q = q_sn + 1
                sql = "SELECT * FROM question WHERE Q_SN=%s"
                curs.execute(sql, (next_q))
                question = curs.fetchone()

            if question is None:
                return redirect('assessmentFinish')
            else:
                return render_template('assessment.html', q_sn=next_q, q_text=question['Q_TEXT'], q_num=question['Q_NUM'])

@app.route('/assessmentFinish', methods=['POST', 'GET'])
def assessmentFinish():
    if 'u_sn' not in session:
        return redirect('/assessment')
    else:
        u_sn = session["u_sn"]
        print(u_sn)
        del session["u_sn"]
        print(u_sn)
        return render_template('assessmentFinish.html', u_sn=u_sn)

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
    scheduler.add_job(func=crawlTestingNumber, trigger='interval', hours=24,
                      start_date='{} 20:48:00'.format(str(datetime.datetime.now() + datetime.timedelta(days=1))[:10]),
                      id='jiselectric_testing')
    scheduler.start()
    print('Scheduler jiselectic-location Registered!')

    try:
        app.run()
    except:
        scheduler.remove_job('jiselectric_location')
        scheduler.shutdown()
        print('Scheduler jiselectric_location removed')

