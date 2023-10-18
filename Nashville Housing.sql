SELECT *
FROM [Portfolio Project]..[Nashville Housing]

--Standardize Data Format

SELECT SaleDate, CAST(SaleDate AS DATE) AS ConvertedSaleDate
FROM [Portfolio Project]..[Nashville Housing]


ALTER TABLE [Portfolio Project]..[Nashville Housing] ADD ConvertedSaleDate DATE


UPDATE [Portfolio Project]..[Nashville Housing]
SET ConvertedSaleDate = CAST(SaleDate AS DATE)



--Populate Property Address

SELECT *
FROM [Nashville Housing]..[Housing Info]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress , ISNULL(A.PropertyAddress , B.PropertyAddress)
FROM [Portfolio Project]..[Nashville Housing] A
JOIN [Portfolio Project]..[Nashville Housing] B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL



UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress , B.PropertyAddress)
FROM [Portfolio Project]..[Nashville Housing] A
JOIN [Portfolio Project]..[Nashville Housing] B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL



--Breaking out Address into Individual

SELECT PropertyAddress
FROM [Portfolio Project]..[Nashville Housing]


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) AS Address 
FROM [Portfolio Project]..[Nashville Housing]


ALTER TABLE [Portfolio Project]..[Nashville Housing] ADD PropertySplitAddress VARCHAR (255)

UPDATE [Portfolio Project]..[Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1)


ALTER TABLE [Portfolio Project]..[Nashville Housing] ADD PropertySplitCity VARCHAR (255)

UPDATE [Portfolio Project]..[Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))



--Breaking out Owner Address

SELECT OwnerAddress
FROM [Portfolio Project]..[Nashville Housing]

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM [Portfolio Project]..[Nashville Housing]


ALTER TABLE [Portfolio Project]..[Nashville Housing] ADD OwnerSplitAddress VARCHAR (255)

UPDATE [Portfolio Project]..[Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE [Portfolio Project]..[Nashville Housing] ADD OwnerSplitCity VARCHAR (255)

UPDATE [Portfolio Project]..[Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE [Portfolio Project]..[Nashville Housing] ADD OwnerSplitState VARCHAR (255)

UPDATE [Portfolio Project]..[Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) 




--Change Y and N to Yes and No in "Sold As Vacant"

SELECT DISTINCT(SoldAsVacant) , COUNT(SoldAsVacant)
FROM [Portfolio Project]..[Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE
     WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
     ELSE SoldAsVacant
END
FROM [Portfolio Project]..[Nashville Housing]



UPDATE [Portfolio Project]..[Nashville Housing]
SET SoldAsVacant = (CASE
     WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
     ELSE SoldAsVacant
END)



--Remove Duplicates

SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY ParcelID) AS RN
FROM [Portfolio Project]..[Nashville Housing]


SELECT [UniqueID ]
FROM (SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY ParcelID) AS RN
FROM [Portfolio Project]..[Nashville Housing]) X
WHERE X.RN > 1


DELETE 
FROM [Portfolio Project]..[Nashville Housing]
WHERE [UniqueID ]IN ( SELECT [UniqueID ]
FROM (SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference ORDER BY ParcelID) AS RN
FROM [Portfolio Project]..[Nashville Housing]) X
WHERE X.RN > 1)



--Delete Unused Columns

SELECT *
FROM [Portfolio Project]..[Nashville Housing]

ALTER TABLE [Portfolio Project]..[Nashville Housing]
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict