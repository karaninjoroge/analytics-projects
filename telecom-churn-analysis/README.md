# Telecom Churn Analysis

> **Business question:** Which customer segments are most at risk of churning, and what product or commercial intervention would most reduce churn?
> **Tool:** SQL | **Domain:** Retention | **Status:** In Progress

---

## Why This Project

Telecom churn is directly relevant to the Kenyan market — Safaricom has the highest market share in East Africa and actively works to retain subscribers against Airtel and Telkom competition. Understanding churn at a granular level is a skill that translates directly to any subscription product PM role.

---

## Dataset

Using the publicly available IBM Telco Customer Churn dataset (7,043 customers, 21 features).

**Key fields:** tenure, monthly charges, contract type, internet service type, payment method, churn status

---

## Business Questions

1. What is the overall churn rate, and how does it vary by contract type?
2. Which tenure cohort has the highest churn risk?
3. Is there a monthly charges threshold above which churn spikes?
4. Which combination of features is most predictive of churn?
5. Which customer segment, if retained, would generate the most revenue?

---

## SQL Analysis

```sql
-- Q1: Overall churn rate by contract type
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

-- Q2: Churn by tenure cohort (0-12 months, 13-24, 25-36, 36+)
SELECT
    CASE 
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 36 THEN '25-36 months'
        ELSE '36+ months'
    END AS tenure_cohort,
    COUNT(*) AS customers,
    ROUND(
        100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS churn_rate_pct
FROM customers
GROUP BY tenure_cohort
ORDER BY churn_rate_pct DESC;

-- Q3: Revenue at risk from churned customers
SELECT
    contract_type,
    ROUND(SUM(monthly_charges), 2) AS monthly_revenue_lost,
    ROUND(SUM(total_charges), 2) AS total_revenue_lost
FROM customers
WHERE churn = 'Yes'
GROUP BY contract_type
ORDER BY monthly_revenue_lost DESC;
```

---

## Key Findings

*(To be completed after running analysis)*

1. ...
2. ...
3. ...

---

## Product Recommendation

> *"Therefore, the product team should..."*

*(To be completed after analysis)*

---

## Lessons Learned

*(To be completed)*
