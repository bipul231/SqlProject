
select * from PortfolioProject.dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------

--Standardize Date Format

select SaleDateConverted, convert(Date, SaleDate) from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(Date, SaleDate)

ALTER TABLE NashVilleHousing
Add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted = convert(Date, SaleDate)

---------------------------------------------------------------------------------------------------

--Checking For Null values (Property Address)

select PropertyAddress from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is Null

--Populate Property Address Data
-- Joining same tables to check for null values (Finding Reason)
-- isnull - populating b.property address into a.property address

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Updating Dataset

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

----------------------------------------------------------------------------------------------------

-- Breaking Out PropertyAddress into individual Columns (address, city, state)
-- charindex('someting') is a number where that thing is in the string
-- in this case - doing -1 to remove comma (,) at the end
-- (+1) to Remove (,) at the front in city column

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashVilleHousing
Add PropertySplitAddress Nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashVilleHousing
Add PropertySplitCity Nvarchar(255)

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing

-- Breaking Out OwnerAddress into individual Columns (address, city, state)
-- Other Method to Separate address - PARCENAME

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashVilleHousing
Add OwnerSplitAddress Nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashVilleHousing
Add OwnerSplitCity Nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashVilleHousing
Add OwnerSplitState Nvarchar(255)

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in SoldAsVacant column

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' Then 'No'
	   else SoldAsVacant
	   end
from PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' Then 'No'
	   else SoldAsVacant
	   end