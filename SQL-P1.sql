use ipl;

-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.


select t1.bidder_id, t1.wins, t1.total_bids, round((t1.wins/t1.total_bids *100),2) as '%ge_Wins'
from
(
select ibd.bidder_id, count(ibd.bid_status) as 'wins', sum(ibp.NO_OF_BIDS) as 'total_bids'
from IPL_Bidding_Details ibd, IPL_Bidder_Points ibp
where bid_status ='Won' and ibd.bidder_id=ibp.bidder_id
group by ibd.bidder_id
) as t1
 order by (t1.wins/t1.total_bids *100) desc;
 
 
-- 2.Display the number of matches conducted at each stadium with stadium name, city from the database. */
 
 select * from ipl_match_schedule;
 
 select s.stadium_id, s.stadium_name,s.city,count(ms.match_id) from ipl_stadium s, ipl_match_schedule ms
  where s.STADIUM_ID = ms.STADIUM_ID group by stadium_id order by STADIUM_ID;
 
  
 -- 3.	In a given stadium, what is the percentage of wins by a team which had won the toss?
 
 
(select s.STADIUM_NAME, im.team_id1 as 'Winner_team_id',it.TEAM_NAME  ,count(im.TOSS_WINNER), count(im.MATCH_WINNER), ( count(im.MATCH_WINNER) /count(im.TOSS_WINNER) * 100) as '% toss(win) is match(win)'
from ipl_match im , IPL_MATCH_SCHEDULE ms, IPL_STADIUM s, IPL_TEAM it
where im.match_id=ms.match_id and s.stadium_id=ms.stadium_id and it.team_id=im.team_id1 and toss_winner=1
group by ms.stadium_id,im.team_id1)
union
(select s.STADIUM_NAME, im.team_id2, it.TEAM_NAME ,count(im.TOSS_WINNER), count(im.MATCH_WINNER), ( count(im.MATCH_WINNER) /count(im.TOSS_WINNER) * 100) as '% toss(win) is match(win)'
from ipl_match im , IPL_MATCH_SCHEDULE ms, IPL_STADIUM s, IPL_TEAM it
where im.match_id=ms.match_id and s.stadium_id=ms.stadium_id and it.team_id=im.team_id2 and toss_winner=2
 group by ms.stadium_id,im.team_id1);
 
 /* 
 --  4.	Show the total bids along with bid team and team name
 */
 select * from ipl_bidder_details;
select *,count(*) Total_bids from 
(select bd.Bid_team,ipl_team.Team_name
from ipl_bidding_details bd
join
ipl_team 
on bd.bid_team=ipl_team.team_id) ipl_team
group by bid_team,team_name;

-- 	Show the team id who won the match as per the win details.*/

select if(match_winner=1,team_id1,team_id2) Team_id_Winners,Win_details
from ipl_match;

-- 	Display total matches played, total matches won and total matches lost by team along with its team name.*/

select its.Team_id,Team_name,sum(matches_played)Total_Matches_Played,
sum(matches_won) Matches_Won,
sum(matches_lost) Matches_lost 
from ipl_team_standings its inner join ipL_Team 
on its.team_ID=ipl_team.team_Id group by its.team_id;

/*7.	Display the bowlers for Mumbai Indians team.*/

select player_id,player_name ,Performance_dtls from ipl_player
where player_id in
(select player_id from IPL_TEAM_PLAYERS
where team_id=(select team_id from ipl_team where team_name='Mumbai Indians' )
and player_role='bowler') ;

/*8.How many all-rounders are there in each team, Display the teams with more than 4*/
select t1.Team_id,Team_name as Team,No_of_allrounders from
(select team_id,count(team_id) No_of_allrounders from IPL_TEAM_PLAYERS
where player_role='All-Rounder'
group by team_id)t1
join
(select team_id,team_name from ipl_team)t2
on t1.team_id=t2.team_id
having no_of_allrounders>4 
order by no_of_allrounders desc;

