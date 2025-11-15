show databases;

use India_Election_Results;

select * from constituencywise_results;

select * from constituencywise_details;

select * from partywise_results;

select * from statewise_results;

select * from states;


-- 1)Find the Total Number of Seats Across India

select 
      COUNT(Parliament_Constituency) as Total_Seats
	  from constituencywise_results;


-- 2)Find the Total Number of Seats Available for Elections in Each State

select
	  S.State , COUNT(CR.Constituency_Name) AS Total_Seats_Available
	  from constituencywise_results as CR 
	  INNER JOIN statewise_results as SR  ON
	  CR.Parliament_Constituency = SR.Parliament_Constituency
	  INNER JOIN states as S  ON
	  SR.State_ID = S.State_ID
	  group by S.State
	  ORDER BY S.State;


--  3)Add a New Column to Identify Each Party’s Alliance (NDA, I.N.D.I.A, OTHER) in table partywise_results

SELECT * from partywise_results;

ALTER TABLE partywise_results
ADD Party_Alliance varchar(100);

SET SQL_SAFE_UPDATES = 0;

INDIA ALLIANCE
--------------

UPDATE partywise_results
SET party_Alliance = 'I.N.D.I.A'
WHERE  Party IN 
( 
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

NDA ALLIANCE 
------------

UPDATE partywise_results
SET party_Alliance = 'N.D.A'
WHERE  Party IN 
(
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

OTHERS
------

UPDATE partywise_results
SET party_Alliance = 'OTHERS'
WHERE  Party_Alliance IS NULL; 


-- 4)Find the Total Seats Won by Each Party Alliance Across India

select 
     Party_Alliance , SUM(Won) as Total_Seats
     from partywise_results
	 group by Party_Alliance
     order by Total_Seats desc;


-- 5)Find the Total Seats Won by Each Party Alliance in Every State

select 
      S.State as State_Name, 
      SUM(CASE WHEN PR.Party_Alliance = 'N.D.A' then 1 ELSE 0 END) AS NDA_Seats_Won,
      SUM(CASE WHEN PR.Party_Alliance = 'I.N.D.I.A' then 1 ELSE 0 END) AS INDIA_Seats_Won,
      SUM(CASE WHEN PR.Party_Alliance = 'OTHER' then 1 ELSE 0 END) AS OTHER_Seats_Won
      from partywise_results PR 
	  INNER JOIN constituencywise_results CR 
      ON PR.Party_ID = CR.Party_ID
      INNER JOIN statewise_results  as SR
      ON CR.Parliament_Constituency  = SR.Parliament_Constituency
      INNER join  States as S 
      on SR.State_ID = S.State_ID
	  group by S.State
      order by S.State desc ;


-- 6)Find the Total Seats Won by Each Party Within Their Alliance

select 
      Party_Alliance , Party , sum(Won) as Total_Seats_Won
      from partywise_results
      group by Party, Party_Alliance
      order by Party, Total_Seats_Won desc;


-- 7)Find the candidate who received the highest total votes in a selected constituency

select 
      CD.Candidate, CD.Party, CD.Total_votes
      from constituencywise_details CD
	  where Constituency_ID = 'S0119'
	  AND Total_Votes = ( 
                         select max(Total_Votes)
                         from constituencywise_details
				         where Constituency_ID = 'S0119'
						);  
                   
                   
-- 8)Using a CTE, find the top 2 parties with the highest total votes in each state

with PARTYVOTES AS 
( 
 select
       S.State, PR.Party, SUM(CR.Total_Votes) AS Highest_Votes ,
	   ROW_NUMBER() OVER ( PARTITION BY S.State  order by SUM(CR.Total_Votes) DESC ) AS RN
       FROM partywise_results PR
       INNER JOIN constituencywise_results CR 
       ON PR.Party_ID = CR.Party_ID 
       INNER JOIN statewise_results SR 
       ON  CR.Parliament_Constituency = SR.Parliament_Constituency
       INNER JOIN States S
       ON SR.State_ID = S.State_ID 
       group by S.State, PR.Party
 )
 
 SELECT 
	   State, Party,  Highest_Votes
       from PARTYVOTES
       where RN <= 2 
       order by State , Highest_Votes DESC;
       
       
-- 9)Using a temporary table, find how many candidates contested from each party

CREATE TEMPORARY  TABLE PartyCandidateCount AS
SELECT 
      Party , count(*) as Total_Candidates
      from constituencywise_details
      group by Party;
      
select 
      Party, Total_Candidates
      from PartyCandidateCount
      order by Total_Candidates DESC;
  
  
  
-- 10)Get a Summary Report for  Telangana  — Total Seats, Total Candidates, Total Parties, Total Votes, EVM_Votes and Postal_Votes. 
select 
	  S.State,  CR.Constituency_Name,
	  COUNT(DISTINCT CD.Constituency_ID) as Total_Seats, 
	  COUNT(DISTINCT CD.Candidate) as Total_Candidates,
	  COUNT(DISTINCT CD.Party) as Total_Parties,
	  SUM(CD.Total_Votes) as Total_Votes,
	  SUM(CD.EVM_Votes) as Total_EVM_Votes,
	  SUM(CD.Postal_Votes) as Total_Postal_Votes 
	  from constituencywise_details CD 
	  INNER JOIN constituencywise_results CR
	  ON CD.Constituency_ID = CR.Constituency_ID
      INNER JOIN statewise_results SR
	  ON CR.Parliament_Constituency = SR.Parliament_Constituency
	  INNER JOIN states S 
	  ON SR.State_ID = S.State_ID
	  where S.State = 'Telangana' 
      group by  S.State, CR.Constituency_Name;
       
       
      