-- ============================================================
-- Telecom Churn Analysis
-- Author: Karani Njoroge
-- Date: June 2026
-- Business Question: What drives customer churn and how can we reduce it?
-- ============================================================


-- ============================================================
-- QUERY 1: Overall Churn Rate
-- ============================================================

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers;

-- Expected insight: Establish the baseline churn rate to size the problem.


-- ============================================================
-- QUERY 2: Churn Rate by Contract Type
-- ============================================================

SELECT
    contract_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY contract_type
ORDER BY churn_rate_pct DESC;

-- Expected insight: Month-to-month customers churn at significantly higher rates.
-- PM Implication: Annual contracts are a retention mechanism. Incentivize upgrades.


-- ============================================================
-- QUERY 3: Churn Rate by Tenure Cohort
-- ============================================================

SELECT
    CASE
        WHEN tenure_months <= 6 THEN '0-6 months'
        WHEN tenure_months <= 12 THEN '7-12 months'
        WHEN tenure_months <= 24 THEN '13-24 months'
        WHEN tenure_months <= 48 THEN '25-48 months'
        ELSE '48+ months'
    END AS tenure_cohort,
    COUNT(*) AS total_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY tenure_cohort
ORDER BY MIN(tenure_months);

-- Expected insight: New customers (0-6 months) churn at highest rates.
-- PM Implication: Onboarding is the highest-leverage retention investment.


-- ============================================================
-- QUERY 4: Impact of Support Services on Churn
-- ============================================================

SELECT
    tech_support,
    online_security,
    COUNT(*) AS total_customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY tech_support, online_security
ORDER BY churn_rate_pct DESC;

-- Expected insight: Customers without tech support and online security churn more.
-- PM Implication: Bundle these services in onboarding — they are retention tools, not just features.


-- ============================================================
-- QUERY 5: Revenue Impact of Churn
-- ============================================================

SELECT
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN monthly_charge ELSE 0 END), 2) AS monthly_revenue_lost,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN monthly_charge * 12 ELSE 0 END), 2) AS annualized_revenue_at_risk,
    ROUND(AVG(CASE WHEN churn = 'Yes' THEN monthly_charge ELSE NULL END), 2) AS avg_churned_customer_value
FROM customers;

-- Expected insight: Quantify the business problem in revenue terms.
-- PM Implication: Use revenue impact to prioritize retention investment vs. acquisition.


-- ============================================================
-- QUERY 6: High-Value Churners (Priority Intervention Segment)
-- ============================================================

SELECT
    customer_id,
    tenure_months,
    monthly_charge,
    contract_type,
    tech_support,
    online_security
FROM customers
WHERE
    churn = 'Yes'
    AND monthly_charge > (SELECT AVG(monthly_charge) FROM customers)
    AND tenure_months < 12
ORDER BY monthly_charge DESC
LIMIT 100;

-- Purpose: Identify high-value customers who churned early — most recoverable segment.
-- PM Implication: This segment is a priority for win-back campaigns or exit interview research.
