# SQL_Project

# India Election Analysis 2024 Using SQL

## Project Overview
This project provides a comprehensive analysis of the 2024 Indian parliamentary elections. 
It examines the total number of seats, state-wise and constituency-wise distributions, 
party-wise and alliance-wise performance, top candidates by votes, and overall election statistics. 
The insights reveal how different parties and alliances performed across India.

## Database Used
- MySQL / MySQL Workbench
- Tables included:
  - `constituencywise_results` — constituency-level election data
  - `constituencywise_details` — candidate-level details
  - `statewise_results` — state-level results
  - `partywise_results` — party-wise results and alliances
  - `states` — list of Indian states

## SQL Techniques Used
- SQL Commands (for creating, modifying, and updating tables)
- Joins (to combine data from multiple tables)
- CTEs (Common Table Expressions for ranking and aggregations)
- Temporary Tables (for intermediate calculations)
- Aggregation and Conditional Calculations (COUNT, SUM, CASE WHEN, etc.)

## Queries in This Project
1. Total number of seats across India
2. Total seats available for elections in each state
3. Add a column to identify each party’s alliance (NDA, I.N.D.I.A, OTHER)
4. Total seats won by each party alliance across India
5. Total seats won by each party alliance in every state
6. Total seats won by each party within their alliance
7. Candidate with the highest total votes in a selected constituency
8. Top 2 parties with highest votes in each state using a CTE
9. Number of candidates contested from each party using a temporary table
10. Summary report for Telangana — seats, candidates, parties, votes, EVM votes, and postal votes
