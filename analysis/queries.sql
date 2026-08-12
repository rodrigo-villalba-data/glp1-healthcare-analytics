-- YoY Spending Growth by State
SELECT 
  state,
  EXTRACT(YEAR FROM claim_date) as year,
  SUM(ingredient_cost) as annual_spending,
  LAG(SUM(ingredient_cost)) OVER (
    PARTITION BY state ORDER BY EXTRACT(YEAR FROM claim_date)
  ) as prev_year_spending,
  ROUND(
    ((SUM(ingredient_cost) / LAG(SUM(ingredient_cost)) OVER (
      PARTITION BY state ORDER BY EXTRACT(YEAR FROM claim_date)
    )) - 1) * 100, 1
  ) as yoy_growth_pct
FROM medicare_claims
WHERE drug_name IN ('Semaglutide', 'Tirzepatide')
  AND claim_date >= '2021-01-01'
GROUP BY state, EXTRACT(YEAR FROM claim_date)
ORDER BY state, year;
