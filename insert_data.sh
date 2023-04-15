#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

# writing teams table

# checking to skip header line
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then

  # add winning teams
  # select team if exist from table
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  # verify if winner team exist
    if [[ -z $TEAM_WINNER_ID ]]
    then
    # insert team if not exist
      INSERT_TEAM_WI=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_WI == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
      fi
  # select team if exist from table
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

# add opposing teams
  # select team if exist from table
     TEAM_OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # verify if opposing team exist

    if [[ -z $TEAM_OP_ID ]]
    then
    # insert team if not exist

      INSERT_TEAM_OP=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_OP == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $OPPONENT"
      fi
    # select team if exist from table
    TEAM_OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

  fi
  # end of writing teams table


  # writing games table
  if [[ -n $TEAM_WINNER_ID || -n $TEAM_OP_ID ]]
  then
   INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id,opponent_id, winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$TEAM_WINNER_ID,$TEAM_OP_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  fi

done
