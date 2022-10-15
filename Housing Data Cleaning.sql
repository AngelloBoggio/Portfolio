Select *
from [Portfolio Project]..NashvilleHousing

---- Standardized Date Format

Select SaleDate, convert(date, saledate)
from [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
set SaleDate = convert(date, saledate)

Alter table NashvilleHousing
add SaleDateConverted date;

Update NashvilleHousing
set SaleDateConverted = convert(date, saledate)

select Saledateconverted
from [Portfolio Project]..NashvilleHousing


-- Populare Property Adress data

select *
from [Portfolio Project]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull( a.PropertyAddress , b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull( a.PropertyAddress , b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

--Breaking out Adress into Individual Column (Adress, City, And State)

select PropertyAddress
from [Portfolio Project]..NashvilleHousing
--where PropertyAddress is null

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Adress
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) as City

from [Portfolio Project]..NashvilleHousing

Alter Table Nashvillehousing
add PropertySplitAdress NvarChar(255);

update NashvilleHousing
Set PropertySplitAdress =SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update Nashvillehousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress))


select *
from [Portfolio Project]..NashvilleHousing


Select OwnerAddress
from [Portfolio Project]..NashvilleHousing

select 
PARSENAME(Replace(OwnerAddress, ',', '.'),3)
,PARSENAME(Replace(OwnerAddress, ',', '.'),2)
,PARSENAME(Replace(OwnerAddress, ',', '.'),1)
from [Portfolio Project]..NashvilleHousing

Alter Table Nashvillehousing
add OwnerSplitAdress NvarChar(255);

update NashvilleHousing
Set OwnerSplitAdress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

Alter Table NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update Nashvillehousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)

Alter Table Nashvillehousing
add OwnerSplitState NvarChar(255);

update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)

--Change Y and N to Yes and No in "sold as vacant" field

select Distinct(SoldAsVacant), COUNT(soldAsVacant)
from [Portfolio Project]..NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, case when SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End
from [Portfolio Project]..NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant =case when SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End

--Removing Duplicates

--select *
--from [Portfolio Project]..NashvilleHousing


With RowNUMCTE as(
Select *, 
	ROW_NUMBER() Over ( 
	Partition By ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
				ORDER by UniqueID
				) row_num

from [Portfolio Project]..NashvilleHousing
)
select *
from RowNUMCTE
where row_num > 1
order by PropertyAddress

--deleting unused columns

select * 
from [Portfolio Project]..NashvilleHousing


Alter table [Portfolio Project]..NashvilleHousing
drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table [Portfolio Project]..NashvilleHousing
Drop Column SaleDate







