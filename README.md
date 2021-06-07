# 549-corona

![usfk](https://user-images.githubusercontent.com/35610628/120923767-330d2800-c70b-11eb-8aaf-b700077207ad.png)

### Description
  - URL: www.usfkcorona.com
  - a web-service designed to digitize the USFK 549th Hospital's COVID-19 Response 
  - the web-service was designed and deployed during my military service in 549th Hospital as the hospital's linguist and translator, later received the Army Commendation Medal for honorable service

### Objective
  - the website provides major features including real-time COVID-19 case updates in United States and Korea, self-assessment questionnaire utilized to assist the patient, hotspot tracker within the USFK garrisons / camps, and contact information of hospital and KCDA
  - hospital's COVID-19 Response team on average handled 2-300 incoming calls per day which had to be recorded on written documents. The digitized web-service provided quick and efficient documentation of patient records and signifcantly reduced call center's hold time

### Stacks
  - Python
  - Flask
  - HTML / CSS / JavaScript / jQuery
  - MySQL
  - AWS 

### Application Overview 

1. Main Page
<img width="1344" alt="스크린샷 2021-06-06 20 52 39" src="https://user-images.githubusercontent.com/35610628/120923372-28ea2a00-c709-11eb-8c10-b83e686bd559.png">

  - provides real-time COVID-19 cases in United States and South Korea and cases by city and province 
    - United States Cases: https://www.worldometers.info/coronavirus/
    - South Korea Cases: http://ncov.mohw.go.kr/
  - crawled cases collected by Python library Beautiful Soup stored in database on daily basis    
  - provides link to U.S. Government, KCDA, and USFK Websites


2. Self Assessment
<img width="1329" alt="스크린샷 2021-06-06 21 11 54" src="https://user-images.githubusercontent.com/35610628/120923892-ebd36700-c70b-11eb-8258-2f870c9fd065.png">

<img width="1310" alt="스크린샷 2021-06-06 21 27 08" src="https://user-images.githubusercontent.com/35610628/120924303-f5f66500-c70d-11eb-8fc1-2ebaa27ec941.png">

<img width="1342" alt="스크린샷 2021-06-06 21 14 52" src="https://user-images.githubusercontent.com/35610628/120923980-60a6a100-c70c-11eb-8591-7370629b7b70.png">

<img width="1295" alt="스크린샷 2021-06-06 21 16 36" src="https://user-images.githubusercontent.com/35610628/120924007-816ef680-c70c-11eb-9e2b-0c1767c9942b.png">

<img width="1306" alt="스크린샷 2021-06-06 21 17 28" src="https://user-images.githubusercontent.com/35610628/120924034-a82d2d00-c70c-11eb-9ec1-1bcfe3054c21.png">


  - Self Assessment provides a questionnaire regarding recent symptoms, travel history, and contact with the COVID-19 individuals
  - After finishing the assessment, randomly computed number is granted to the respondent
  - Without manually repetitively asking questions on line, the hospital's response team can easily access the necessary information with the provided number
  - The sensitive data are strictly accessbile by the individuals in hospital, and subject to automatic destruction after 7-days

3. Hotspot
<img width="1312" alt="스크린샷 2021-06-06 21 23 19" src="https://user-images.githubusercontent.com/35610628/120924197-6bae0100-c70d-11eb-88f4-898325180f9a.png">

<img width="1337" alt="스크린샷 2021-06-06 21 22 52" src="https://user-images.githubusercontent.com/35610628/120924184-5c2eb800-c70d-11eb-9571-ccaeb68ef244.png">

  - After hotspots are confirmed by the USFK's investigation, the COVID-19 response team can post detailed information on visited hotspots

4. Contact 
<img width="1312" alt="스크린샷 2021-06-06 21 25 28" src="https://user-images.githubusercontent.com/35610628/120924261-b9c30480-c70d-11eb-9cd2-53cf707625d7.png">

  - Contact informatino of 549th Hospital, and KDCA 
