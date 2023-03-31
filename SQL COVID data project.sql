--Exploratory COVID World Data Analysis
--Our World in Data COVID Dataset


--Start by taking a look at the 2 tables being used
select *
from portfolioprojects..coviddeaths
order by 3,4

select *
from portfolioprojects..covidvaccinations
order by 3,4


-- Select the data that we will use
select Location, date, total_cases, new_cases, total_deaths, population
from portfolioprojects..coviddeaths
where continent is NOT NULL
order by 1,2


--looking at total cases vs total deaths
--This will show the likelihood of dying if you contract Covid-19

ALTER TABLE coviddeaths
ALTER COLUMN total_cases numeric;

ALTER TABLE coviddeaths
ALTER COLUMN total_deaths numeric;

select Location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as Death_Percentage
from portfolioprojects..coviddeaths
where continent is NOT NULL
order by 1,2


-- Looking at the total cases vs the population
select Location, date, population, total_cases, (total_cases / population)*100 as Infection_Rate
from portfolioprojects..coviddeaths
Where continent is NOT NULL
--and location like '%states%'
Order by 1,2


--looking at countries with highest infection rates compared to population

select Location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases / population)*100 as PercentPopulationInfected
from portfolioprojects..coviddeaths
where continent is not null
--and location like '%states%'
group by Location, population
Order by PercentPopulationInfected DESC


--Showing the countries with the highest death count per population

select Location, MAX(total_deaths) as TotalDeathCount
from portfolioprojects..coviddeaths
--where location like '%states%'
Group by Location
Order by TotalDeathCount DESC

--Noticed an issue with the data: Some entries have a NULL for continent column, fixed by adding 'where continent is not null clause'

select *
from portfolioprojects..coviddeaths
where continent is not null
order by 3,4

select Location, MAX(total_deaths) as TotalDeathCount
from portfolioprojects..coviddeaths
where continent is NOT NULL
--and location like '%states%'
Group by Location
Order by TotalDeathCount DESC


--Looking at Death Counts by location

select location, MAX(total_deaths) as TotalDeathCount
from portfolioprojects..coviddeaths
--where location like '%states%'
where continent is NULL
Group by location
Order by TotalDeathCount DESC



--Looking at the continents with the highest death count 

select continent, MAX(total_deaths) as TotalDeathCount
from portfolioprojects..coviddeaths
--where location like '%states%'
where continent is NOT NULL
Group by continent
Order by TotalDeathCount DESC


--Global Numbers: Total Cases, Total Deaths, and DeathRate

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as numeric)) as total_deaths, SUM(cast(new_deaths as numeric))/SUM(New_Cases)*100 as DeathRate
From PortfolioProjects..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Vaccine

Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
, SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths death
Join PortfolioProjects..CovidVaccinations vacc
	On death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
, SUM(CONVERT(numeric,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths death
Join PortfolioProjects..CovidVaccinations vacc
	On death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentVaccinated
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for future visualizations

Create View PercentPopulationVaccinated as
Select death.continent, death.location, death.date, death.population, vacc.new_vaccinations
, SUM(CONVERT(int,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeaths death
Join PortfolioProjects..CovidVaccinations vacc
	On death.location = vacc.location
	and death.date = vacc.date
where death.continent is not null 
