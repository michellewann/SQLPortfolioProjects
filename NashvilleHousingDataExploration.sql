/*

Analyzing Data in SQL

*/

SELECT *
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning];

--Retriving relevant data we are using

SELECT PropertySplitCity, LandUse, SaleDate, SalePrice, SoldAsVacant, YearBuilt, TotalValue
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
WHERE YearBuilt IS NOT NULL
  AND TotalValue IS NOT NULL
ORDER BY 1; 

--Average SalesPrice per location

SELECT PropertySplitCity, COUNT(*) AS num_property, ROUND(AVG(SalePrice),2) AS AverageSalePrice
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
WHERE YearBuilt IS NOT NULL
  AND TotalValue IS NOT NULL
  AND (LandUse = 'Mobile Home'
   OR LandUse = 'Triplex'
   OR LandUse = 'Duplex'
   OR LandUse = 'Single Family'
   OR LandUse = 'Quadplex')
GROUP BY PropertySplitCity
ORDER BY 2 DESC;

--Average SalesPrice based on LandUse

SELECT LandUse, COUNT(*) AS num_property, ROUND(AVG(SalePrice),2) AS AverageSalePrice
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
WHERE YearBuilt IS NOT NULL
  AND TotalValue IS NOT NULL
  AND (LandUse = 'Mobile Home'
   OR LandUse = 'Triplex'
   OR LandUse = 'Duplex'
   OR LandUse = 'Single Family'
   OR LandUse = 'Quadplex')
GROUP BY LandUse
ORDER BY 2 DESC;

--Looking at SaleDate and AverageSalePrice

SELECT SaleDate, SUM(SalePrice) AS TotalSales
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
WHERE YearBuilt IS NOT NULL
  AND TotalValue IS NOT NULL
  AND (LandUse = 'Mobile Home'
   OR LandUse = 'Triplex'
   OR LandUse = 'Duplex'
   OR LandUse = 'Single Family'
   OR LandUse = 'Quadplex')
GROUP BY SaleDate
ORDER BY 1;

--Finding the most expensive and the least expensive property based on OwnerCity

SELECT OwnerSplitCity, ROUND(MIN(SalePrice),2) AS MinSalePrice, ROUND(MAX(SalePrice),2) AS MaxSalePrice
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
WHERE YearBuilt IS NOT NULL
  AND TotalValue IS NOT NULL
  AND (LandUse = 'Mobile Home'
   OR LandUse = 'Triplex'
   OR LandUse = 'Duplex'
   OR LandUse = 'Single Family'
   OR LandUse = 'Quadplex')
GROUP BY OwnerSplitCity
ORDER BY 1;

--Finding the most expensive and the least expensive property based on LandUse

SELECT LandUse, ROUND(MIN(SalePrice),2) AS MinSalePrice, ROUND(MAX(SalePrice),2) AS MaxSalePrice
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
WHERE YearBuilt IS NOT NULL
  AND TotalValue IS NOT NULL
  AND (LandUse = 'Mobile Home'
   OR LandUse = 'Triplex'
   OR LandUse = 'Duplex'
   OR LandUse = 'Single Family'
   OR LandUse = 'Quadplex')
GROUP BY LandUse
ORDER BY 1;

--Potential Outliers

SELECT *
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
 WHERE LandUse = 'Single Family'
   AND SalePrice = 100;
  
SELECT *
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
 WHERE LandUse = 'Single Family'
   AND SalePrice = 10750000.00;

--YearBuilt vs. Average Sale Price Perentage Change
WITH SalePriceBuiltYear AS (
SELECT YearBuilt, SalePrice, LAG(SalePrice)
                                            OVER(
                                              PARTITION BY YearBuilt
                                              ORDER BY YearBuilt
                                            ) AS SalePriceYear
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
 WHERE YearBuilt IS NOT NULL
   AND TotalValue IS NOT NULL
   AND (LandUse = 'Mobile Home'
    OR LandUse = 'Triplex'
    OR LandUse = 'Duplex'
    OR LandUse = 'Single Family'
    OR LandUse = 'Quadplex')
--GROUP BY YearBuilt
--ORDER BY 2;
)

SELECT YearBuilt, AVG((SalePrice - SalePriceYear)*100 / SalePriceYear) AS AvgSalePriceChange
  FROM SalePriceBuiltYear
 GROUP BY YearBuilt
 ORDER BY 1;

--SaleDate vs. Average Sale Price Change Percentage

WITH SalePriceSaleDate AS (
SELECT SaleDate, SalePrice, LAG(SalePrice)
                                            OVER(
                                              PARTITION BY SaleDate
                                              ORDER BY SaleDate
                                            ) AS SalePriceYear
  FROM NashvilleHousing.dbo.[Nashville Housing Data for Data Cleaning]
 WHERE YearBuilt IS NOT NULL
   AND TotalValue IS NOT NULL
   AND (LandUse = 'Mobile Home'
    OR LandUse = 'Triplex'
    OR LandUse = 'Duplex'
    OR LandUse = 'Single Family'
    OR LandUse = 'Quadplex')
--GROUP BY YearBuilt
--ORDER BY 2;
)

SELECT SaleDate, AVG((SalePrice - SalePriceYear)*100 / SalePriceYear) AS AvgSalePriceChange
  FROM SalePriceSaleDate
 GROUP BY SaleDate
 ORDER BY 1;







