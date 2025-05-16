Select * from FootballMatch;

SELECT
    m.[Date]
    ,m.HomeTeam
    ,m.AwayTeam
    ,m.FTHG
    ,m.FTAG
    ,FTR
FROM
    FootballMatch m;

    

SELECT TOP 5
    m.[Date]
    ,m.[HomeTeam]
    ,m.[AwayTeam]
    ,m.[FTHG]
    ,m.[FTAG]
    ,m.[FTR]
FROM
    FootballMatch m
ORDER BY
    m.[Date] DESC;

--which month had the most matches?
SELECT
    MONTH(m.[Date]) AS [Month]
    ,COUNT(*) AS [Matches]      
FROM
    FootballMatch m
GROUP BY
    MONTH(m.[Date])
ORDER BY
    COUNT(*) DESC;

-- which dates had more than one match?
SELECT
    m.[Date]
    ,COUNT(*) AS [Matches]
FROM
    FootballMatch m
GROUP BY
    m.[Date]
HAVING  
    COUNT(*) > 1
ORDER BY
    [Matches] DESC;

--Add "DROP TABLE IF EXISTS #EPLResults" at top if creating a temp table and INTO
--statement is placed after first section of code before the FROM statement below

-- Create a Premier League Table using cte

; With MatchScoresPerTeam AS
(
SELECT
    [HomeTeam] AS [Team],
    [FTHG] AS [GoalsFor],
    [FTAG] AS [GoalsAgainst],
    FTR,
    CASE [FTR] WHEN 'H' THEN 'W' WHEN 'D' Then 'D' WHEN 'A' then 'L' END as Result,
    CASE WHEN [FTHG] > [FTAG] THEN 1 ELSE 0 END AS [Win],
    CASE WHEN [FTHG] = [FTAG] THEN 1 ELSE 0 END AS [Draw],
    CASE WHEN [FTHG] < [FTAG] THEN 0 ELSE 0 END AS [Loss]
FROM FootballMatch

UNION ALL

SELECT
    [AwayTeam] AS [Team],
    [FTAG] AS [GoalsFor],
    [FTHG] AS [GoalsAgainst],
    FTR,
    CASE [FTR] WHEN 'A' THEN 'W' WHEN 'D' Then 'D' WHEN 'H' then 'L' END as Result,
    CASE WHEN [FTAG] > [FTHG] THEN 1 ELSE 0 END AS [Win],
    CASE WHEN [FTAG] = [FTHG] THEN 1 ELSE 0 END AS [Draw],
    CASE WHEN [FTAG] < [FTHG] THEN 0 ELSE 0 END AS [Loss]
FROM FootballMatch
)
--Select * from MatchScoresPerTeam
--Order by Team;
SELECT
    [Team]
    ,Count(r.[Team]) as Played
    ,SUM(r.GoalsFor) AS [GoalsFor]
    ,SUM(r.GoalsAgainst) AS [GoalsAgainst]
    ,SUM(r.GoalsFor) - SUM(r.GoalsAgainst) AS [GD]
    ,Sum(r.[WIN]) AS [Won]
    ,Sum(r.[Draw]) AS [Drawn]
    ,Sum(r.[Loss]) AS [Lost]
    ,Sum(r.Win)*3 + Sum(r.Draw) as [Points]
FROM MatchScoresPerTeam r
Group BY
    [Team] 
ORDER BY
    Sum(r.Win)*3 + Sum(r.Draw) DESC

--Alternative
SELECT
    r.Team
    , COUNT(*) as Played
    , sum(r.GoalsFor) as GoalsFor
    , sum(r.GoalsAgainst) as GoalsAgainst
    , sum(r.GoalsFor) - sum(r.GoalsAgainst) as GD
    , sum(CASE WHEN r.Result = 'W' THEN 1 ELSE 0 END) aS Won
    , sum(CASE WHEN r.Result = 'D' THEN 1 ELSE 0 END) aS Drawn
    , sum(CASE WHEN r.Result = 'L' THEN 1 ELSE 0 END) aS Lost
    , SUM(CASE r.Result WHEN 'W' THEN 3 WHEN 'D' THEN 1 ELSE 0 END ) as Points
from #EPLResults r
GROUP BY r.Team
ORDER BY r.Team;
 
 
 




