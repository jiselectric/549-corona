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
from pprint import pprint
from googletrans import Translator

app = Flask(__name__)
app.secret_key = 'jiselectric'
conn = pymysql.connect(host='localhost', user='root', password='123456789', db='corona')
PASSWORD = '549agent'

@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

@app.route('/login')
def login():
    pw = request.args.get('pw')
    print(pw)
    if pw == PASSWORD:
        return jsonify({'response': 1})
    else:
        return jsonify({'response': 0})

@app.route('/getSVG')
def getSVG():
    f = open('static/map_main_new.tag', 'r', encoding='utf8')
    svgHTML = " ".join(f.readlines())
    f.close()
    return svgHTML

@app.route('/getLiveNumber')
def getLiveNumber():
    date = request.args.get('date')
    #print(date)
    now = datetime.datetime.strptime(date, '%Y-%m-%d')
    #print(now)
    yesterday = str(now - datetime.timedelta(days=1))[:10]
    past = str(now - datetime.timedelta(days=2))[:10]
    result = {}

    curs = conn.cursor(pymysql.cursors.DictCursor)
    sql = "SELECT * FROM status WHERE REGIST_DTM=%s"
    curs.execute(sql, yesterday)
    result['status'] = curs.fetchall()
    #pprint(result)

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
    tr = Translator()
    res = requests.get('http://ncov.mohw.go.kr/')
    soup = BeautifulSoup(res.text, 'html.parser')
    curs = conn.cursor()
    buttons = soup.find('div', {'id': 'main_maplayout'}).find_all('button')
    for button in buttons:
        spans = button.find_all('span')
        LOC_NUM = button['data-city'].replace('map_city', '')

        trans = tr.translate(spans[0].text, dest='en')
        LOC_NAME = trans.text
        if LOC_NAME[0].islower() or " " in LOC_NAME:
            LOC_NAME = trans.extra_data['translation'][-1][-1]
            LOC_NAME = LOC_NAME[0].upper() + LOC_NAME[1:]
        CONFIRM = spans[1].text.replace(',', '')
        #print(LOC_NUM, LOC_NAME, CONFIRM)
        sql = 'SELECT * FROM location WHERE REGIST_DTM = DATE_SUB(CURDATE(), INTERVAL 1 DAY) AND LOC_NUM=%s'
        curs.execute(sql, (LOC_NUM))
        result = curs.fetchall()
        #print(result)
        if len(result) > 0:
            sql = 'UPDATE location SET CONFIRM=%s WHERE LOC_NUM=%s AND REGIST_DTM = DATE_SUB(CURDATE(), INTERVAL 1 DAY)'
            curs.execute(sql, (CONFIRM, LOC_NUM))
        else:
            sql = "INSERT INTO location(LOC_NUM, LOC_NAME, CONFIRM, REGIST_DTM) VALUES (%s, %s, %s, DATE_SUB(CURDATE(), INTERVAL 1 DAY))"
            curs.execute(sql, (LOC_NUM, LOC_NAME, CONFIRM))

    # status update으로 바꾸기
    lis = soup.find('ul', {'class': 'liveNum'}).find_all('li')
    for STTUS_NUM, li in enumerate(lis[1:]):
        STTUS_NAME = li.find('strong').contents[0]
        NUM = li.find('span', {'class':'num'}).text.replace(',', '')
        #print(STTUS_NUM, STTUS_NAME, NUM)
        sql = 'INSERT INTO status(STTUS_NUM, STTUS_NAME, NUM, REGIST_DTM) VALUES (%s, %s, %s, DATE_SUB(CURDATE(), INTERVAL 1 DAY))'
        curs.execute(sql, (STTUS_NUM, STTUS_NAME, NUM))
    conn.commit()

#########################################################################################
@app.route('/crawlUS')
def crawlNumberUS():
    res = requests.get('https://www.worldometers.info/coronavirus/country/us/')
    soup = BeautifulSoup(res.text, 'html.parser')
    curs = conn.cursor()

    divs = soup.find('div', {'class': 'content-inner'}).find_all('h1')
    spans = soup.find('div', {'class': 'content-inner'}).find_all('span')
#########################################################################################

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

    answers = request.args.getlist('answer')
    if 'u_sn' not in session:
        return redirect('/assessment')
    else:
        u_sn = session['u_sn']
        if len(answers) == 0:
            curs = conn.cursor(pymysql.cursors.DictCursor)
            sql = "SELECT * FROM question WHERE Q_SN=%s"
            curs.execute(sql, (1))
            question = curs.fetchone()

            sql = "SELECT * FROM example WHERE Q_SN=%s"
            curs.execute(sql, (1))
            examples = curs.fetchall()

            return render_template('assessment.html', q_sn=1, q_text=question['Q_TEXT'], q_type=question['Q_TYPE'], q_num=1, examples=examples)

        else:
            q_sn = request.args.get('q_sn')
            q_sn = int(q_sn)
            curs = conn.cursor(pymysql.cursors.DictCursor)
            sql = "SELECT * FROM answer WHERE U_SN=%s AND Q_SN=%s"
            curs.execute(sql, (u_sn, q_sn))
            result = curs.fetchall()

            if len(result) > 0:
                sql = 'DELETE FROM answer WHERE U_SN=%s AND Q_SN=%s'
                curs.execute(sql, (u_sn, q_sn))

            for answer in answers:
                sql = "INSERT INTO answer(U_SN, Q_SN, A_ANS) VALUES(%s, %s, %s)"
                curs.execute(sql, (u_sn, q_sn, answer))
            conn.commit()

            answer = answers[0]
            sql = "SELECT * FROM question WHERE Q_SN=%s"
            curs.execute(sql, (q_sn))
            question = curs.fetchone()

            q_type = question['Q_TYPE']
            if q_type == 2:
                next_q = q_sn + 1
            else:
                sql = "SELECT * FROM example WHERE Q_SN=%s AND A_ANS=%s"
                curs.execute(sql, (q_sn, answer))
                ex = curs.fetchone()
                next_q = ex['NEXT_Q_SN']


            sql = "SELECT * FROM question WHERE Q_SN=%s"
            curs.execute(sql, (next_q))
            question = curs.fetchone()

            sql = "SELECT * FROM example WHERE Q_SN=%s"
            curs.execute(sql, (next_q))
            examples = curs.fetchall()

            if question is None:
                return redirect('assessmentFinish')
            else:
                return render_template('assessment.html', q_sn=next_q, q_text=question['Q_TEXT'], q_type=question['Q_TYPE'], q_num=question['Q_NUM'], examples=examples)

@app.route('/assessmentFinish', methods=['POST', 'GET'])
def assessmentFinish():
    if 'u_sn' not in session:
        return redirect('/assessment')
    else:
        u_sn = session["u_sn"]
        #print(u_sn)
        del session["u_sn"]
        #print(u_sn)
        return render_template('assessmentFinish.html', u_sn=u_sn)

@app.route('/showAssessment', methods=['POST', 'GET'])
def showAssessment():
    return render_template('showAssessment.html')

@app.route('/loadAssessment')
def loadAssessment():
    u_sn = request.args.get('u_sn')

    curs = conn.cursor(pymysql.cursors.DictCursor)
    sql = "SELECT a.Q_SN, a.A_ANS, e.EX_TEXT, q.Q_TEXT, q.Q_TYPE, q.Q_NUM FROM answer a LEFT JOIN example e ON a.A_ANS = e.A_ANS AND a.Q_SN = e.Q_SN LEFT JOIN question q ON a.Q_SN=q.Q_SN WHERE U_SN=%s ORDER BY Q_SN"
    curs.execute(sql, (u_sn))
    result = curs.fetchall()
    #pprint(result)
    new_result = {}
    for r in result:
        q_sn = r['Q_SN']
        a_ans = r['A_ANS']
        ex_text = r['EX_TEXT']
        q_text = r['Q_TEXT']
        q_type = r['Q_TYPE']
        q_num = r['Q_NUM']
        if q_sn not in new_result:
            answer = {}
            answer['q_text'] = q_text
            answer['q_type'] = q_type
            answer['q_num'] = q_num
            if q_type != 2:
                answer['answers'] = ex_text
            else:
                answer['answers'] = a_ans
            new_result[q_sn] = answer
        else:
            new_result[q_sn]['answers'] += ", " + (ex_text if q_type != 2 else a_ans)

        #pprint(new_result)
    sql = "SELECT * FROM users WHERE U_SN=%s"
    curs.execute(sql, (u_sn))
    users = curs.fetchone()

    result = {"assessments": new_result, "info": users}
    #pprint(result)
    return jsonify(result)

@app.route('/addHotspot')
def addHotspot():
    curs = conn.cursor()
    curs.execute("SELECT * FROM affiliation")
    aff_list = curs.fetchall()

    return render_template('addHotspot.html', aff_list=aff_list)

@app.route('/startHotspot', methods=['GET', 'POST'])
def startHotspot():
    caseNum = request.args.get('caseNum')
    sex = request.args.get('sex')
    age = request.args.get('age')
    affiliation = request.args.get('affiliation')
    area = request.args.get('area')

    curs = conn.cursor()
    sql = "INSERT INTO positive(P_NUM, P_SEX, P_AGE, P_AFF, P_AREA) VALUES(%s, %s, %s, %s, %s)"
    curs.execute(sql, (caseNum, sex, age, affiliation, area))
    iid = curs.lastrowid
    conn.commit()
    #print(iid)
    return jsonify({"P_SN": iid})

@app.route('/saveHotspot', methods=['POST'])
def saveHotspot():
    curs = conn.cursor()
    p_sn = request.form.get('p_sn')
    time = request.form.getlist('time[]')
    desc = request.form.getlist('desc[]')

    for t, d in zip(time, desc):
        sql = "INSERT INTO hotspots VALUES (%s, %s, %s)"
        curs.execute(sql, (p_sn, t, d))
    conn.commit()
    return redirect('/addHotspot')

@app.route('/hotspots')
def showHotspot():
    return render_template('hotspots.html')

@app.route('/getHotspot')
def getHotspot():
    curs = conn.cursor(pymysql.cursors.DictCursor)
    sql = "SELECT p.P_SN, p.P_NUM, p.P_AREA, p.P_AGE, DATE(H_TIME) AS H_DATE, TIME(H_TIME) AS H_TM, H_DESC, IF(P_SEX=0, 'Male', 'Female') AS P_SEX, (SELECT AFF_NM FROM affiliation WHERE AFF_SN=p.P_AFF) AS AFF_NM FROM hotspots h LEFT JOIN positive p ON h.P_SN = p.P_SN"
    curs.execute(sql)
    result = curs.fetchall()
    #pprint(result)

    new_result = {}

    for data in result:
        p_sn = data['P_SN']
        aff_nm = data['AFF_NM']
        h_date = data['H_DATE'].strftime("%Y-%m-%d")
        h_desc = data['H_DESC']
        h_tm = str(data['H_TM'])
        p_sex = data['P_SEX']
        p_age = data['P_AGE']
        p_num = data['P_NUM']
        p_area = data['P_AREA']

        if p_sn not in new_result:
            new_result[p_sn] = {"aff_nm": aff_nm, "p_sex": p_sex, "p_age":p_age, "dates": {}, "p_num": p_num, "p_area": p_area}
        dates = new_result[p_sn]["dates"]

        if h_date not in dates:
            dates[h_date] = {}

        times = dates[h_date]
        if h_tm not in times:
            times[h_tm] = h_desc
    #print(new_result)
    return jsonify(new_result)

@app.route('/editHotspot')
def editHotspot():
    curs = conn.cursor()
    sql = "SELECT P_NUM FROM positive"
    curs.execute(sql)
    num_list = curs.fetchall()
    print(len(num_list))
    #pprint(num_list)
    #pprint(num_list.replace(",", ""))

    return render_template('editHotspot.html', num_list=num_list)

@app.route('/deleteHotspot')
def deleteHotspot():
    caseNum = request.args.get('number')


    curs = conn.cursor()
    sql = "SELECT P_SN FROM positive WHERE P_NUM=%s"
    curs.execute(sql, (caseNum))
    p_sn = curs.fetchone()

    sql = "DELETE FROM hotspots WHERE P_SN=%s"
    curs.execute(sql, p_sn)

    sql = "DELETE FROM positive WHERE P_NUM=%s"
    curs.execute(sql, caseNum)
    conn.commit()

    return redirect('/editHotspot')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/admin')
def admin():
    return render_template('admin.html')

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

