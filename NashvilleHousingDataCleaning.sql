/* 

Cleaning Data in SQL queries 

*/

SELECT *
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning];

-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning];

UPDATE [Nashville Housing Data for Data Cleaning]
   SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE [Nashville Housing Data for Data Cleaning]
        ADD SaleDateConverted DATE;

UPDATE [Nashville Housing Data for Data Cleaning]
   SET SaleDateConverted = CONVERT(Date, SaleDate);

-- Populate Property Address Data

SELECT *
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning]
--WHERE PropertyAddress IS NULL
 ORDER BY ParcelID;

 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning] AS a
  JOIN ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning] AS b
    ON a.ParcelID = b.ParcelID
   AND a.UniqueID <> b.UniqueID
 WHERE a.PropertyAddress IS NULL; 

 UPDATE a
    SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
   FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning] AS a
   JOIN ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning] AS b
     ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
  WHERE a.PropertyAddress IS NULL;

-- Breaking out Address into Individual Columns (Address, City, State)
-- Property Address
SELECT PropertyAddress
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning];


SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
       SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning];

ALTER TABLE [Nashville Housing Data for Data Cleaning]
        ADD PropertySplitAddress NVARCHAR(255);

UPDATE [Nashville Housing Data for Data Cleaning]
   SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE [Nashville Housing Data for Data Cleaning]
        ADD PropertySplitCity NVARCHAR(255);

UPDATE [Nashville Housing Data for Data Cleaning]
   SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));

-- OwnerAddress

SELECT owneraddress
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning];

SELECT
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3) AS Address,
PARSENAME(REPLACE(OwnerAddress,',', '.'), 2) AS City,
PARSENAME(REPLACE(OwnerAddress,',', '.'), 1) AS State
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning];

ALTER TABLE [Nashville Housing Data for Data Cleaning]
        ADD OwnerSplitAddress NVARCHAR(255);

UPDATE [Nashville Housing Data for Data Cleaning]
   SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3);

ALTER TABLE [Nashville Housing Data for Data Cleaning]
        ADD OwnerSplitCity NVARCHAR(255);

UPDATE [Nashville Housing Data for Data Cleaning]
   SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2);

ALTER TABLE [Nashville Housing Data for Data Cleaning]
        ADD OwnerSplitState NVARCHAR(255);

UPDATE [Nashville Housing Data for Data Cleaning]
   SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1);

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning]
 GROUP BY  SoldAsVacant
 ORDER BY 2;

SELECT SoldAsVacant,
  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
       ELSE SoldAsVacant
        END
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning];

UPDATE [Nashville Housing Data for Data Cleaning]
   SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
                           WHEN SoldAsVacant = 'N' THEN 'No'
                           ELSE SoldAsVacant
                            END;

-- Remove Duplicates
WITH RowNumCTE AS (
SELECT *,
  ROW_NUMBER() OVER(
               PARTITION BY ParcelID,
                            PropertyAddress,
                            SaleDate,
                            SalePrice,
                            LegalReference
                   ORDER BY UniqueID

                   ) AS row_num
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning]
)

SELECT *
  FROM RowNumCTE 
 WHERE row_num > 1;

--DELETE
  FROM RowNumCTE 
 WHERE row_num > 1;


-- Delete Unused Columns

SELECT *
  FROM ProjectPortfolio2.dbo.[Nashville Housing Data for Data Cleaning];

ALTER TABLE [Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, PropertyAddress;