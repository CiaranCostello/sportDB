drop table player;
drop table team;
drop table play_for;
drop table sponsor;
drop table tournament;
drop table league;
drop table play_in;

create table player
(
f_name varchar(20) not null,
s_name varchar(20) not null,
id varchar(20) not null,
jersey_no int not null,
date_of_birth date not null,
gender varchar(1) not null check (gender in ('m','f')),
primary key (id)
);

insert into player values('Ciaran', 'Costello', 10102, 9, '04-jan-95', 'm');
insert into player values('Robbie', 'Brennan', 10101, 0, '15-sep-90', 'm');
insert into player values('Stephen', 'Dalkins', 0, 13, '15-jul-94', 'm');
insert into player values('Stephen', 'Jones', 1, 18, '15-jul-94', 'm');
insert into player values('Richard', 'Eyres', 3, 99, '17-oct-89', 'm');
insert into player values('Kate', 'Boylan', 2, 20, '30-dec-95', 'f');
insert into player values('Conor','Casey',5,61,'14-feb-91','m');
insert into player values('David','Lally',6,77,'01-jul-90','m');

create table team
(
name varchar(20) not null,
team_gender varchar(1) not null check (team_gender in ('m','f')),
captain_id int not null,
away_color varchar(20) not null,
home_color varchar(20) not null,
primary key (name, team_gender),
constraint captain_player
foreign key (captain_id)
references player(id)
);

insert into team values('Ranelagh', 'm', 10101, 'white','black');
insert into team values('Trinity' , 'm', 0, 'white', 'black');
insert into team values('Trintiy', 'f', 2, 'white', 'black');
insert into team values('UCD', 'm', 1, 'purple', 'blue');
insert into team values('Gravity', 'm', 3, 'pink', 'green');
insert into team values('Jabba the Huck', 'm', 6, 'grey and blue', 'white and blue');

create table play_for
(
team_name varchar(20) not null,
team_gender varchar(1) not null,
player_id int not null,
constraint play4_pk primary key (team_name, team_gender, player_id),
constraint play4_fk_player
foreign key (player_id)
references player (id),
constraint play4_fk_team
foreign key (team_name, team_gender)
references team (name, team_gender)
);

insert all
into play_for values('Ranelagh', 'm', 10101)
into play_for values('Ranelagh', 'm', 1)
into play_for values('UCD', 'm', 1)
into play_for values('Gravity', 'm', 3)
into play_for values('Gravity', 'm', 10102)
into play_for values('Gravity', 'm', 0)
into play_for values('Trinity', 'm', 10102)
into play_for values('Trinity', 'm', 0)
into play_for values('Jabba the Huck', 'm', 5)
into play_for values('Jabba the Huck', 'm', 6)
select * from dual;

create table sponsor
(
name varchar(20) not null,
business varchar(20),
primary key (name)
);

insert all
into sponsor values('Five', 'Ultimate Frisbee equipment')
into sponsor values('5 degrees brewry', 'Craft Beer')
into sponsor values('Skyd Magazine', 'reporting on ultimate frisbee events')
into sponsor values('E.R.I.C', 'Cancer education')
into sponsor values('Boojum', 'Burritos')
select * from dual;

create table tournament
(
name varchar(20) not null,
sponsor varchar(20),
location varchar(100) not null,
starting_year date not null,
organiser int not null,
primary key (name, location),
constraint tourna_org
foreign key (organiser)
references player (id),
constraint tourna_sponsor
foreign key (sponsor)
references sponsor (name)
);

insert all
into tournament values('Siege of Limerick', 'Skyd Magazine', 'UL', '06-mar-07', 4)
into tournament values('Tea Party', 'Boojum', 'Trinity Sports Facility', '20-oct-2010', 0)
into tournament values('St Hatricks', '5 degrees brewry', 'Ballybinge Castle', '11-mar-13', 10101)
into tournament values('Indoor InterVarsities', 'E.R.I.C', 'DCU', '02-dec-05', 2)
into tournament values('Outdoor InterVarsities', 'Five', 'Trinity Sports Facility', '25-apr-05', 0)
select * from dual;

create table league
(
name varchar(50) not null,
sponsor varchar(20),
location varchar(100) not null,
organiser int not null,
startdate date not null,
frequency varchar(20) not null,
enddate date not null,
primary key (name, startdate),
constraint leag_org
foreign key (organiser)
references player (id),
constraint leag_sponsor
foreign key (sponsor)
references sponsor (name)
);

insert into league values('Dublin Summer League 2015', 'Boojum', 'Fairview Park, Dublin', 5, '01-jun-15', 'weekly', '05-aug-15');

create table plays_in
(
id number(10),
team_name varchar(20) not null,
team_gender varchar(1) not null,
tournament_name varchar(20) not null,
tournament_location varchar(100) not null,
primary key (id),
constraint tourna_foreign
foreign key (tournament_name, tournament_location)
references tournament (name, location),
constraint team_foreign
foreign key (team_name, team_gender)
references team (name, team_gender)
);

create or replace sequence plays_in_sequence start with 1 increment by 1;

create or replace trigger plays_in_bir
before insert on plays_in
for each row
when (new.id is null)
begin 
:new.id := plays_in_sequence.nextval;
end plays_in_bir;
/

insert all
into plays_in (team_name, team_gender, tournament_name, tournament_location) values ('Ranelagh','m','Siege of Limerick','UL')
into plays_in (team_name, team_gender, tournament_name, tournament_location) values ('Gravity','m','Siege of Limerick','UL')
into plays_in (team_name, team_gender, tournament_name, tournament_location) values ('Jabba the Huck','m','Siege of Limerick','UL')
into plays_in (team_name, team_gender, tournament_name, tournament_location) values ('Trinity','m','Siege of Limerick','UL')
into plays_in (team_name, team_gender, tournament_name, tournament_location) values ('UCD','m','Siege of Limerick','UL')
into plays_in (team_name, team_gender, tournament_name, tournament_location) values ('UCD','m','Tea Party','Trinity Sports Facility')
into plays_in (team_name, team_gender, tournament_name, tournament_location) values ('Trinity','m','Tea Party','Trinity Sports Facility')
into plays_in (team_name, team_gender, tournament_name, tournament_location) values ('Trinity','f','Tea Party','Trinity Sports Facility')
select * from dual;

create or replace view open_teams_at_teaParty as select team_name from plays_in where team_gender = 'm' and tournament_name = 'Tea Party';


