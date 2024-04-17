/* 

Cleaning Data in SQL Queries

*/ 


select * 
from PortfolioProject..nashvillehousing


--Standarize Date Format
select SaleDateConverted, CONVERT(date,saledate)
from PortfolioProject..nashvillehousing

update nashvillehousing
set SaleDate=CONVERT(date,saledate)


alter table nashvillehousing
add SaleDateConverted  date;

update nashvillehousing
set SaleDateConverted=CONVERT(date,saledate)

--populate property address data


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
from PortfolioProject.dbo.nashvillehousing a
join PortfolioProject.dbo.nashvillehousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
	where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from PortfolioProject.dbo.nashvillehousing a
join PortfolioProject.dbo.nashvillehousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

-- breaking out address into into individuall columns (address,city,state)

select PropertyAddress
from PortfolioProject..nashvillehousing

select SUBSTRING(PropertyAddress, 1,CHARINDEX(',',propertyaddress)-1) as address
     , SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress)+1, len(propertyaddress))as address
from PortfolioProject..nashvillehousing

alter table nashvillehousing
add PropertySplitAddress  nvarchar(225);

update nashvillehousing
set PropertySplitAddress=SUBSTRING(PropertyAddress, 1,CHARINDEX(',',propertyaddress)-1)

alter table nashvillehousing
add PropertySplitCity  nvarchar(225)

update nashvillehousing
set PropertySplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress)+1, len(propertyaddress))

select * 
from PortfolioProject..nashvillehousing

--splitting owners address

select 
parsename(replace(owneraddress,',','.'),3) ,
parsename(replace(owneraddress,',','.'),2) ,
parsename(replace(owneraddress,',','.'),1) 
from PortfolioProject..nashvillehousing
where OwnerAddress is not null

alter table nashvillehousing
add ownersplitAddress   nvarchar(225);

update nashvillehousing
set ownersplitAddress=parsename(replace(owneraddress,',','.'),3)

alter table nashvillehousing
add ownersplitCity   nvarchar(225);

update nashvillehousing
set ownersplitCity=parsename(replace(owneraddress,',','.'),2)

alter table nashvillehousing
add ownersplitState   nvarchar(225);

update nashvillehousing
set ownersplitState=parsename(replace(owneraddress,',','.'),1) 

select ownersplitAddress ,ownersplitCity , ownersplitState 
from PortfolioProject..nashvillehousing
where  ownersplitAddress is not null

-- change Y and N to Yes and No in "sold as a vacant' field

select distinct(SoldAsVacant) , count(soldasvacant)
from PortfolioProject..nashvillehousing
group by SoldAsVacant
order by SoldAsVacant

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
End
from PortfolioProject..nashvillehousing

update nashvillehousing
set soldasvacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
End

--removing duplicates

WITH rownumcte as (
select *,
	ROW_NUMBER()over(
	partition by parcelid, 
				propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by
				uniqueid
				)row_num

from PortfolioProject.dbo.nashvillehousing
)
delete
from rownumcte
where row_num >1

--Delete unused colomns

alter table PortfolioProject.dbo.nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress,saledate

