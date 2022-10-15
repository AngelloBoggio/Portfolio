Select *
From [Portfolio Project]..CovidDeaths
Order by 3,4


--Select *
--From [Portfolio Project]..CovidVaccinations
--Order by 3,4

--Selectt Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
Order by 1,2


-- Looking at Total cases vs Total deaths
--Shows likelyhood of dying in United states
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%states%'
Order by 1,2

--Looking at total cases vs Population

Select Location, date, Population, total_cases, (total_cases/Population)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Order by 1,2


-- Looking at counries with highest infection rate compared to population

Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
GROUP BY Location, Population
Order by PercentPopulationInfected desc


Select Location, Population, date, Max(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
GROUP BY Location, Population, date
Order by PercentPopulationInfected desc


-- Showing countried with Highest Death Count per Population

Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not Null
Group by Location
Order by TotalDeathCount desc




-- Let's break things down by continent

Select location, Max(cast(Total_deaths as int)) as TotalDeathCount 
From [Portfolio Project]..CovidDeaths
Where continent is Null and location not like '%income%' and location not in ('World', 'European Union', 'International')
Group by location
Order by TotalDeathCount desc


-- showing continents with the highest death count per population

Select Continent, Max(cast(Total_deaths as int)) as TotalDeathCount 
From [Portfolio Project]..CovidDeaths
Where continent is not Null
Group by continent
Order by TotalDeathCount desc



-- Global Numbers

Select sum(new_cases) as total_cases, sum(cast(new_deaths as bigint)) as total_deaths, sum(cast(new_deaths as bigint))/sum(new_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where continent is not null
--group by date
Order by 1,2



--Looking ay total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) Over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--Use CTE


with PopvcVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) Over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvcVac


--Temp Table

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) Over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated




--creating view to store data for later visualizations

create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) Over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select * 
From PercentagePopulationVaccinated

