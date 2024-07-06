/*

Cleaning Data in SQL Queries

*/

select *
from dbo.NashvilleHousing;



-- Standardize Date Format

select SaleDate, CONVERT(date, SaleDate)
from dbo.NashvilleHousing;

alter table dbo.NashvilleHousing
alter column SaleDate date;

update dbo.NashvilleHousing
set  SaleDate = CONVERT(date, SaleDate);

select SaleDate
from dbo.NashvilleHousing;


-- Populating Property Address data

select *
from dbo.NashvilleHousing;

select *
from dbo.NashvilleHousing
where PropertyAddress is null;

select *
from dbo.NashvilleHousing
order by ParcelID;

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.NashvilleHousing a
join dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null;


Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from dbo.NashvilleHousing a
join dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null;




-- Breaking out Address into Individual Column ( Address, City, State)

select PropertyAddress
from dbo.NashvilleHousing;



select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
from dbo.NashvilleHousing;


alter table dbo.NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update dbo.NashvilleHousing
set  PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);


alter table dbo.NashvilleHousing
add PropertySplitCity Nvarchar(255);

update dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));

select *
from dbo.NashvilleHousing;


select OwnerAddress
from dbo.NashvilleHousing;

select 
PARSENAME(replace(OwnerAddress, ',', '.'),3),
PARSENAME(replace(OwnerAddress, ',', '.'),2),
PARSENAME(replace(OwnerAddress, ',', '.'),1)
from dbo.NashvilleHousing;

alter table dbo.NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update dbo.NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'),3);

alter table dbo.NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'),2);

alter table dbo.NashvilleHousing
add OwnerSplitState Nvarchar(255);

update dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'),1);


select *
from dbo.NashvilleHousing;



-- Change Y and N to yes and no in "Sold as Vacant" field


select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from dbo.NashvilleHousing
group by SoldAsVacant
order by 2;

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from dbo.NashvilleHousing;


update dbo.NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end;



-- Remove Duplicate

select *,
row_number()over(
partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference 
			order by ParcelID) as row_num
from dbo.NashvilleHousing
order by ParcelID;

with duplicate_cte as (
select *,
row_number()over(
partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference 
			order by ParcelID) as row_num
from dbo.NashvilleHousing
)

select *
from duplicate_cte
where row_num > 1;


with duplicate_cte as (
select *,
row_number()over(
partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference 
			order by ParcelID) as row_num
from dbo.NashvilleHousing
)

delete
from duplicate_cte
where row_num > 1;


-- Remove Unused Columns

select *
from dbo.NashvilleHousing;

alter table dbo.NashvilleHousing
drop column PropertyAddress, TaxDistrict, OwnerAddress;