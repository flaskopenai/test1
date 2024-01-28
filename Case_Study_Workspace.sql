SELECT 
  c.crime_id, 
  c.classification, 
  c.date_charged, 
  c.hearing_date, 
  c.hearing_date - c.date_charged AS days_between
FROM crimes c
WHERE c.hearing_date - c.date_charged > 14;
SELECT
  o.officer_id,
  o.last || ', ' || o.first AS officer_name,
  o.precinct,
  CASE SUBSTR(o.precinct, 2, 1)
    WHEN 'C' THEN 'City Center'
    WHEN 'H' THEN 'Harbor'
    WHEN 'A' THEN 'Airport'
    WHEN 'W' THEN 'Westside'
    ELSE 'Unknown'
  END AS community_assignment
FROM officers o
WHERE o.status = 'A';
SELECT
  s.criminal_id,
  UPPER(c.last) || ', ' || UPPER(c.first) AS criminal_name,
  s.sentence_id,
  TO_CHAR(s.start_date, 'Month DD, YYYY') AS start_date,
  MONTHS_BETWEEN(s.end_date, s.start_date) AS sentence_length_months
FROM sentences s
JOIN criminals c ON s.criminal_id = c.criminal_id;
SELECT
  UPPER(c.last) || ', ' || UPPER(c.first) AS criminal_name,
  cc.charge_id,
  TO_CHAR(cc.fine_amount + cc.court_fee, '$99999.99') AS total_amount_owed,
  TO_CHAR(cc.amount_paid, '$99999.99') AS amount_paid,
  TO_CHAR((cc.fine_amount + cc.court_fee) - NVL(cc.amount_paid, 0), '$99999.99') AS amount_owed,
  TO_CHAR(cc.pay_due_date, 'Month DD, YYYY') AS payment_due_date
FROM crime_charges cc
JOIN crimes cr ON cc.crime_id = cr.crime_id
JOIN criminals c ON cr.criminal_id = c.criminal_id
WHERE (cc.fine_amount + cc.court_fee) - NVL(cc.amount_paid, 0) > 0;
SELECT
  UPPER(c.last) || ', ' || UPPER(c.first) AS criminal_name,
  p.start_date AS probation_start_date,
  ADD_MONTHS(p.start_date, 2) AS review_date
FROM sentences s
JOIN criminals c ON s.criminal_id = c.criminal_id
JOIN prob_officers po ON s.prob_id = po.prob_id
JOIN prob_contact pc ON po.status = pc.prob_cat
JOIN prob_officers p ON s.prob_id = p.prob_id
WHERE pc.con_freq = 'Monthly' AND MONTHS_BETWEEN(p.end_date, p.start_date) > 2;
ACCEPT crime_id NUMBER PROMPT 'Enter Crime ID: ' DEFAULT 25344031
ACCEPT filing_date CHAR PROMPT 'Enter Filing Date (MM DD YYYY): ' DEFAULT '02 13 2009'
ACCEPT hearing_date CHAR PROMPT 'Enter Hearing Date (MM DD YYYY): ' DEFAULT '02 27 2009'
INSERT INTO appeals (appeal_id, crime_id, filing_date, hearing_date)
VALUES (appeals_id_seq.NEXTVAL, :crime_id, TO_DATE(:filing_date, 'MM DD YYYY'), TO_DATE(:hearing_date, 'MM DD YYYY'));
