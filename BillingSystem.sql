USE [master]
GO
/****** Object:  Database [BillingSystem]    Script Date: 07.04.2023 17:27:53 ******/
CREATE DATABASE [BillingSystem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BillingSystem', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\BillingSystem.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BillingSystem_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\BillingSystem_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [BillingSystem] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BillingSystem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BillingSystem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BillingSystem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BillingSystem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BillingSystem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BillingSystem] SET ARITHABORT OFF 
GO
ALTER DATABASE [BillingSystem] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BillingSystem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BillingSystem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BillingSystem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BillingSystem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BillingSystem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BillingSystem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BillingSystem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BillingSystem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BillingSystem] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BillingSystem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BillingSystem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BillingSystem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BillingSystem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BillingSystem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BillingSystem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BillingSystem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BillingSystem] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BillingSystem] SET  MULTI_USER 
GO
ALTER DATABASE [BillingSystem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BillingSystem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BillingSystem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BillingSystem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BillingSystem] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BillingSystem] SET QUERY_STORE = OFF
GO
USE [BillingSystem]
GO
/****** Object:  User [client]    Script Date: 07.04.2023 17:27:53 ******/
CREATE USER [client] FOR LOGIN [Client] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [client]
GO
/****** Object:  Table [dbo].[Rates]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rates](
	[Name] [varchar](100) NOT NULL,
	[Minutes] [time](7) NOT NULL,
	[Duration] [int] NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[Cost] [money] NOT NULL,
 CONSTRAINT [PK_RATES] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[RatesList]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[RatesList]() returns table
as return(Select * from Rates where Rates.IsEnabled=1)
GO
/****** Object:  UserDefinedFunction [dbo].[RatesDescMinutes]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[RatesDescMinutes]() returns table
as return (select top(100)* from Rates Order by Rates.[Minutes] Desc)
GO
/****** Object:  Table [dbo].[Users]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[User] [varchar](10) NOT NULL,
	[UserName] [varchar](255) NOT NULL,
	[StartTariff] [datetime] NOT NULL,
	[Tariff] [varchar](100) NOT NULL,
	[MinutesRemaining] [time](7) NOT NULL,
	[Balance] [money] NOT NULL,
 CONSTRAINT [PK_USERS] PRIMARY KEY CLUSTERED 
(
	[User] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[remainingMinutes]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[remainingMinutes](@number varchar(10)) 
returns table as return(Select MinutesRemaining from Users Where [User]=@number)
GO
/****** Object:  Table [dbo].[Calls]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Calls](
	[User] [varchar](10) NOT NULL,
	[Start] [time](7) NOT NULL,
	[Duration] [time](7) NOT NULL,
 CONSTRAINT [PK_CALLS] PRIMARY KEY CLUSTERED 
(
	[User] ASC,
	[Start] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Calls]  WITH CHECK ADD  CONSTRAINT [Calls_fk0] FOREIGN KEY([User])
REFERENCES [dbo].[Users] ([User])
GO
ALTER TABLE [dbo].[Calls] CHECK CONSTRAINT [Calls_fk0]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [Users_fk0] FOREIGN KEY([Tariff])
REFERENCES [dbo].[Rates] ([Name])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [Users_fk0]
GO
/****** Object:  StoredProcedure [dbo].[changeTariff]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[changeTariff](@number varchar(10), @tariff varchar(100))
as
begin
if (Select Balance from Users Where User=@number)>(Select [Cost] from Rates Where [Name]=@tariff)
UPDATE Users
    SET Tariff=@tariff, StartTariff=CURRENT_TIMESTAMP, 
	MinutesRemaining=(Select [Minutes] from Rates Where [Name]=@tariff),
	Balance=(Select Balance from Users Where User=@number)-(Select [Cost] from Rates Where [Name]=@tariff)
    WHERE [User]=@number
end
GO
/****** Object:  StoredProcedure [dbo].[ChargeOff]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ChargeOff](@phone varchar(10), @call time, @duration time)
as
begin
Insert into Calls([User],Start,Duration)
values(@phone, @call, @duration)
Update Users
Set MinutesRemaining=Cast(DateDiff(minute,MinutesRemaining, (Select Duration From Calls Where Start=(Select Max(Start) From Calls Where [User]=@phone))) as datetime) 
Where [User]=@phone
end
GO
/****** Object:  StoredProcedure [dbo].[createUser]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[createUser](@phone varchar(10), @name varchar(255), @startTariff datetime, @tariff varchar(100), @minutes time, @balance money)
as
begin
SET NOCOUNT ON 
insert into Users([User],UserName,StartTariff,Tariff,MinutesRemaining, Balance)
values(@phone, @name, @startTariff, @tariff, @minutes, @balance)
end
GO
/****** Object:  StoredProcedure [dbo].[editTariff]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[editTariff](@name varchar(100), @minutes time, @duration int, @isEnabled bit, @cost money)
as
begin
Update Rates
set Minutes=@minutes, Duration=@duration,IsEnabled=@isEnabled,Cost=@cost
Where [Name]=@name
end
GO
/****** Object:  StoredProcedure [dbo].[replenishBalance]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[replenishBalance](@phone varchar(10), @amount money)
as
begin
Update Users
set Balance=Balance+@amount
Where [User]=@phone
end 
GO
/****** Object:  StoredProcedure [dbo].[sendMoney]    Script Date: 07.04.2023 17:27:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sendMoney](@userPhone varchar(10),@addresseePhone varchar(10), @money money)
as
begin
Update Users
Set Balance=Balance-@money
Where [User]=@userPhone
Update Users
Set Balance=Balance+@money
Where [User]=@addresseePhone
end
GO
USE [master]
GO
ALTER DATABASE [BillingSystem] SET  READ_WRITE 
GO
