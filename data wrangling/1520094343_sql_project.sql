/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name FROM country_club.Facilities WHERE membercost!=0

/* Q2: How many facilities do not charge a fee to members? */
SELECT count(1) FROM country_club.Facilities WHERE membercost=0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance FROM country_club.Facilities where membercost < (monthlymaintenance * 0.20)

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
select * from country_club.Facilities where facid in (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
select name,
case
	WHEN monthlymaintenance > 100 THEN "expensive"
	ELSE "cheap"
END as monthlymaintenance_label, monthlymaintenance
from country_club.Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT b.firstname, b.surname
FROM country_club.Members
INNER JOIN
(SELECT firstname, surname, MAX(joindate) as maxdate
FROM country_club.Members) AS b ON
    joindate = b.maxdate

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
select distinct concat(b.firstname, " ", b.surname) as member_name, a.facility_name from
(select memid,
 case WHEN facid = 0 THEN 'Tennis Court 1'ELSE 'Tennis Court 2' END as facility_name from country_club.Bookings where facid in (0,1)) as a
left join
(select firstname, memid, surname from country_club.Members) as b
on a.memid = b.memid order by member_name

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
select case when Members.memid = 0 THEN Bookings.slots * Facilities.guestcost
ELSE Bookings.slots * Facilities.membercost END as cost, concat(Members.firstname, " ", Members.surname) as client_name, Facilities.name as facilitiy_name from country_club.Members, country_club.Bookings, country_club.Facilities where Bookings.facid = Facilities.facid and Bookings.memid = Members.memid and substring(Bookings.starttime,1,10)='2012-09-14' order by cost desc

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
select
case when a.memid = 0 THEN a.slots * b.guestcost
ELSE a.slots * b.membercost END as cost, concat(c.firstname, " ", c.surname) as client_name, b.name as facilitiy_name from
(select facid, memid, slots, starttime from country_club.Bookings where substring(starttime,1,10)='2012-09-14') as a
inner join
(select facid, guestcost, membercost, name from country_club.Facilities) as b
on a.facid = b.facid
inner join
(select firstname, surname, memid from country_club.Members) as c
on a.memid = c.memid
order by cost desc


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
select
sum(case
	when a.memid = 0 then a.slots * b.guestcost
	else a.slots * b.membercost end) as cost, b.name from (
(select facid, memid, slots from country_club.Bookings) as a
inner join
(select facid, guestcost, membercost, name from country_club.Facilities) as b
on a.facid = b.facid
        )
group by name order by cost desc
