INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Lawrence', 'Johns', 'lawrence.johns@gwu.edu', '(408) xxx-xxxx', 22);
INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Foster', 'Coleman', 'foster.coleman@gwu.edu', '(708) xxx-xxxx', 26);
INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Moses', 'Gilbert', 'moses.gilbert@gwu.edu', '(315) xxx-xxxx', 7);
INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Julius', 'Hendrix', 'julius.hendrix@gwu.edu', '(703) xxx-xxxx', 40);
INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Tanisha', 'Simon', 'tanisha.simon@gwu.edu', '(414) xxx-xxxx', 48);
INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Alex', 'Nelson', 'alex.nelson@gwu.edu', '(316) xxx-xxxx', 10);
INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Brianna', 'Dunlap', 'brianna.dunlap@gwu.edu', '(206) xxx-xxxx', 11);
INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Judith', 'Kirby', 'judith.kirby@gwu.edu', '(903) xxx-xxxx', 72);
INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Sheryl', 'Thomas', 'sheryl.thomas@gwu.edu', '(201) xxx-xxxx', 97);
INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('Ila', 'Mathis', 'ila.mathis@gwu.edu', '(201) xxx-xxxx', 39);

INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('IL', 'Addison', '191 Plinfate St', '60101', 'catenarian reticules uninsurability ', '35');
INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('WA', 'Spokane', '824 Potter Rd', '99210', 'enround dinked cheyney ', '100');
INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('TX', 'Dallas', '712 Burnet Dr', '75260', 'teacher jacana aurifex ', '76');
INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('IN', 'Gary', '368 Tomkins Blcd', '46401', 'Evnissyen portmoot Sanhita ', '47');
INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('IL', 'Alton', '40 Burnet Dr', '62002', 'invariant wincing superexcitement ', '53');
INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('TN', 'Memphis', '586 First St', '38101', 'deoxidant rhythmize heracleonite ', '77');
INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('OH', 'Hamilton', '400 Old Pinbrick Dr', '45012', 'hyoplastron yttric Umbro-latin ', '100');
INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('TX', 'Dallas', '400 Fairfield Rd', '75260', 'injuries chasmogamic Skagerrak ', '74');
INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('TN', 'Memphis', '602 Shalton Dr', '38101', 'tez dregginess antiscience ', '87');
INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('FL', 'Orlando', '833 Pleasant View Dr', '32802', 'Terebinthus partnering retable ', '45');


INSERT INTO tournament (name, start_time, stop_time, registration_fee) VALUES('Pandemic Ping Pong 2021', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '2' day, 100);
INSERT INTO tournament (name, start_time, stop_time, registration_fee) VALUES('GW Masters 2021', CURRENT_TIMESTAMP + INTERVAL '5' day, CURRENT_TIMESTAMP + INTERVAL '6' day, 200);


INSERT INTO tournament_venue(tournament_id, venue_id, start_time, stop_time) VALUES(1, 1, CURRENT_TIMESTAMP,  CURRENT_TIMESTAMP + INTERVAL '8' hour);
INSERT INTO tournament_venue(tournament_id, venue_id, start_time, stop_time) VALUES(1, 2, CURRENT_TIMESTAMP,  CURRENT_TIMESTAMP + INTERVAL '8' hour);
INSERT INTO tournament_venue(tournament_id, venue_id, start_time, stop_time) VALUES(1, 3, CURRENT_TIMESTAMP + INTERVAL '1' day,  CURRENT_TIMESTAMP + INTERVAL '1' day + INTERVAL '2' hour);

INSERT INTO registration(player_id, tournament_id) VALUES('1', 1);
INSERT INTO registration(player_id, tournament_id) VALUES('2', 1);
INSERT INTO registration(player_id, tournament_id) VALUES('3', 1);
INSERT INTO registration(player_id, tournament_id) VALUES('4', 1);
INSERT INTO registration(player_id, tournament_id) VALUES('5', 1);
INSERT INTO registration(player_id, tournament_id) VALUES('6', 1);
INSERT INTO registration(player_id, tournament_id) VALUES('7', 1);
INSERT INTO registration(player_id, tournament_id) VALUES('8', 1);
INSERT INTO registration(player_id, tournament_id) VALUES('9', 1);
INSERT INTO registration(player_id, tournament_id) VALUES('10', 1);

INSERT INTO seed
(player_id, tournament_id, rank)
SELECT r.player_id AS player_id, t.tournament_id AS tournament_id,
  CEIL(ROW_NUMBER() OVER(ORDER BY p.elo DESC)/2) as seed
FROM registration r, player p, tournament t
WHERE t.name = 'Pandemic Ping Pong 2021'
  AND r.player_id = p.player_id
  AND r.tournament_id = t.tournament_id;


INSERT INTO round
(player1, player2, tournament_id, round_number)
WITH player_tourney AS (
  SELECT r.player_id AS player_id, p.elo as rank, t.tournament_id AS tournament_id
  FROM registration r, player p, tournament t
  WHERE t.name = 'Pandemic Ping Pong 2021'    
    AND r.player_id = p.player_id
    AND r.tournament_id = t.tournament_id
)
SELECT player1, player2, tournament_id, 1 AS round_number
FROM(
  SELECT player_id AS player1, ROW_NUMBER() OVER(ORDER BY rank DESC) as rank
  FROM player_tourney
) a
JOIN(
  SELECT player_id AS player2, ROW_NUMBER() OVER(ORDER BY rank ASC) as rank
  FROM player_tourney
) b
ON a.rank = b.rank, 
LATERAL (
  SELECT tournament_id
  FROM player_tourney
)
GROUP BY player1, player2, tournament_id;


INSERT INTO round_result 
(round_id, winner)
SELECT round_id, player1 
FROM round
FETCH NEXT 3 ROWS ONLY;

