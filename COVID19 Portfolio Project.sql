select *
from PortfolioProject..CovidDeaths$
order by 1,2

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
order by 1,2

--Looking at total cases vs total deaths
--shows liklihood of dying if you contract covid in your country 
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where location like '%lebanon%'
order by 1,2

--looking at the total cases vs the population
--shows what percentage of populatioin got covid
select Location, date,population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths$
where location like '%lebanon%'
order by 1,2

--looking at countries with highest infection rate compared to population

select Location,population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths$
group by location, population
order by PercentagePopulationInfected desc

--Break things down by continent
--showing the countries with the highest death count per population
select continent,max(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent 
order by totaldeathcount desc

--Global numbers

select date, sum(new_cases) as totalCases, sum(cast(new_deaths as int))as totalDeaths,sum(cast(new_deaths as int)) /sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2

--looking at total population vs vaccination

select dea.continent, dea.location,dea.date,population,vac.new_vaccinations
from PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3
