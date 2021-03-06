
1. SELECT COUNT(u_id) FROM USERS;

2. SELECT COUNT (send_amount_currency) FROM TRANSFERS WHERE send_amount_currency='CFA' ;

3. SELECT COUNT(u_id) FROM TRANSFERS WHERE send_amount_currency='CFA' ;

4. SELECT *FROM agent_transactions WHERE when_created BETWEEN ‘2018-01-01’ AND ‘2018-12-01’ ORDER BY when_created;

5. CREATE TABLE net_transfers AS (SELECT agent_transactions.agent_id, agent_transactions.amount,transfers.receive_amount_scalar, transfers.when_created FROM agent_transactions FULL OUTER JOIN transfers ON agent_transactions.agent_id = transfers.dest_merchant_id WHERE transfers.when_created BETWEEN '2020-06-20' AND '2020-06-28' AND transfers.kind='AGENT');


(For the next couple of queries, we are assuming that the past week falls between 21st and 28th June as per the data)

6. 
SELECT City, Volume
INTO atx_volume_city_summary 
FROM ( Select agents.city AS City, count(agent_transactions.atx_id) AS Volume FROM agents 
INNER JOIN agent_transactions 
ON agents.agent_id = agent_transactions.agent_id
where (agent_transactions.when_created BETWEEN '2020-06-21' AND '2020-06-28')
GROUP BY agents.city) as atx_volume_summary; 


7.
SELECT COUNT(atx_id) AS volume,city,country
FROM public.agent_transactions
INNER JOIN agents ON agents.agent_id = agent_transactions.agent_id
WHERE agent_transactions.when_created BETWEEN '2020-06-21' AND '2020-06-28'
GROUP BY city, country; 
 
8.
CREATE TABLE send_volume_by_country_and_kind AS
SELECT SUM(transfers.send_amount_scalar), wallets.ledger_location, array_agg(transfers.kind) 
FROM transfers
LEFT OUTER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id
WHERE transfers.when_created BETWEEN'2020-06-21' AND '2020-06-28'
GROUP BY wallets.ledger_location;

9.
CREATE TABLE transaction_by_country_and_kind AS
SELECT COUNT (transfers.transfer_id), wallets.ledger_location, array_agg(transfers.kind) 
FROM transfers
LEFT OUTER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id
WHERE transfers.when_created BETWEEN'2020-06-21' AND '2020-06-28'
GROUP BY wallets.ledger_location;


10.
SELECT source_wallet_id, send_amount_scalar FROM transfers WHERE send_amount_currency = 'CFA'
AND send_amount_scalar > 10000000 AND when_created > now()-interval '1 month’;
