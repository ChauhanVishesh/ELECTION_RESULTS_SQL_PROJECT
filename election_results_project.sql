/* ELECTION RESULTS PROJECTS */

/* Creating states table */

CREATE TABLE states
(
state_id VARCHAR(10) PRIMARY KEY,
state VARCHAR(100)
);


/* Creating constituency_wise_results table */


CREATE TABLE constituency_wise_results
(
serial_no INT,
parliament_constituency	VARCHAR(50),
constituency_name VARCHAR(50),
winning_candidate VARCHAR(100),
total_votes INT,
margin INT,
constituency_id VARCHAR(10) PRIMARY KEY,	
party_id INT,
CONSTRAINT fk_cw_results_pw_results FOREIGN KEY (party_id)
REFERENCES party_wise_results(party_id)
);


/* Creating constituency_wise_details table */

CREATE TABLE constituency_wise_details
(
serial_no INT,
candidate VARCHAR(100),
party VARCHAR(100),
evm_votes INT,
postal_votes INT,
total_votes INT,
percent_of_votes FLOAT,
constituency_id VARCHAR(10),
CONSTRAINT fk_details_results FOREIGN KEY (constituency_id) REFERENCES constituency_wise_results(constituency_id)
);


/* Creating party_wise_results table */

CREATE TABLE party_wise_results
(
party VARCHAR(100),
won INT,
party_id INT PRIMARY KEY
);


/* Creating state_wise_results table */

CREATE TABLE state_wise_results
(
constituency VARCHAR(50),
constituency_no INT,
parliament_constituency VARCHAR(50),
leading_candidate VARCHAR(100),
trailing_candidate VARCHAR(100),
margin INT,
status VARCHAR(50),
state_id VARCHAR(10),
state VARCHAR(50),
CONSTRAINT fk_sw_results_states FOREIGN KEY (state_id)
REFERENCES states(state_id)
);

/* DATASETS */
SELECT * FROM constituency_wise_details;
SELECT * FROM constituency_wise_results;
SELECT * FROM party_wise_results;
SELECT * FROM state_wise_results;
SELECT * FROM states;


/* 1. TOTAL NUMBER OF SEATS */

SELECT DISTINCT COUNT(parliament_constituency)
AS total_seats
FROM constituency_wise_results;


/* TOTAL NUMBER OF SEATS IN EACH STATE */

SELECT s.state AS state_name,
COUNT(cr.parliament_constituency) AS total_seats
FROM constituency_wise_results cr
JOIN state_wise_results sr
ON cr.parliament_constituency =sr.parliament_constituency
JOIN states s ON sr.state_id = s.state_id
GROUP BY s.state;


/* SEATS WON BY NDA */

SELECT 
SUM(CASE 
    WHEN party IN (
'Bharatiya Janata Party - BJP', 
'Telugu Desam - TDP', 
'Janata Dal  (United) - JD(U)',
'Shiv Sena - SHS', 
'AJSU Party - AJSUP', 
'Apna Dal (Soneylal) - ADAL', 
'Asom Gana Parishad - AGP',
'Hindustani Awam Morcha (Secular) - HAMS', 
'Janasena Party - JnP', 
'Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV', 
'Nationalist Congress Party - NCP',
'Rashtriya Lok Dal - RLD', 
'Sikkim Krantikari Morcha - SKM'
 ) THEN Won
ELSE 0 
END) AS NDA_Total_Seats_Won
FROM 
party_wise_results;



/* SEATS WON BY EACH NDA PARTY */


SELECT 
    party as Party_Name,
    won as Seats_Won
FROM 
    party_wise_results
WHERE 
    party IN (
        'Bharatiya Janata Party - BJP', 
        'Telugu Desam - TDP', 
		'Janata Dal  (United) - JD(U)',
        'Shiv Sena - SHS', 
        'AJSU Party - AJSUP', 
        'Apna Dal (Soneylal) - ADAL', 
        'Asom Gana Parishad - AGP',
        'Hindustani Awam Morcha (Secular) - HAMS', 
        'Janasena Party - JnP', 
		'Janata Dal  (Secular) - JD(S)',
        'Lok Janshakti Party(Ram Vilas) - LJPRV', 
        'Nationalist Congress Party - NCP',
        'Rashtriya Lok Dal - RLD', 
        'Sikkim Krantikari Morcha - SKM'
    )
ORDER BY Seats_Won DESC;



/* Total Seats Won by I.N.D.I.A. Alliance */

SELECT 
SUM(CASE 
WHEN party IN (
'Indian National Congress - INC',
'Aam Aadmi Party - AAAP',
'All India Trinamool Congress - AITC',
'Bharat Adivasi Party - BHRTADVSIP',
'Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI',
'Dravida Munnetra Kazhagam - DMK',
'Indian Union Muslim League - IUML',
'Nat`Jammu & Kashmir National Conference - JKN',
'Jharkhand Mukti Morcha - JMM',
'Jammu & Kashmir National Conference - JKN',
'Kerala Congress - KEC',
'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD',
'Rashtriya Loktantrik Party - RLTP',
'Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP',
'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK'
) THEN won
ELSE 0 
END) AS INDIA_Total_Seats_Won
FROM 
party_wise_results;



/* Seats Won by I.N.D.I.A. Allianz Parties */

SELECT 
party as Party_Name,
won as Seats_Won
FROM 
party_wise_results
WHERE 
party IN (
'Indian National Congress - INC',
'Aam Aadmi Party - AAAP',
'All India Trinamool Congress - AITC',
'Bharat Adivasi Party - BHRTADVSIP',
'Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI',
'Dravida Munnetra Kazhagam - DMK',
'Indian Union Muslim League - IUML',
'Nat`Jammu & Kashmir National Conference - JKN',
'Jharkhand Mukti Morcha - JMM',
'Jammu & Kashmir National Conference - JKN',
'Kerala Congress - KEC',
'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD',
'Rashtriya Loktantrik Party - RLTP',
'Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP',
'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK'
)
ORDER BY Seats_Won DESC;


/* Add new column field in table partywise_results to get the Party Allianz as NDA, I.N.D.I.A and OTHER */


ALTER TABLE party_wise_results
ADD party_alliance VARCHAR(50);

/* I.N.D.I.A Allianz */

UPDATE party_wise_results
SET party_alliance = 'I.N.D.I.A'
WHERE party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',	
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
);

/* NDA Allianz */

UPDATE party_wise_results
SET party_alliance = 'NDA'
WHERE party IN (
    'Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM'
);
 /* OTHER */
 
UPDATE party_wise_results
SET party_alliance = 'OTHER'
WHERE party_alliance IS NULL;


/* Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states? */


SELECT 
p.party_alliance,
COUNT(cr.Constituency_ID) AS Seats_Won
FROM constituency_wise_results cr JOIN 
party_wise_results p ON cr.Party_ID = p.Party_ID
WHERE p.party_alliance IN ('NDA', 'I.N.D.I.A', 'OTHER')
GROUP BY p.party_alliance
ORDER BY Seats_Won DESC;



/* Winning candidate's name, their party name, total votes
and the margin of victory for a specific state and constituency? */

SELECT cr.Winning_Candidate, p.Party, p.party_alliance, cr.Total_Votes, cr.Margin, cr.Constituency_Name, s.State
FROM constituency_wise_results cr
JOIN party_wise_results p ON cr.Party_ID = p.Party_ID
JOIN state_wise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE s.State = 'Uttar Pradesh' AND cr.Constituency_Name = 'VARANASI';




/* Which parties won the most seats in s State, and how many seats did each party win? */

SELECT 
p.Party,
COUNT(cr.Constituency_ID) AS Seats_Won
FROM 
constituency_wise_results cr
JOIN party_wise_results p ON cr.Party_ID = p.Party_ID
JOIN state_wise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE s.state = 'Uttar Pradesh'
GROUP BY p.Party ORDER BY 
Seats_Won DESC;


/* Which candidate won and which candidate was the runner-up 
in each constituency of State for the 2024 elections? */

WITH RankedCandidates AS (
SELECT 
cd.Constituency_ID,
cd.Candidate,
cd.Party,
cd.EVM_Votes,
cd.Postal_Votes,
cd.EVM_Votes + cd.Postal_Votes AS Total_Votes,
ROW_NUMBER() OVER (PARTITION BY cd.Constituency_ID ORDER BY cd.EVM_Votes + cd.Postal_Votes DESC) AS VoteRank
FROM constituency_wise_details cd
JOIN constituency_wise_results cr ON cd.Constituency_ID = cr.Constituency_ID
JOIN state_wise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE s.State = 'Maharashtra')
SELECT cr.Constituency_Name,
MAX(CASE WHEN rc.VoteRank = 1 THEN rc.Candidate END) AS Winning_Candidate,
MAX(CASE WHEN rc.VoteRank = 2 THEN rc.Candidate END) AS Runnerup_Candidate
FROM RankedCandidates rc
JOIN constituency_wise_results cr ON rc.Constituency_ID = cr.Constituency_ID
GROUP BY cr.Constituency_Name
ORDER BY cr.Constituency_Name;


/* For the state of Maharashtra, what are the total number of seats,
total number of candidates, total number of parties,
total votes (including EVM and postal), and the breakdown of EVM and postal votes? */



SELECT 
COUNT(DISTINCT cr.Constituency_ID) AS Total_Seats,
COUNT(DISTINCT cd.Candidate) AS Total_Candidates,
COUNT(DISTINCT p.Party) AS Total_Parties,
SUM(cd.EVM_Votes + cd.Postal_Votes) AS Total_Votes,
SUM(cd.EVM_Votes) AS Total_EVM_Votes,
SUM(cd.Postal_Votes) AS Total_Postal_Votes
FROM constituency_wise_results cr
JOIN constituency_wise_details cd ON cr.Constituency_ID = cd.Constituency_ID
JOIN state_wise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
JOIN party_wise_results p ON cr.Party_ID = p.Party_ID
WHERE s.State = 'Maharashtra';












