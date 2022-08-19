--select * from PortfolioProject..CovidVaccinations
--order by 3,4

--Selecting Data to use

select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Looking at total_cases vs toatal_deaths

select Location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
where location like '%states%' 
order by 1,2

--Total_cases vs Population
--What percentage of population got covid

select Location, date, total_cases, population, 
(total_cases / population)*100 as Percent_Population_Infected 
from PortfolioProject..CovidDeaths
where location like '%states%' 
order by 1,2

--Looking at countries with highest Infection_Rate compared to Population

select Location, population, max(total_cases) as HighestInfectionCount, 
 max((total_cases / population))*100 as Percent_Population_Infected 
from PortfolioProject..CovidDeaths
--where location like '%states%' 
group by Location, population
order by Percent_Population_Infected desc

--Showing Countries with Highest Death Count per Population
--In table Total_deaths is in Char value so we need to convert it into int
--Continent have to have not null value

select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%' 
where continent is not null
group by Location
order by TotalDeathCount desc

--BREAKDOWN BY CONTINENT
--Showing Continents with Highest Death Count per Population

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%states%' 
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

--Looking at Total Population vs Total Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * , (RollingPeopleVaccinated/population)*100 from PopvsVac


Drop Table if exists #PercentPopulationVaccinated
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
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.Location
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select * , (RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated


--Creating View 
Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.Location
order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated
