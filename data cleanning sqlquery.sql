select * 
from [dbo].[nashvillehousing]

--standarize the date format
--we are gonna take the time off 
select 
saledateconverted,
convert(date,saledate)
from [dbo].[nashvillehousing]

update [dbo].[nashvillehousing]
set saledate = convert(date,saledate)

alter table [dbo].[nashvillehousing]
add saledateconverted date;

update [dbo].[nashvillehousing]
set saledateconverted = CONVERT(date,saledate)


--populate property adress 
select * 
from [dbo].[nashvillehousing]
order by parcelid

select 
a.parcelid,
a.PropertyAddress,
isnull(a.propertyaddress,b.propertyaddress),
b.parcelid,
b.PropertyAddress
from [dbo].[nashvillehousing] a
join [dbo].[nashvillehousing] b
on a.parcelid = b.parcelid
and a.[uniqueID]<> b.[uniqueID]
where a.propertyaddress is null



update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from [dbo].[nashvillehousing] a
join [dbo].[nashvillehousing] b
on a.parcelid = b.parcelid
and a.[uniqueID]<> b.[uniqueID]
where a.propertyaddress is null


--breaking out address data
select propertyaddress
from [dbo].[nashvillehousing]


select 
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress) -1) as address,
SUBSTRING(propertyaddress, charindex(',',propertyaddress) + 1, len(propertyaddress)) as address

from [dbo].[nashvillehousing]

alter table [dbo].[nashvillehousing]
add propertysplitaddress nvarchar(255);

update [dbo].[nashvillehousing]
set propertysplitaddress = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress) -1)

alter table [dbo].[nashvillehousing]
add propertysplitcity nvarchar(255);

update [dbo].[nashvillehousing]
set propertysplitcity = SUBSTRING(propertyaddress, charindex(',',propertyaddress) + 1, len(propertyaddress))

select *
from [dbo].[nashvillehousing]

select
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from [dbo].[nashvillehousing]




--change y and N to yes and no in solid as vacant field
select distinct(soldasvacant),count(SoldAsVacant)
from [dbo].[nashvillehousing]
group by SoldAsVacant
order by 2

--

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end 
from [dbo].[nashvillehousing]

update nashvillehousing
set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end 
from  [dbo].[nashvillehousing]


--remove duplicate 

WITH RowNumCTE AS(
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

From [dbo].[nashvillehousing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [dbo].[nashvillehousing]


--delete unsed column
select * 
from [dbo].[nashvillehousing]
alter table [dbo].[nashvillehousing]
drop column owneraddress,taxdistrict,propertyaddress,saledate

select *
from [dbo].[nashvillehousing]