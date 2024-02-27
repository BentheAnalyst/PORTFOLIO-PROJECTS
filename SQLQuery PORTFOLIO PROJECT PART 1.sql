select *
from [Portfolio Project]..CovidDeaths
where continent is not null
order by 3,4

--select *
--from [Portfolio Project]..CovidVaccinations
--order by 3,4

--...Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..CovidDeaths
where continent is not null
order by 1,2

--...Looking at Total Cases vs Total Deaths
--... shows the mortality rate if you contract covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
where location like '%state%'
and continent is not null
order by 1,2

--...Looking at the Total cases vs population

select location, date, total_cases, population, (total_cases/population)*100 as PercentofPopulationInfected
from [Portfolio Project]..CovidDeaths
--where location like '%state%'
order by 1,2

--...Looking at Countries with the Highest Infection Rate compared to Population 

select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentofPopulationInfected
from [Portfolio Project]..CovidDeaths
Group by location, population
order by PercentofPopulationInfected desc

--...Looking at the Countries with the highest mortality rate per population

select location, Max(cast(Total_Deaths as int)) as TotalDeathCount
from [Portfolio Project]..CovidDeaths
where continent is not null
Group by location
order by TotalDeathcount desc


--...LEST'S BREAK THINGS DOWN BY CONTINENT

select location, Max(cast(Total_Deaths as int)) as TotalDeathCount
from [Portfolio Project]..CovidDeaths
where continent is null
Group by location
order by TotalDeathCount desc

--...We can also write this query below for the continent breakdown

select continent, Max(cast(Total_Deaths as int)) as TotalDeathCount
from [Portfolio Project]..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc


--...showing continents with the highest death count per population

select continent, Max(cast(Total_Deaths as int)) as TotalDeathCount
from [Portfolio Project]..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathcount desc


--GLOBAL NUMBERS 
--This query shows the total new cases , total deaths and death percentage/mortality rate each day 

select date, Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
--where location like '%state%'
where continent is not null
Group by date
order by 1,2

--Lets find the overall total numbers without date 

select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
--where location like '%state%'
where continent is not null
--Group by date
order by 1,2


--Looking at Total population vs Vaccinations

select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--LOOKING AT NEW VACCINATIONS

select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--USE CTE(	TO Show the percentage of the RollingPeople vaccinated

With PopvsVac (Continent, location, date , population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--USING TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeoplevaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated





--Creating Views to store data for later visualizations 


Create view PercentPopulationVaccinated as
select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated















