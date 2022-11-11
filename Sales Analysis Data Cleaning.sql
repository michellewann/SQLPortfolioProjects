/* Cleaned DIM_Date Table */

SELECT [DateKey],
       [FullDateAlternateKey] AS date,
       --[DayNumberOfWeek],
       [EnglishDayNameOfWeek] AS Day,
       --[SpanishDayNameOfWeek],
       --[FrenchDayNameOfWeek],
       --[DayNumberOfMonth],
       --[DayNumberOfYear],
       [WeekNumberOfYear] AS WeekNo,
       [EnglishMonthName] AS Month,
       --[SpanishMonthName],
       --[FrenchMonthName],
       [MonthNumberOfYear] AS MonthNo,
       [CalendarQuarter] AS Quarter,
       [CalendarYear] AS Year
       --[CalendarSemester],
       --[FiscalQuarter],
       --[FiscalYear],
       --[FiscalSemester]
  FROM [AdventureWorksDW2019].[dbo].[DimDate]
 WHERE [CalendarYear] >= 2019

/* Cleaned DIM_Customers Table */

SELECT c.[CustomerKey] AS CustomerKey,
       --[GeographyKey],
       --[CustomerAlternateKey],
       --[Title],
       c.[FirstName],
       --[MiddleName],
       c.[LastName],
       CONCAT(c.FirstName,' ',c.LastName) AS FullName, 
       --[NameStyle],
       --[BirthDate],
       --[MaritalStatus],
       --[Suffix],
         CASE c.[Gender] WHEN 'M' THEN 'Male'
                         WHEN 'F' THEN 'Female'
                         ELSE c.[Gender] 
                          END AS Gender,
       --[EmailAddress],
       --[YearlyIncome],
       --[TotalChildren],
       --[NumberChildrenAtHome],
       --[EnglishEducation],
       --[SpanishEducation],
       --[FrenchEducation],
       --[EnglishOccupation],
       --[SpanishOccupation],
       --[FrenchOccupation],
       --[HouseOwnerFlag],
       --[NumberCarsOwned],
       --[AddressLine1],
       --[AddressLine2],
       --[Phone],
       c.[DateFirstPurchase],
       --[CommuteDistance],
       g.City AS CustomerCity --Joined to Geography Table
  FROM [AdventureWorksDW2019].[dbo].[DimCustomer] AS c
  JOIN AdventureWorksDW2019.dbo.DimGeography AS g
    ON c.GeographyKey = g.GeographyKey
 ORDER BY c.CustomerKey 

/* Cleaned DIM_Product Table */

SELECT p.[ProductKey],
       p.[ProductAlternateKey] AS ProductItemCode,
       --[ProductSubcategoryKey],
       --[WeightUnitMeasureCode],
       --[SizeUnitMeasureCode],
       p.[EnglishProductName] AS ProductName,
       pc.EnglishProductCategoryName, -- Joined from ProductCategory Table
       ps.EnglishProductSubcategoryName, -- Joined from ProductSubcategory Table
       --[SpanishProductName],
       --[FrenchProductName],
       --[StandardCost],
       --[FinishedGoodsFlag],
       p.[Color] AS ProductColour,
      --[SafetyStockLevel]
      --[ReorderPoint],
      --[ListPrice],
      p.[Size] AS ProductSize,
      --[SizeRange],
      --[Weight],
      --[DaysToManufacture],
      p.[ProductLine],
      --[DealerPrice],
      --[Class],
      --[Style],
      p.[ModelName] AS ProductModelName,
      --[LargePhoto],
      p.[EnglishDescription] AS ProductDescription,
      --[FrenchDescription],
      --[ChineseDescription],
      --[ArabicDescription],
      --[HebrewDescription],
      --[ThaiDescription],
      --[GermanDescription],
      --[JapaneseDescription],
      --[TurkishDescription],
      --[StartDate],
      --[EndDate],
      ISNULL(p.[Status], 'Outdated') AS ProductStatus
  FROM [AdventureWorksDW2019].[dbo].[DimProduct] AS p
  JOIN [AdventureWorksDW2019].[dbo].[DimProductSubcategory] AS ps
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
  JOIN [AdventureWorksDW2019].[dbo].[DimProductCategory] AS pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey

/* Cleaned FactInternetSalesa Table */

SELECT [ProductKey],
       YEAR(CONVERT(date, CONVERT(char(8),[OrderDateKey]))) AS OrderYear,
       [DueDateKey],
       [ShipDateKey],
       [CustomerKey],
       --[PromotionKey],
       --[CurrencyKey],
       --[SalesTerritoryKey],
       [SalesOrderNumber],
       --[SalesOrderLineNumber],
       --[RevisionNumber],
       --[OrderQuantity],
       --[UnitPrice],
       --[ExtendedAmount],
       --[UnitPriceDiscountPct],
       --[DiscountAmount],
       --[ProductStandardCost],
       [TotalProductCost],
       [SalesAmount]
      --[TaxAmt],
      --[Freight],
      --[CarrierTrackingNumber],
      --[CustomerPONumber],
      --[OrderDate]
      --[DueDate],
      --[ShipDate]
  FROM [AdventureWorksDW2019].[dbo].[FactInternetSales]
 WHERE YEAR(CONVERT(date, CONVERT(char(8),[OrderDateKey]))) >= YEAR(GetDate()) - 2 --Ensures we are bringing the date two years ago from extraction
 ORDER BY OrderDateKey