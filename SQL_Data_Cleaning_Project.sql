
-- First lets clean data with SQL queries.
Select *
From PortfolioProject.dbo.NashvilleHousing


--Standardize date format.

AlTER TABLE NashvilleHousing
Add SaleDateCovnverted Date;

Update NashvilleHousing
SET SaleDateCovnverted= CONVERT(Date, SaleDate)

Select saleDateCovnverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

--Populate empty property address data.

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null



--Split the property address into seperate column(Address, City, State).

Alter Table NashvilleHousing
Add PropertySplitAddress NVARCHAR(255)

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity NVARCHAR(255)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255)

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity NVARCHAR(255)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState NVARCHAR(255)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select * 
From PortfolioProject.dbo.NashvilleHousing


-- For the SoldAsVacant column change Y to Yes and N to No

Update NashvilleHousing
Set SoldAsVacant= CASE When SoldAsVacant='Y' Then 'Yes'
                       When SoldAsVacant='N' Then 'NO'
					   Else SoldAsVacant
					   End




--Remove Duplicates from data.

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PortfolioProject.dbo.NashvilleHousing
)
DELETE
From RowNumCTE
where row_num > 1


--------------------------------------------
--Delete columns that are not useful

ALTER Table PortfolioProject.dbo.NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


--Let's check the final table
Select *
From PortfolioProject.dbo.NashvilleHousing





                       



