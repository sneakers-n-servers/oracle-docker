#!/usr/bin/env bash

GEN_NUM="${1:-250}"
[[ "$GEN_NUM" =~ ^[1-9][0-9]*$ ]] || {
  echo 1>&2 "ERROR: must pass valid number to generate, received $GEN_NUM"
  exit 1
}

for i in $(seq $GEN_NUM); do
  person="$(curl -s https://helloacm.com/api/rig/)"
  fname="$(sed -r 's/^\"([^ ]+) .*$/\1/' <<< $person)"
  lname="$(sed -r 's/^[^ ]+ ([^\\]+)\\.*$/\1/' <<< $person)"
  phone="$(sed -r 's/^.+\\n(.+)\\n\"$/\1/' <<< $person)"
  email="$(echo $fname.$lname@gwu.edu | tr '[A-Z]' '[a-z]')"
  elo="$(shuf -i1-100 -n1)"
  echo "INSERT INTO player (first_name, last_name, email, phone, elo) VALUES ('$fname', '$lname', '$email', '$phone', $elo);"
done
echo 

GEN_VENUE="${2:-10}"
for i in $(seq "$GEN_VENUE"); do
  venue="$(curl -s https://helloacm.com/api/rig/ | sed -r 's/\\n/|/g')"
  addr="$(awk -F'|' '{print $2}' <<< $venue)"
  post="$(awk -F'|' '{print $3}' <<< $venue)" 
  city="$(sed -r 's/^([^,]+),.+$/\1/' <<< $post)"
  state="$(awk -F' ' '{print $2}' <<< $post)"
  zip="$(awk -F' ' '{print $(NF)}' <<< $post)"
  name="$(shuf -n3 /usr/share/dict/words | tr '\n' ' ' | tr -d "'")"
  max=$(shuf -i20-100 -n1)

  echo "INSERT INTO venue (state, city, street, zipcode, name, max_capacity) VALUES('$state', '$city', '$addr', '$zip', '$name', '$max');"   
done
echo

echo "
INSERT INTO tournament (name, start_time, stop_time, registration_fee) VALUES('Pandemic Ping Pong 2021', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '2' day, 100);
INSERT INTO tournament (name, start_time, stop_time, registration_fee) VALUES('GW Masters 2021', CURRENT_TIMESTAMP + INTERVAL '5' day, CURRENT_TIMESTAMP + INTERVAL '6' day, 200);
"

echo "
INSERT INTO tournament_venue(tournament_id, venue_id, start_time, stop_time) VALUES(1, 1, CURRENT_TIMESTAMP,  CURRENT_TIMESTAMP + INTERVAL '8' hour);
INSERT INTO tournament_venue(tournament_id, venue_id, start_time, stop_time) VALUES(1, 2, CURRENT_TIMESTAMP,  CURRENT_TIMESTAMP + INTERVAL '8' hour);
INSERT INTO tournament_venue(tournament_id, venue_id, start_time, stop_time) VALUES(1, 3, CURRENT_TIMESTAMP + INTERVAL '1' day,  CURRENT_TIMESTAMP + INTERVAL '1' day + INTERVAL '2' hour);
"

for i in $(seq $GEN_NUM); do
  echo "INSERT INTO registration(player_id, tournament_id) VALUES('$i', 1);"
done

echo "
INSERT INTO seed
(player_id, tournament_id, rank)
SELECT r.player_id AS player_id, t.tournament_id AS tournament_id,
  CEIL(ROW_NUMBER() OVER(ORDER BY p.elo DESC)/2) as seed
FROM registration r, player p, tournament t
WHERE t.name = 'Pandemic Ping Pong 2021'
  AND r.player_id = p.player_id
  AND r.tournament_id = t.tournament_id;
"

echo "
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
"

echo "
INSERT INTO round_result 
(round_id, winner)
SELECT round_id, player1 
FROM round
FETCH NEXT 3 ROWS ONLY;
"
