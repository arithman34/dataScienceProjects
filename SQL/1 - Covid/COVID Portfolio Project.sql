--select * from PortfolioProject..CovidDeaths order by 3,4

--select * from PortfolioProject..CovidVaccinations order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject..CovidDeaths 
order by 1,2

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%kingdom%'
order by 1,2

select Location, date, Population, total_cases, (total_cases/Population)*100 as InfectionPercentage
from PortfolioProject..CovidDeaths
where location like '%kingdom%'
order by 1,2

select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as HighestInfectionPercentage
from PortfolioProject..CovidDeaths
where continent is not NULL
group by location, population
order by HighestInfectionPercentage desc

select Location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not NULL
group by Location
order by HighestDeathCount desc

select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is NULL
group by location
order by HighestDeathCount desc

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not NULL
group by date
order by 1,2

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not NULL
order by 1,2


--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


with PopvsVac (Continent, location, date, population, new_vaccinations, rollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
select *, (rollingPeopleVaccinated/population)*100 from PopvsVac


drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

select *, (rollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated


create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

select * from PercentPopulationVaccinated