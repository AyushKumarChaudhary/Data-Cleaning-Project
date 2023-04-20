
--Cleaning Data in Sql queries

Select *
From dbo.NashvilleHousing

--Standarize Date Format

Select SaleDateConverted, Convert(Date,Saledate)
From dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate =  Convert(Date,Saledate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted =  Convert(Date,Saledate)

--Populate Propert Address Data

Select *
From dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Individual Colums (Address,city,State)

select PropertyAddress
from dbo.NashvilleHousing

Select
PARSENAME(REPLACE(PropertyAddress,',','.'),2) as PropertySplitAddress
,PARSENAME(REPLACE(PropertyAddress,',','.'),1) as PropertySplitCity
from dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress,',','.'),2) 

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = PARSENAME(REPLACE(PropertyAddress,',','.'),1) 


select OwnerAddress
from dbo.NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as OwnerSplitAddress
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) as OwnerSplitCity
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) as OwnerSplitCountry
from dbo.NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitCountry Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCountry = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


--Change Y an N to Yes and No in "Sold as Vacant"

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
from dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
from dbo.NashvilleHousing

select *
from dbo.NashvilleHousing



--Remove Duplicates

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
			     PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

from dbo.NashvilleHousing
--order by ParcelID
)
Select *
from RowNumCTE
Where row_num > 1
--Order by PropertyAddress



--Delete Unused Columns

Select*
From dbo.NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress

Alter Table NashvilleHousing
Drop Column Saledate








